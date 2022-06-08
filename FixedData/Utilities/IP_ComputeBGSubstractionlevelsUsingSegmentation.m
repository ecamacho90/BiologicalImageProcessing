function IP_ComputeBGSubstractionlevelsUsingSegmentation

disp('Computing background values for each channel....')
global analysisParam

dataDir = analysisParam.pathnamedata;%
addpath(dataDir);

% Path to Ilastiks exported files:
datasetname = '/exported_data';

bgvalues = repmat(-100,length(analysisParam.MapChannels.DifferentChannelsPresent));
        
%% Find background levels for each channels using segmentation

for PlateNum = 1:analysisParam.NumofPlates
    fprintf(['***********************','\n'])
    fprintf(['***********************','\n'])
    fprintf(['Plate:', num2str(PlateNum),'\n'])
    fprintf(['***********************','\n'])
    fprintf(['***********************','\n'])
    
for WellNumber = analysisParam.WellsWithData{PlateNum}
  
    fprintf(['-----------------------','\n'])
    fprintf(['-----------------------','\n'])
    fprintf(['Well:', num2str(WellNumber),'\n'])
    fprintf(['-----------------------','\n'])
    fprintf(['-----------------------','\n'])

for nposition = 1:analysisParam.ImagesperWell

    fprintf(['Position:', num2str(nposition),'\n'])
    fprintf(['-----------------------','\n'])
    
positionname=['P',num2str(PlateNum),'_','W',num2str(WellNumber),'_',num2str(nposition),'_MAXProj']

% positionname=['W',num2str(WellNumber),'_',num2str(nposition)];%,'_MAXProj'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       READ AND CHECK DATA           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Defines filenames of input data
filenameNuclei = fullfile(dataDir, [positionname,'_Simple Segmentation.h5'])


%% Read segmentation data (1: nucleus, 2: background), of DAPI and the bright spots in the other three channels.

% Read segmentation data (squeeze removes excessive dimensions) and turn everything that was red into 1 in binary mode
% Segmentation definition, 1: nucleus, 2: background
foregroundLabel =1;
nucleisegmentation = squeeze(h5read(filenameNuclei,datasetname)) == foregroundLabel;
nucleisegmentation=nucleisegmentation(:,:,1)';


dimensions = size(nucleisegmentation);

%% Read RAW data and substract background



for ii = 1:analysisParam.ChannelMaxNum{PlateNum}(WellNumber)
    imauxfluorescencelevels = imread(fullfile(dataDir,[positionname,'.tif']), ii);    

        fgMask = imclose(nucleisegmentation,strel('disk',5));
        bgMaskprov = imerode(~fgMask,strel('disk',10));
        
        if length(bgMaskprov)>100
            if bgvalues(analysisParam.MapChannels.ChannelsCoordMatrix{PlateNum,WellNumber}(ii))<0
                bgvalues(analysisParam.MapChannels.ChannelsCoordMatrix{PlateNum,WellNumber}(ii)) = mean(imauxfluorescencelevels(bgMaskprov));
            else
                bgvalues(analysisParam.MapChannels.ChannelsCoordMatrix{PlateNum,WellNumber}(ii)) = min(bgvalues(analysisParam.MapChannels.ChannelsCoordMatrix{PlateNum,WellNumber}(ii)),mean(imauxfluorescencelevels(bgMaskprov)));
            end
        end


    
end

end
end
end

errorbgvalues = find(bgvalues<0);

bgvalues(errorbgvalues) = zeros(1,length(errorbgvalues));

analysisParam.bgvalues = bgvalues;

save([analysisParam.savingpathforImages,'/bgvalues'],'bgvalues');

