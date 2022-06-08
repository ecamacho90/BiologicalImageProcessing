function IP_TableImageVisualization_ChannelsChoice(conditionschoice,channelschoice,colorschoice,filename,varargin)

% colorschoice, for each channel of choice, colorschoice is 1 if White, 2
% if CYAN, 3 if magenta, 4 if yellow, 5 if blue, 6 if red.

global analysisParam
OrderChannels = analysisParam.OrderChannels;
ImagesperWell = analysisParam.ImagesperWell;
Channelsnames = analysisParam.Channelsnames;
ChannelsPresent = analysisParam.MapChannels.DifferentChannelsPresent;
ChannelsMatrix = analysisParam.MapChannels.ChannelsCoordMatrix;

if ( length(varargin) == 1 )
    varargin = varargin{:};
end

imresizelevel =0.3;
medfiltopt = 1;
colorORbgwhite = 0;

while ~isempty(varargin)
    switch lower(varargin{1})
        
          case {'imresizelevel'}
              imresizelevel = varargin{2};
          case {'medfiltopt'}
              medfiltopt = varargin{2};
          case {'colororbw'}
              colorORbgwhite = varargin{2};

    otherwise
        error(['Unexpected option: ' varargin{1}])
    end
      varargin(1:2) = [];

end

%% Check conditions contain the same channels
nCon = size(conditionschoice,2);
nChan = length(channelschoice);

FindChannelsinConditions = zeros(nCon,nChan);

for ii = 1:nChan
    
    channelinterest = channelschoice(ii);
    
    for jj = 1:nCon
        
        auxvar = find(channelinterest == analysisParam.MapChannels.ChannelsCoordMatrix{conditionschoice(1,jj),conditionschoice(2,jj)});
        
        if isempty(auxvar)
            channelinterest
            error(['IP_TableImageVisualization_ChannelsChoice: Selected condition ',num2str(jj),' does not contain data for channel ',analysisParam.MapChannels.DifferentChannelsPresent{channelinterest}]);
        
        else
            FindChannelsinConditions(jj,ii) = auxvar;
            
        end
        
    end
    
end


%% finding how many channels used in each well

if analysisParam.bgsubstractionopt == 2
    
    if ~isfield(analysisParam,'bgvalues')
        if ~isfile([analysisParam.savingpathforImages,'/bgvalues.mat'])
        IP_ComputeBGSubstractionlevelsUsingSegmentation
        else
            load([analysisParam.savingpathforImages,filesep,'bgvalues.mat'])
        end

    end

end

%%

% imresizelevel=0.9
load([analysisParam.savingpathforImages,filesep,'limitschannelsimages.mat'])

disp('Saving images.....')
ImagesperWell = size(conditionschoice,2)

% for platenumber = conditionschoice(1,:)
% % cd(savingpathforImages)
% % mkdir(['Plate',num2str(platenumber)])
%     
%     
% for wellnumber = conditionschoice(2,:)
% % cd([savingpathforImages,'/Plate',num2str(platenumber)])
% % mkdir(['Well',num2str(wellnumber)]) 

        BigCellMontage={};
 
        
        
        for positionnumber = 1:ImagesperWell
            platenumber=conditionschoice(1,positionnumber);
            wellnumber=conditionschoice(2,positionnumber);
            
            AdjustedImage = [];
            
            for channelnumber = 1:analysisParam.ChannelMaxNum{platenumber}(wellnumber)
                [analysisParam.pathnamedata,'/P',num2str(platenumber),'_W',num2str(wellnumber),'_',num2str(conditionschoice(3,positionnumber)),'_MaxProj.tif']
              image16bit = imread([analysisParam.pathnamedata,'/P',num2str(platenumber),'_W',num2str(wellnumber),'_',num2str(conditionschoice(3,positionnumber)),'_MaxProj.tif'],channelnumber);
              
                if analysisParam.bgsubstractionopt ==1
                    bgimagebit = imread(analysisParam.BGImages{PNumber(1)}{WNumber(1)},CNumber(1));
                    image16bit = imsubtract(image16bit,bgimagebit);
                    
                elseif analysisParam.bgsubstractionopt == 2
                    image16bit = image16bit - analysisParam.bgvalues(channelnumber);

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
            for ii = 1:nChan
            if strcmp(Channelsnames{platenumber}{wellnumber}(FindChannelsinConditions(positionnumber,ii)),'0NA')~=1
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
%     imwrite(imresize(img2showDAPI,0.3),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_DAPI','_channel.png'])
    
    if nChan>0 
        chnum = 1;
        if colorORbgwhite
            img2showChannel1 = convertcolorimage(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)), colorschoice(chnum));%cat(3,zeros(size(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)))),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)));  %CYAN
        else
            img2showChannel1 = cat(3,AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)));  %GRAY
        end
