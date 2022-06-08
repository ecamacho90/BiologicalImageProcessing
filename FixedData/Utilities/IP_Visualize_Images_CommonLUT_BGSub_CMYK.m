function IP_Visualize_Images_CommonLUT_BGSub_CMYK(varargin)
%% Description
% help make image panel with 5 rows (ch1-4, merge) and columns are all the
% replicates in one condition
% all the images will be saved in plate/well/ folder with single image and
% panel image

global analysisParam
OrderChannels = analysisParam.OrderChannels;
ImagesperWell = analysisParam.ImagesperWell;
Channelsnames = analysisParam.Channelsnames;

if ( length(varargin) == 1 )
    varargin = varargin{:};
end

imresizelevel =0.3;
medfiltopt = 1;

while ~isempty(varargin)
    switch lower(varargin{1})
        
          case {'imresizelevel'}
              imresizelevel = varargin{2}
          case {'medfiltopt'}
              medfiltopt = varargin{2}

    otherwise
        error(['Unexpected option: ' varargin{1}])
    end
      varargin(1:2) = [];

end


%% finding how many channels used in each well

if analysisParam.bgsubstractionopt == 2
    
    if ~isfield(analysisParam,'bgvalues')
        IP_ComputeBGSubstractionlevelsUsingSegmentation

    end

end


analysisParam.MapChannels.ChannelsCoordMatrix
%% generating limits for the panel (per condition)

disp('Generating limits......')

limitschannels = zeros(2,length(analysisParam.MapChannels.DifferentChannelsPresent));

for ChannelNumber = 1:length(analysisParam.MapChannels.DifferentChannelsPresent)
    
    PNumber = analysisParam.MapChannels.PlateCoordinates{ChannelNumber};
    WNumber = analysisParam.MapChannels.WellCoordinates{ChannelNumber};
    CNumber = analysisParam.MapChannels.ChannelCoordinates{ChannelNumber};
    
    image16bit = imread([analysisParam.pathnamedata,'/P',num2str(PNumber(1)),'_W',num2str(WNumber(1)),'_1_MaxProj.tif'],CNumber(1));
    
    if analysisParam.bgsubstractionopt ==1
        
        
        bgimagebit = imread(analysisParam.BGImages{PNumber(1)}{WNumber(1)},CNumber(1));
        image16bit = imsubtract(image16bit,bgimagebit);
        
        
    elseif analysisParam.bgsubstractionopt == 2
        image16bit = image16bit - analysisParam.bgvalues(ChannelNumber);
        
    elseif analysisParam.bgsubstractionopt ==3
        
        bgimagebit = imopen(image16bit,strel('disk',40));

        image16bit = imsubtract(image16bit,bgimagebit); 
        
    end
    
    
    if medfiltopt
            image16bit = medfilt2(img);
    end

        
    
    imaux = im2double(image16bit);
    
    limitsaux = stretchlim(imaux,[0.05 0.95]);
    
    for imageswithchannel = 1:length(PNumber)
        
        for positionnumber = 1:analysisParam.ImagesperWell
            
            image16bit = imread([analysisParam.pathnamedata,'/P',num2str(PNumber(imageswithchannel)),'_W',num2str(WNumber(imageswithchannel)),'_',num2str(positionnumber),'_MaxProj.tif'],CNumber(imageswithchannel));
            
            if analysisParam.bgsubstractionopt ==1
                bgimagebit = imread(analysisParam.BGImages{PNumber(imageswithchannel)}{WNumber(imageswithchannel)},CNumber(imageswithchannel));
                image16bit = imsubtract(image16bit,bgimagebit);


            elseif analysisParam.bgsubstractionopt == 2
                image16bit = image16bit - analysisParam.bgvalues(ChannelNumber);

            elseif analysisParam.bgsubstractionopt ==3

                bgimagebit = imopen(image16bit,strel('disk',40));

                image16bit = imsubtract(image16bit,bgimagebit); 

            end


            if medfiltopt
                    image16bit = medfilt2(img);
            end

            imaux = im2double(image16bit);
            
            limitsaux2 = stretchlim(imaux,[0.05 0.95]);
            
            if limitsaux(2)<limitsaux2(2)

                limitsaux(2) = limitsaux2(2);


            end
            
            if limitsaux(1)>limitsaux2(1)

                limitsaux(1) = limitsaux2(1);


            end
            
        end
           
            
    end
    limitschannels(:,ChannelNumber) = limitsaux;
     
        
end

analysisParam.limitschannelsImages = limitschannels;

save([analysisParam.savingpathforImages,'/limitschannelsimages'],'limitschannels','analysisParam');
%%

disp('Saving images.....')

