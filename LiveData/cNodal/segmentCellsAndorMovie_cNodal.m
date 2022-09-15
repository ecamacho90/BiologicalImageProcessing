
function segmentCellsAndorMovie_cNodal(direc,pos,chan,paramfile,outfile)
%% imread faster than bfopen, regionprops faster than image2peaks, medianfilt2 better than
% smoothimage

% background subtraction and processing could be moved prior to segmentation
%% 
% latest function to process movies from Andor Spinning Disk microscope. Assumes images are max intensity projections and are formatted
% the default Andor way, i.e., files are split only by Position and Time.




% This is much faster than old functions that relied on image2peaks 


%%
global userParam;

try
    eval(paramfile);
catch
    error('Could not evaluate paramfile command');
end

ff=readAndorDirectory(direc);

if length(chan) < 2
    nImages = 1;
else
    nImages=length(chan)-1;
end

if isempty(ff.t)
    ntimefiles = 1;
else
    ntimefiles = length(ff.t);
end

nimg = 1;
%% main loop over frames (time)
for ii=1:ntimefiles  %ii accounts for the fact that the movie for a certain position can be split into several subfiles because it is too long
    
 disp(ff);
 disp(['Reading ii=',num2str(ii)])
 
   % tic;
    
    filename = getAndorFileName(ff,pos,ii-1,[],[]);
    
    %reader = bfGetReader(filename);
    
    %nT = reader.getSizeT;
    nT = length(imfinfo(filename));  %number of timepoints in the particular movie file
    h5file = geth5name(filename); 
    h5file = [h5file(1:end-3),'_Simple Segmentation.h5'];
   % h5file = geth5nameMask3(filename); %ilastik update defaults to prefix "mask3" 3/13/18 jkm
    if exist(h5file,'file')
        usemask = 1;
        [masks,bgMask] = readIlastikFileNucBG(h5file); %Load masks corresponding to this file
        
%         if isfield(userParam,'maskDiskSize')
%         masks = imopen(masks,strel('disk',userParam.maskDiskSize));
%         end

    else
       error('h5 file not found');
    end
    
    for jj = 1:nT  %for each time point of this position in this file
        
         disp(['Reading jj=',num2str(jj)])

        % Clean and order images
        % ----------------------
        %nuc = bfMaxIntensity(reader,jj,chan(1));
        img = imread(filename,jj); %read the image
        nuc = img(:,:,chan(1));  %take the nuclear subimage
        if length(chan) == 1
            fimg = nuc;
        else
        
        for xx=2:length(chan) %order the images
            %fimg(:,:,xx-1) = bfMaxIntensity(reader,jj,chan(xx));
            fimg(:,:,xx-1) = img(:,:,chan(xx));
        end
        end
        
        disp(['frame ' int2str(nimg) ' of file: ' filename]);
        % setup string to hold all the error messages for this frame number
        userParam.errorStr = sprintf('frame= %d\n', nimg);
        

        
%         %record some info about image file.
%         imgfiles(nimg).filestruct=ff;
%         imgfiles(nimg).pos = pos;
%         imgfiles(nimg).w = chan;
        
        % pre process image <-- this will probably be moved to take place during MaxI to save time
        %------------------
%         nuc2 = medfilt2(presubBackground_provided_cNodal(nuc,1));
%         fimg2 = medfilt2(presubBackground_provided_cNodal(fimg,2));

nuc2 = medfilt2(nuc);
        fimg2 = medfilt2(fimg);
        %[nuc2, fimg2] =preprocessImages(nuc,fimg);
        
        %%
        
        % Clean background mask
        % ---------------------
        fgMask = imclose(~bgMask(:,:,jj),strel('disk',5));
        bgMaskprov = imerode(~fgMask,strel('disk',userParam.bgMargin));
        fgMask = imerode(fgMask,strel('disk',userParam.bgMargin));
        fgMask = ~bgMaskprov;
 
        %%
        %% Visualize original mask from Ilastik:
        %--------------------------------------
        channeltoplot = 1;
        Rawnucplot=imadjust(mat2gray(nuc2));
        % allocate empty array for data
        R = bgMaskprov;
        B = fgMask;
        % show image for time t, cat concatenates nuclei and cell segmentation data
        % to colour them differently
        imshow(cat(3,R,B,Rawnucplot),[]);


