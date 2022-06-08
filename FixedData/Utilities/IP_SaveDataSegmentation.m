function IP_SaveDataSegmentation

global analysisParam;
%% Define paths
%-----------------------------
%-----------------------------

% clear all;

%analysisParam.pathnamedata = '/Users/elenacamachoaguilar/Dropbox (Personal)/Rice/Experiments/181029_Commitment_time_7/Data/181109_BMPCommitment_Experiment_7_Timepoints/';
dataDir = analysisParam.pathnamedata;%
addpath(dataDir);

% Path to Ilastiks exported files:
datasetname = '/exported_data';


if analysisParam.bgsubstractionopt == 2
    
    if ~isfield(analysisParam,'bgvalues')
        IP_ComputeBGSubstractionlevelsUsingSegmentation

    end        
    
end


%% Define variables
%-----------------------------
%-----------------------------

% Set the number of images taken per well:
ImagesperWell1 = 1;
% analysisParam.ImagesperWell = 5;

% Set number of channels and corresponding genes:
% analysisParam.ChannelMax = 4;
% GeneCH2 = 'CDX2';
% GeneCH3 = 'SOX2';
% GeneCH4 = 'BRA';

% Set the wells in the dish for which there is data available:
% analysisParam.NumofPlates = 4;

% Set the wells in the dish for which there is data available:
% WellsWithData = {[1,2,7,8],[1,2,7,8],[1,2,7,8],[1,2,7,8]};

% Define array to save data in:
alldata = cell(1,analysisParam.ImagesperWell-ImagesperWell1+1);


emptypositions = [];
emptyposcounter = 0;


%% For loop to analyse data
%-----------------------------
%-----------------------------

for PlateNum = 1:analysisParam.NumofPlates
    fprintf(['***********************','\n'])
    fprintf(['***********************','\n'])
    fprintf(['Plate:', num2str(PlateNum),'\n'])
    fprintf(['***********************','\n'])
    fprintf(['***********************','\n'])
    
for WellNumber = analysisParam.WellsWithData{PlateNum}
 %%   
    fprintf(['-----------------------','\n'])
    fprintf(['-----------------------','\n'])
    fprintf(['Well:', num2str(WellNumber),'\n'])
    fprintf(['-----------------------','\n'])
    fprintf(['-----------------------','\n'])



for nposition = ImagesperWell1:analysisParam.ImagesperWell

    fprintf(['Position:', num2str(nposition),'\n'])
    fprintf(['-----------------------','\n'])
    
positionname=['P',num2str(PlateNum),'_','W',num2str(WellNumber),'_',num2str(nposition),'_MAXProj'];

% positionname=['W',num2str(WellNumber),'_',num2str(nposition)];%,'_MAXProj'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       READ AND CHECK DATA           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
['/MaxProj/',positionname,'_Simple Segmentation.h5']
% Defines filenames of input data
filenameNuclei = fullfile(dataDir, [positionname,'_Simple Segmentation.h5']);
filenameNuclei
% if BrightSpotsBoolean == 1
%     for channelnum = 1:analysisParam.ChannelMax
%         filenameBrightSpotsChannel{channelnum} = fullfile(dataDir, [positionname,'_Simple Segmentation_BrightSpots_',channelsnames{channelnum},'.h5']);
%     end
% end

%% Read segmentation data (1: nucleus, 2: background), of DAPI and the bright spots in the other three channels.

% Read segmentation data (squeeze removes excessive dimensions) and turn everything that was red into 1 in binary mode
% Segmentation definition, 1: nucleus, 2: background
foregroundLabel =1;
nucleisegmentation = squeeze(h5read(filenameNuclei,datasetname)) == foregroundLabel;
nucleisegmentation=nucleisegmentation;

% if BrightSpotsBoolean == 1
%     for channelnum = 1:analysisParam.ChannelMax
%         brightspotssegmentationChannel{channelnum} = squeeze(h5read(filenameBrightSpotsChannel{channelnum},datasetname)) == foregroundLabel;
%     end
% end
% 
% backgroundLabel = 2;
% backgroundsegmentation = squeeze(h5read(filenameNuclei,datasetname)) == backgroundLabel;
% 
% if BrightSpotsBoolean == 1
%     for channelnum = 1:analysisParam.ChannelMax
%         BSbackgroundsegmentationChannel{channelnum} = squeeze(h5read(filenameBrightSpotsChannel{channelnum},datasetname)) == backgroundLabel;
%     end
% end