for platenumber = 1:analysisParam.NumofPlates
cd(analysisParam.savingpathforImages)
mkdir(['Plate',num2str(platenumber)])
    
    
for wellnumber = analysisParam.WellsWithData{platenumber} 
cd([analysisParam.savingpathforImages,'/Plate',num2str(platenumber)])
mkdir(['Well',num2str(wellnumber)]) 

        BigCellMontage={};
        
        
        for positionnumber = 1:analysisParam.ImagesperWell
            
            AdjustedImage = [];
            
            for channelnumber = 1:analysisParam.ChannelMaxNum{platenumber}(wellnumber)
                
              image16bit = imread([analysisParam.pathnamedata,'/P',num2str(platenumber),'_W',num2str(wellnumber),'_',num2str(positionnumber),'_MaxProj.tif'],channelnumber);
              
                if analysisParam.bgsubstractionopt ==1
                    bgimagebit = imread(analysisParam.BGImages{PNumber(1)}{WNumber(1)},CNumber(1));
                    image16bit = imsubtract(image16bit,bgimagebit);


                elseif analysisParam.bgsubstractionopt == 2
                    image16bit = image16bit - analysisParam.bgvalues(ChannelNumber);

                elseif analysisParam.bgsubstractionopt ==3
                    bgimagebit = imopen(image16bit,strel('disk',40));
                    image16bit = imsubtract(image16bit,bgimagebit); 

                end


                if medfiltopt
                        image16bit = medfilt2(img);
                end

            
              
             imaux = im2double(image16bit);  
                
              AdjustedImage(:,:,channelnumber) = imadjust(imaux,limitschannels(:,analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(channelnumber)));

                
                
            end
            
            ChannelMaxaux = 0;
            for ii = 1:analysisParam.ChannelMaxNum{platenumber}(wellnumber)
            if strcmp(Channelsnames{platenumber}{wellnumber}(ii),'0NA')~=1
                ChannelMaxaux = ChannelMaxaux+1;
            end
            end
                
    
            ChannelMaxaux
%     img2showDAPI = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}));        
%     img2showChannel1 = cat(3,zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}))),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2);  %CYAN
%     img2showChannel2 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}),zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}))),zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}))));  %RED
%     img2showChannel3 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4}))));    %YELLOW
%     img2showMerge = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2);

    img2showDAPI = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}));    %Gray
    imwrite(imresize(img2showDAPI,0.3),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_DAPI','_channel.png'])
    
    if ChannelMaxaux>1 
    img2showChannel1 = cat(3,zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1}))),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}));  %CYAN
    imwrite(imresize(img2showChannel1,0.3),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)},'channel.png'])
    img2showDAPIChannel1 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}));     % Cyan   
    imwrite(imresize(img2showDAPIChannel1,imresizelevel),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)},'channel_MergeDAPI.png'])
%     imwrite(img2showDAPIChannel1,[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)},'channel_MergeDAPI.png'])
    end
    if ChannelMaxaux>2
    img2showChannel2 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}),zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}))),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}));  %MAGENTA
    imwrite(imresize(img2showChannel2,0.3),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(3)},'channel.png'])
    img2showDAPIChannel2 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);     % Magenta
    imwrite(imresize(img2showDAPIChannel2,imresizelevel),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(3)},'channel_MergeDAPI.png'])
    end
    if ChannelMaxaux>3
    img2showChannel3 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4}),zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4}))));        %YELLOW
    imwrite(imresize(img2showChannel3,0.3),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(4)},'channel.png'])
    img2showDAPIChannel3 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)));     % Yellow
    imwrite(imresize(img2showDAPIChannel3,imresizelevel),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(4)},'channel_MergeDAPI.png'])

    end
    
    BigCellMontage{positionnumber} = imresize(img2showDAPI,0.3);
    if ChannelMaxaux == 2
        img2showMerge = cat(3,zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}))),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}));
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,0.3);
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showMerge,0.3);
        namemontage = [analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)}];
    elseif ChannelMaxaux == 3
        img2showMerge =cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,0.3);
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showChannel2,0.3);
        BigCellMontage{3*ImagesperWell+positionnumber} = imresize(img2showMerge,0.3);
        namemontage = [analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)},analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(3)}];

    elseif ChannelMaxaux == 4
%     A=imshow(img2showChannel1)
%         img2showMerge =cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);
%         img2showMerge =cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);
        img2showMerge =cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3}));

        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,0.3);
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showChannel2,0.3);
        BigCellMontage{3*ImagesperWell+positionnumber} = imresize(img2showChannel3,0.3);
        BigCellMontage{4*ImagesperWell+positionnumber} = imresize(img2showMerge,0.3);
        namemontage = [analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(2)},analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(3)},analysisParam.MapChannels.DifferentChannelsPresent{analysisParam.MapChannels.ChannelsCoordMatrix{platenumber,wellnumber}(4)}];

    else
        img2showMerge =img2showDAPI;
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,0.3);
    end

    imwrite(imresize(img2showMerge,0.3),[analysisParam.savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_Merge.png'])
    
    close all
    end
        
        



%IDSE
N = ImagesperWell;

n = ceil(N/4);
m = ceil(N/n);


%m = N/2;
screensize = get( 0, 'Screensize' );
margin = 50;
fs = 14;
w = screensize(3);
h = 5*(screensize(3)/m + margin/2);
%IDSE

merged = {};

% fig=figure('Position', [1, 1, w, h]);
h1 = figure();
set(h1, 'Visible', 'off');
fig = montage(BigCellMontage,'BorderSize',[3,3],'BackgroundColor','white','Size',[5,ImagesperWell]);

filename = strcat('/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/MontageWhite_Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',namemontage);
saveas(fig, fullfile(analysisParam.savingpathforImages, filename), 'png');
close

h1 = figure();
set(h1, 'Visible', 'off');
fig = montage(BigCellMontage,'BorderSize',[3,3],'BackgroundColor','black','Size',[5,ImagesperWell]);
set(fig,'Visible', 'off')
filename=strcat('/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/MontageBlack_Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',namemontage);
saveas(fig, fullfile(analysisParam.savingpathforImages, filename), 'png');

% pause()

close all

        
end
    
    
end

analysisParam.limitschannelsImages = limitschannels;

save([analysisParam.savingpathforImages,'/limitschannelsimages'],'limitschannels','analysisParam');

disp('Saved data')


end