%%        
        % Make clean nuclear mask
        % -----------------------
        nucmaskraw = masks(:,:,jj);
        nucmask = nuclearCleanup(nucmaskraw,userParam.cleanupOptions);
        
%% Visualize old vs new mask
% 
% Rawnucplot=imadjust(mat2gray(nuc2));
% masknew=nucmask-imerode(nucmask,strel('disk',2));
% oldmask=nucmaskraw-imerode(nucmaskraw,strel('disk',2));
% 
% subplot(1,2,1)
% imshow(cat(3,oldmask,Rawnucplot,oldmask),[])
% title('Old mask')
% 
% subplot(1,2,2)
% imshow(cat(3,masknew,Rawnucplot,masknew),[])
% title('Improved mask')

%%
              
        % Make cytoplasmic mask
        % -----------------------
        nucmaskmarg = imdilate(nucmask,strel('disk',userParam.cytoMargin)); %Dilate nucleus by cytoMargin to create a margin between nucleus and cytoplasm (this margin width is set to 0 now)
        
        dilated = imdilate(nucmask, strel('disk',userParam.cytoSize + userParam.cytoMargin)); %Dilate nucleus to account for cytoplasm
        basin = bwdist(dilated); %Do watershed in the provisional cytoplasmic mask
        basin = imimposemin(basin, nucmask);
        L = watershed(basin);
       

        
        %%
        
        statscyt = regionprops(L, 'PixelIdxList');
        cytCC = struct('PixelIdxList', {cat(1,{statscyt.PixelIdxList})});
        
        % Exclude outside dilated nuclei, exclude nuclei before cleanup and
        % exclude background
        for cci = 1:numel(cytCC.PixelIdxList)
            CCPIL = cytCC.PixelIdxList{cci};
            CCPIL = CCPIL(dilated(CCPIL));    % exclude outside dilated nuclei
            CCPIL = CCPIL(~nucmaskraw(CCPIL));% exclude nuclei before cleanup
            if userParam.cytoMargin > 0
                CCPIL = CCPIL(~nucmaskmarg(CCPIL)); % exclude margin around nuclei
            end
            if ~isempty(fgMask)
                CCPIL = CCPIL(fgMask(CCPIL));% exclude background 
            end
            %% Plot cytoplasmic mask
            close all
            cytmaskprov=zeros(size(Rawnucplot));
            cytmaskprov(CCPIL)=1;
           
            Rawnucplot=imadjust(mat2gray(fimg2));
            imshow(cat(3,cytmaskprov,Rawnucplot,nucmask),[])
            title('Old mask')
            pause()
%%
            
            cytCC.PixelIdxList{cci} = CCPIL;
        end        
        
%         stats.cellData(ti).cytLevel = zeros([numel(cytCC.PixelIdxList) numel(opts.dataChannels)]);
%         stats.cellData(ti).cytLevelAvg = zeros([1 numel(opts.dataChannels)]);
        
        % regionprops and indices from nuclear mask
        % follows cyt so we can shrink without introducing new var
        %-------------------------------------------

        % shrink instead of erode to preserve number of connected
        % components to not introduce mismatch between nuclear and
        % cytoplasmic mask
        %%
        if userParam.nucShrinkage > 0
            nucmask = bwmorph(nucmask,'shrink',userParam.nucShrinkage);
        end
        