dimensions = size(nucleisegmentation);




%% Read RAW data and substract background

% Read in raw data of nuclei
FluorescenceLevelsRaw = zeros([dimensions(1) dimensions(2) analysisParam.ChannelMaxNum{PlateNum}(WellNumber)],'uint16');
FluorescenceLevelsRawBGnorm = zeros([dimensions(1) dimensions(2) analysisParam.ChannelMaxNum{PlateNum}(WellNumber)],'uint16');


for ii = 1:analysisParam.ChannelMaxNum{PlateNum}(WellNumber)
    imauxfluorescencelevels = imread(fullfile(dataDir,[positionname,'.tif']), ii);
    
    if analysisParam.bgsubstractionopt == 1
        dapi_bg = imread(fullfile(analysisParam.BGImages{PlateNum}{WellNumber}), ii);
        %dapi_bg = smoothImage(dapi_bg,50,10);
        FluorescenceLevelsRawBGnorm(:,:,ii) = imsubtract(imauxfluorescencelevels,dapi_bg);
        
    elseif analysisParam.bgsubstractionopt == 2 
        
        FluorescenceLevelsRawBGnorm(:,:,ii) = imauxfluorescencelevels - analysisParam.bgvalues(analysisParam.MapChannels.ChannelsCoordMatrix{PlateNum,WellNumber}(ii));

    elseif analysisParam.bgsubstractionopt == 3 
        dapi_bg = imopen(FluorescenceLevelsRaw(:,:,ii),strel('disk',40));
        FluorescenceLevelsRawBGnorm(:,:,ii) = imsubtract(imauxfluorescencelevels,dapi_bg);
    end

    
end


%% Visualisation of the raw data and original mask

% % Visualize original mask from Ilastik:
% %--------------------------------------
% channeltoplot = 1;
% % allocate empty array for data
% R = nucleisegmentation(:,:,1)';
% B = 0*R;
% % show image for time t, cat concatenates nuclei and cell segmentation data
% % to colour them differently
% imshow(cat(3,R,B,R),[]);
% 
% % Visualize raw data and original mask from Ilastik as a doughnut:
% %-----------------------------------------------------------------  
% %Create a doughnut around nuclei by using the mask:
% mask=nucleisegmentation(:,:,1)'-imerode(nucleisegmentation(:,:,1)',strel('disk',2));
% %mask=nuclei_new(:,:,t)'-imerode(nuclei_new(:,:,t)',strel('disk',2));
% 
% %Get Nuclei
% RawNucleiplot=imadjust(mat2gray(FluorescenceLevelsRaw(:,:,channeltoplot))); %This version saturates the background
% % RawNucleiplot=mat2gray(FluorescenceLevelsRaw(:,:,channeltoplot));
% 
% %Plot them:
%     NucleiandNucleiDonuts=cat(3,mask,RawNucleiplot,mask);
%     figure
%     Plot2=imshow(NucleiandNucleiDonuts,[]);
%     title('Improved Nuclei segmentation on Raw Nuclei')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             DATA ANALYSIS            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set initial structure where data will be saved:
%------------------------------------------------

% intensity_n_t will hold mean nuclear intensity of the fluorescence level
% for each channel
% intensity_n_t = zeros([1,analysisParam.ChannelMax]);


%% Initial improvement of maks
    
% Transpose data
nuclei_new = nucleisegmentation(:,:,1)';
nuclei_old = nuclei_new;

% use bwareaopen to exclude noisy bright bits (Verified). WARNING: Be
% sure that foregroundlabel and backgroundlabel are right!
nuclei_new = bwareaopen(nuclei_new,100);
imshow(cat(3,nucleisegmentation(:,:,1)',nuclei_new,0*nucleisegmentation(:,:,1)'),[]) %In red, the old mask, in yellow the new mask
close