%     imwrite(imresize(img2showChannel1,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)},'channel.png'])
%     img2showDAPIChannel1 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2}));     % Cyan   
%     imwrite(imresize(img2showDAPIChannel1,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)},'channel_MergeDAPI.png'])
%     imwrite(img2showDAPIChannel1,[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)},'channel_MergeDAPI.png'])
    end
    if ChannelMaxaux>1
    chnum = 2;
    if colorORbgwhite
            img2showChannel2 = convertcolorimage(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)), colorschoice(chnum));%cat(3,AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),zeros(size(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)))),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)));  %MAGENTA
        else
            img2showChannel2 = cat(3,AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)));  %GRAY
    end
    %     imwrite(imresize(img2showChannel2,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(3)},'channel.png'])
%     img2showDAPIChannel2 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)),AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);     % Magenta
%     imwrite(imresize(img2showDAPIChannel2,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(3)},'channel_MergeDAPI.png'])
    end
    if ChannelMaxaux>2
    chnum = 3;
    if colorORbgwhite
            img2showChannel3 = convertcolorimage(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)), colorschoice(chnum));%cat(3,AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),zeros(size(AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)))));        %YELLOW
        else
            img2showChannel3 = cat(3,AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)),AdjustedImage(:,:,FindChannelsinConditions(positionnumber,chnum)));  %GRAY
    end
    %     imwrite(imresize(img2showChannel3,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(4)},'channel.png'])
%     img2showDAPIChannel3 = cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{1})/2+zeros(size(AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2)));     % Yellow
%     imwrite(imresize(img2showDAPIChannel3,imresizelevel),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_',ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(4)},'channel_MergeDAPI.png'])

    end
    
    BigCellMontage{positionnumber} = imresize(img2showDAPI,imresizelevel);
    if ChannelMaxaux == 1
        img2showMerge = img2showChannel1;
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,imresizelevel);
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showMerge,0.3);
        namemontage = [ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)}];
    elseif ChannelMaxaux == 2
        img2showMerge =(img2showChannel1+img2showChannel2);
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,imresizelevel);
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showChannel2,imresizelevel);
        BigCellMontage{3*ImagesperWell+positionnumber} = imresize(img2showMerge,0.3);
        namemontage = [ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)},ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(3)}];

    elseif ChannelMaxaux == 3
%     A=imshow(img2showChannel1)
%         img2showMerge =cat(3,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{4})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2,AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{2})/2+AdjustedImage(:,:,OrderChannels{platenumber}{wellnumber}{3})/2);
        img2showMerge =(img2showChannel1+img2showChannel2+img2showChannel3);
        ImagesperWell+positionnumber
        BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,imresizelevel);
        2*ImagesperWell+positionnumber
        BigCellMontage{2*ImagesperWell+positionnumber} = imresize(img2showChannel2,imresizelevel);
        3*ImagesperWell+positionnumber
        BigCellMontage{3*ImagesperWell+positionnumber} = imresize(img2showChannel3,imresizelevel);
        BigCellMontage{4*ImagesperWell+positionnumber} = imresize(img2showMerge,imresizelevel);
        namemontage = [ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(2)},ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(3)},ChannelsPresent{ChannelsMatrix{platenumber,wellnumber}(4)}];

    else
        error('Too many channels')
%         img2showMerge =img2showDAPI;
%         BigCellMontage{ImagesperWell+positionnumber} = imresize(img2showChannel1,imresizelevel);
    end

%     imwrite(imresize(img2showMerge,0.3),[savingpathforImages,'/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',num2str(positionnumber),'_Merge.png'])
    
%     close all
    end
        
%%

% BigCellMontage
%IDSE
N = ImagesperWell;

n = ceil(N/ChannelMaxaux+2);%-1);
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
% montage(BigCellMontage)
% [ChannelMaxaux+1,ImagesperWell]
% pause()

fig = montage(BigCellMontage,'BorderSize',[3,3],'BackgroundColor','white','Size',[ImagesperWell,ChannelMaxaux+2]);
fig = gcf;
fig.Color = 'w';
fig.InvertHardcopy = 'off';
% filename = strcat('/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/MontageWhite_Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',namemontage);
saveas(fig, fullfile(analysisParam.savingpathforImages, [filename,'_White_',num2str(colorORbgwhite)]), 'png');

fig = montage(BigCellMontage,'BorderSize',[3,3],'BackgroundColor','black','Size',[ImagesperWell,ChannelMaxaux+2]);
fig = gcf;
fig.Color = 'k';
fig.InvertHardcopy = 'off';
% filename=strcat('/Plate',num2str(platenumber),'/Well',num2str(wellnumber),'/MontageBlack_Plate',num2str(platenumber),'_Well',num2str(wellnumber),'_',namemontage);
saveas(fig, fullfile(analysisParam.savingpathforImages, [filename,'_Black_',num2str(colorORbgwhite)]), 'png');

% pause()

% close all

    


% save([savingpathforImages,'/limitschannelsimages'],'limitschannels','ChannelsMatrix');

disp('IP_TableImageVisualization_Conditions_Color: Images were saved')


end