%         %% Visualize old vs new mask
% 
% Rawnucplot=imadjust(mat2gray(nuc2));
% masknew=nucmask-imerode(nucmask,strel('disk',2));
% oldmask=nucmaskraw-imerode(nucmaskraw,strel('disk',2));
% 
% subplot(1,2,1)
% imshow(cat(3,oldmask,Rawnucplot,oldmask),[])
% title('Old mask')
% 
% subplot(1,2,2)
% imshow(cat(3,masknew,Rawnucplot,masknew),[])
% title('Improved mask')
%%
        
        % initialize cellData
        %---------------------------------------------------
                
        nucCC = bwconncomp(nucmask);
        statsI = regionprops(nucCC, 'Area', 'Centroid','PixelIdxList');
        centroids = cat(1,statsI.Centroid);
        areas = cat(1,statsI.Area);
        nCells = nucCC.NumObjects;
        
        ImageData(nimg).ncells = nCells;
        ImageData(nimg).XY = centroids;
        ImageData(nimg).area = areas;
        ImageData(nimg).nucLevelAvg = zeros([1 numel(chan)]);
        ImageData(nimg).nucLevelStd = zeros([1 numel(chan)]);
        ImageData(nimg).background = zeros([1 numel(chan)]);
        
        
      
        
        %run routines to segment cells, do stats, and get the output matrix
        try
            
                if max(max(masks(:,:,jj))) == 0
                    disp('Empty mask. Continuing...');
                    peaks{nimg}=[];
                    statsArray{nimg}=[];
                    nimg = nimg + 1;

                    continue;
                end
                %disp(['Using ilastik mask frame ' int2str(jj)]);
                
                
                
                %% Save Data
%                 statsNucMarker = regionprops(maskN, nuc2, 'Area' ,'PixelIdxList', 'Centroid','MeanIntensity');
%                 statsFimg = regionprops(maskN, fimg2, 'MeanIntensity');
                
                for celln = 1:nCells
                    
                    %Nuclear marker intensity
                    nucPixIdx = nucCC.PixelIdxList{celln};
                    stats(celln).NucMarkerNucIntensity = mean(nuc2(nucPixIdx));
                    
                    %Smad nuclear intensity
                    stats(celln).GreenNucIntensity = mean(fimg2(nucPixIdx));
                    
                    %Smad cytoplasmic intensity
                    cytPixIdx = cytCC.PixelIdxList{celln};
                    stats(celln).CytLevel = mean(fimg2(cytPixIdx));
                    
                    %Area, Centroid and PixelIdxList
                    stats(celln).NucArea = round(statsI(celln).Area);
                    stats(celln).Centroid = statsI(celln).Centroid;
                    stats(celln).PixelIdxList = statsI(celln).PixelIdxList;
                    
                    
                end                
               
                xy = stats2xy(stats);
                for iImages = 1:length(stats)
                    datacell(iImages,:) = [xy(iImages,1) xy(iImages,2) stats(iImages).NucArea -1 stats(iImages).NucMarkerNucIntensity stats(iImages).GreenNucIntensity stats(iImages).CytLevel 0];
                end
                
                %[outdat, ~, statsN] = image2peaks(nuc2, fimg2, masks(:,:,jj));
%                 mem = segmentMembrane(fimg2, cytmask(:,:,jj)); 
                
           
        catch err
            disp(['Error with image ' int2str(ii) ' continuing...']);
            
            peaks{nimg}=[];
            statsArray{nimg}=[];
            nimg = nimg + 1;

            %rethrow(err);
            continue;
        end
        
        % copy over error string, NOTE different naming conventions in structs userParam
        % vs imgfiles.
%         imgfiles(nimg).errorstr = userParam.errorStr;
%         if userParam.verboseSegmentCells
%             display(userParam.errorStr);
%         end
%         % compress and save the binary mask for nuclei
%         imgfiles(nimg).compressNucMask = compressBinaryImg([statsN.PixelIdxList], size(nuc) );
        
        

        peaks{nimg}=datacell;
        statsArray{ii}=stats;
        clear stats;
        clear datacell;
        nimg = nimg + 1; %counts up for frames (time)
        %toc;
    end
end

dateSegmentCells = clock;
save(outfile,'ImageData','peaks','statsArray','userParam','dateSegmentCells');