% use imopen and imclose with the structuring element se to 
% make edges smooth. It mafikes nuclei round Chose a disc of radius 10.
nuclei_aux = nuclei_new; %saved to plot it
se = strel('disk',analysisParam.imopendiskradious);
nuclei_new = imopen(nuclei_new, se); 
% % Visualize:
% maskaux = nuclei_aux-imerode(nuclei_aux,strel('disk',2));
% title('Previous mask')
% masknew = nuclei_new-imerode(nuclei_new,strel('disk',2));
% title('Improved mask')
% 
% figure('Position',[100 100 1700 1700])
% hold on
% subplot(1,2,1)
% imshow(cat(3,maskaux,RawNucleiplot,maskaux))
% subplot(1,2,2)
% imshow(cat(3,masknew,RawNucleiplot,masknew))
% hold off
% close

% Erode and dilate to just divide mask that joins two cells (however, this affects those cells that have moonshape, making them circular) 
nuclei_aux = nuclei_new; %saved to plot it
seerode = strel('disk',analysisParam.imerodediskradious);
nuclei_new=imerode(nuclei_new,seerode);
sedil = strel('disk',analysisParam.imdilatediskradious);
nuclei_new=imdilate(nuclei_new,sedil);
% % Visualize:
% maskaux = nuclei_aux-imerode(nuclei_aux,strel('disk',2));
% title('Previous mask')
% masknew = nuclei_new-imerode(nuclei_new,strel('disk',2));
% title('Improved mask')
% 
% figure('Position',[100 100 1700 1700])
% hold on
% subplot(1,2,1)
% imshow(cat(3,maskaux,RawNucleiplot,maskaux))
% subplot(1,2,2)
% imshow(cat(3,masknew,RawNucleiplot,masknew))
% hold off
% close
       
% Option to use imclose or imclearboarders
nuclei_aux = nuclei_new; %saved to plot it
se = strel('disk',1);
nuclei_new = imclose(nuclei_new, se);
% % Visualize:
% maskaux = nuclei_old-imerode(nuclei_old,strel('disk',2));
% title('Previous mask')
% masknew = nuclei_new-imerode(nuclei_new,strel('disk',2));
% title('Improved mask')
% 
% figure('Position',[100 100 1700 1700])
% hold on
% subplot(1,2,1)
% imshow(cat(3,maskaux,RawNucleiplot,maskaux))
% subplot(1,2,2)
% imshow(cat(3,masknew,RawNucleiplot,masknew))    
% hold off    

%% Visualize old vs new mask


RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRawBGnorm(:,:,1)));
masknew=nuclei_new-imerode(nuclei_new,strel('disk',2));
mask=nucleisegmentation(:,:,1)'-imerode(nucleisegmentation(:,:,1)',strel('disk',2));

subplot(1,2,1)
imshow(cat(3,mask,RawSMAD4plot,mask),[])
title('Old mask')

subplot(1,2,2)
imshow(cat(3,masknew,RawSMAD4plot,masknew),[])
title('Improved mask')

%% Watershed algorithm

nuclei_new = imclearborder(nuclei_new); %Removes nuclei in the border of the image, which can lead to errors in the watershed algorithm
CC=bwconncomp(nuclei_new); %Find the connected components in the segmentation
statsnew = regionprops(CC,'Area','Centroid'); %Computes the area and centroids of the connected components
area = [statsnew.Area];
fusedcandidates = area > mean(area)+std(area); %Fused candidates are such that the area is bigger than the mean+std of the areas
statscell = struct2cell(statsnew);
CentroidsMat = cat(1,statscell{2,:});

% if (PlateNum==1)&&(WellNumber==2)&&(nposition==1)
%     fusedcandidates(1)=0;
% elseif (PlateNum==2)&&(WellNumber==5)&&(nposition==5)
%     fusedcandidates(1)=0;
% elseif (PlateNum==2)&&(WellNumber==6)&&(nposition==3)
%     fusedcandidates(1)=0;
% elseif (PlateNum==2)&&(WellNumber==8)&&(nposition==3)
%     fusedcandidates(1)=0;   
% end
% imshow(nuclei_new);
% hold on
% plot(CentroidsMat(fusedcandidates,1), CentroidsMat(fusedcandidates,2), 'r*')
% %%
% fusedcandidates = checkconstraintsfusedcandidates(PlateNum,WellNumber,nposition,fusedcandidates);

sublist = CC.PixelIdxList(fusedcandidates);
sublist = cat(1,sublist{:});
fusedMask = false(size(nuclei_new));
fusedMask(sublist) = 1;

% imshow(fusedMask,'InitialMagnification','fit')
% hold on
% fusedcandidates2 = area > mean(area)+1.5*std(area);
% sublist2 = CC.PixelIdxList(fusedcandidates2);
% sublist2 = cat(1,sublist2{:});
% fusedMask2 = false(size(nuclei_new));
% fusedMask2(sublist2) = 1;
% imshow(cat(3,fusedMask2,fusedMask,0*fusedMask2),[])


s = round(analysisParam.pwatershed*sqrt(mean(area))/pi);
% s = round(1*sqrt(mean(area))/pi);

if any(fusedMask,'all')
nucmin = imerode(fusedMask,strel('disk',s));
% imshow(cat(3,fusedMask,nucmin,0*fusedMask),[]);
outside = ~imdilate(fusedMask,strel('disk',1));
% imshow(outside)
basin = imcomplement(bwdist(outside));
basin = imimposemin(basin,nucmin|outside);
pcolor(basin); shading flat;
L=watershed(basin);
% imshow(L); colormap('jet');caxis([0,20]);
newNuclearMask = L>1 | (nuclei_new - fusedMask);
% imshow(newNuclearMask)

%% Show old and mask after watershed
close
figure('Position',[100 100 1700 1700])

RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRawBGnorm(:,:,1)));
masknew=newNuclearMask-imerode(newNuclearMask,strel('disk',2));
mask=nucleisegmentation(:,:,1)'-imerode(nucleisegmentation(:,:,1)',strel('disk',2));

subplot(1,2,1)
imshow(cat(3,mask,RawSMAD4plot,mask),[])
title('Old mask')

subplot(1,2,2)
imshow(cat(3,masknew,RawSMAD4plot,masknew),[])
title('Improved mask')

% RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRaw(:,:,1)));
% masknew=newNuclearMask-imerode(newNuclearMask,strel('disk',2));
% mask=nucleisegmentation(:,:,1)'-imerode(nucleisegmentation(:,:,1)',strel('disk',2));
% 
% subplot(2,2,3)
% imshow(cat(3,mask,RawSMAD4plot,mask),[])
% title('Old mask')
% 
% subplot(2,2,4)
% imshow(cat(3,masknew,RawSMAD4plot,masknew),[])
% title('Improved mask')

segtosave = cat(3,masknew,RawSMAD4plot,masknew);
imwrite(segtosave,[dataDir, '/NewSegmentation_',positionname,'.tif'],'Compression','none');

% pause()

%% Find background for each channel, substracting the brightspots resulting from bad immunostaining  
%     
%     close all
    % Get background intensity for red and green chanels 
    %---------------------------------------------------
    
    se = strel('disk',20);
    %We need to consider as background the complementary of the ILASTIK
    %segmentation, otherwise we take bright small spots as background
    
    opbackgroundCell = imdilate(nucleisegmentation(:,:,1)', se);
    backgroundCell = not(opbackgroundCell);
    IndbackDAPI = find(backgroundCell);
    
%     opbackgroundBspotsChannel2 = imdilate(brightspotssegmentationChannel2', se);
%     backgroundBspotsChannel2 = not(opbackgroundBspotsChannel2);
%     backgroundBspotsandDapiChannel2 = backgroundBspotsChannel2&backgroundCell;
%     IndbackBSpotsChannel2 = find(backgroundBspotsandDapiChannel2);
%     
%     opbackgroundBspotsChannel3= imdilate(brightspotssegmentationChannel3', se);
%     backgroundBspotsChannel3 = not(opbackgroundBspotsChannel3);
%     backgroundBspotsandDapiChannel3 = backgroundBspotsChannel3&backgroundCell;
%     IndbackBSpotsChannel3 = find(backgroundBspotsandDapiChannel3);
%     
%     opbackgroundBspotsChannel4 = imdilate(brightspotssegmentationChannel4', se);
%     backgroundBspotsChannel4 = not(opbackgroundBspotsChannel4);
%     backgroundBspotsandDapiChannel4 = backgroundBspotsChannel4&backgroundCell;
%     IndbackBSpotsChannel4 = find(backgroundBspotsandDapiChannel4);

%     close
%     RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRawBGnorm(:,:,2)));
%     mask=backgroundCell-imerode(backgroundCell,strel('disk',2));
%     imshow(cat(3,mask,RawSMAD4plot,mask),[])
%     pause(5)
%     close
    
    FluorescenceDAPI = FluorescenceLevelsRaw(:,:,1);
%     FluorescenceChannel2 = FluorescenceLevelsRaw(:,:,2);
%     FluorescenceChannel3 = FluorescenceLevelsRaw(:,:,3);
%     FluorescenceChannel4 = FluorescenceLevelsRaw(:,:,4);
    
    backgroundintDAPI = mean(FluorescenceDAPI(IndbackDAPI));
%     backgroundintChannel2 = mean(FluorescenceChannel2(backgroundBspotsandDapiChannel2)); %CDX2 background is the DAPI background without the super bright spots
%     backgroundintChannel3 = mean(FluorescenceChannel3(backgroundBspotsandDapiChannel3));
%     backgroundintChannel4 = mean(FluorescenceChannel4(backgroundBspotsandDapiChannel4));
    
    BackgroundData = struct('DAPI',backgroundintDAPI);%,'CDX2',backgroundintChannel2,'SOX2',backgroundintChannel3,'BRA',backgroundintChannel4);

%%    
% %     %Visualising background
% %     %----------------------
% %     
% %     % Plots the raw data and the masks for cell segmentation and nuclear
% %     % mask.
% %     
% %         %Plot DAPI channel with background and segmentation 
% %         RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRaw(:,:,1)));
% %         NucleiDonuts=cat(3,mask,RawSMAD4plot,mask);
% %         figure
% %         Plot1=imshow(NucleiDonuts,[]);
% %         hold on
% %         Plot3=imshow(backgroundCell,[])
% %         set(Plot3,'AlphaData',0.5);
% % 
% %         %Plot CDX2 channel with background and segmentation 
%         figure
%         RawSMAD4plot=imadjust(mat2gray(FluorescenceLevelsRaw(:,:,2)));
%         NucleiDonuts=cat(3,mask,RawSMAD4plot,mask);
%         Plot2=imshow(NucleiDonuts,[]);
%         hold on
%         Plot4=imshow(backgroundBspotsandDapi,[])
%         set(Plot4,'AlphaData',0.5);
%         hold off
        
    
%% Save data
    
    % get properties of transformed segmentation
    stats = regionprops(newNuclearMask, 'PixelIdxList', 'Centroid','Area');

    
    num = size(stats);
    num_nuc = num(1);
        
    % Fill in cell structure for given time step, for all nuclei identified
    
    MatrixDataPosition=zeros(num_nuc,6);
    
    for k = 1:num_nuc
        
        %Values of interest:
        %------------------
        MatrixDataPosition(k,1) = stats(k).Centroid(1); %x coordinate of centroid
        
        MatrixDataPosition(k,2) = stats(k).Centroid(2); %y coordinate of centroid
        
%         MatrixDataPosition(k,3) = mean(FluorescenceDAPI(stats(k).PixelIdxList));%-backgroundintDAPI;
        
        for channelnum = 1:analysisParam.ChannelMaxNum{PlateNum}(WellNumber)
            FluorescenceLevelsRaw = FluorescenceLevelsRawBGnorm(:,:,channelnum);
            MatrixDataPosition(k,channelnum+2) = mean(FluorescenceLevelsRaw(stats(k).PixelIdxList));%-backgroundintChannel2;
        end
        
        MatrixDataPosition(k,4+3) = stats(k).Area;
                
    end

    alldata{nposition} = MatrixDataPosition;
    
else
    emptyposcounter=emptyposcounter+1;
    emptypositions(emptyposcounter,:) = [PlateNum,WellNumber,nposition];
    alldata{nposition} = [];

end

end
 
 name = strcat(analysisParam.savingpathforData,'/Plate',num2str(PlateNum),'_Well',num2str(WellNumber),'_Data.mat')
 
 save(name,'alldata','analysisParam','emptypositions')
 
 alldatawells{PlateNum}{WellNumber} = alldata;

end

end

name = strcat(analysisParam.savingpathforData,'/AllDataPlates.mat')
 
save(name,'alldatawells','analysisParam')

if emptyposcounter>0
    for ii = 1:emptyposcounter
        disp(['Warning: Plate ',num2str(emptypositions(emptyposcounter,1)),' Well ', num2str(emptypositions(emptyposcounter,2)),' Position ',num2str(emptypositions(emptyposcounter,3)),' had an empty mask.'])

    end
    
    
end


close all