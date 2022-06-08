%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                   DATA ANALYSIS  SCRIPT TEMPLATE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('analysisParam','var')
    AnalysisParamScript
    global analysisParam
    load([analysisParam.savingpathforData,'/AllDataExperiment.mat'],'AllDataExperiment');
    
end
    


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                   CLEAN DATA (OPTIONAL)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(analysisParam.pathnamesave)
minArea = 60;
maxArea = 1000;

minquantile = 0.005;
maxquantile = 0.995;

%If no Background image provided:
options = {'minlimarea',minArea,'maxlimarea',maxArea,'minquantile',minquantile,'maxquantile',maxquantile};

DA_FindLimitsData(options)



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                   BAR PLOTS OF DATA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(analysisParam.pathnamesave)

ConditionsSelection = [1 1 1 1 1 1 1 1; ... %Plate
                       1 2 3 4 5 6 7 8];    %Well     
titleplottosave='BMP2ng';

%Optional options
raworclean = 0; %0 if RAW data, 1 if using CLEAN data (0 default)
blackBG = 0; %0 if white background, 1 if black background (0 default)
channelnums = [2,4,3]; %choose channels in analysisParam.MapChannels.DifferentChannelsPresent, (analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)} default)
stdmean = 1; %1 if plotting std of the mean, 0 if plotting std of data;
angleticks = 45; %angle for xticks in barplots
title = 'BMP 2ng';
[sidx,ordercolors]=sort(channelnums);

options = {'raworclean',raworclean,'blackbg',blackBG,'channels',channelnums,'stdmean',stdmean,'angleticks',angleticks,'title',title,'ordercolors',ordercolors};

DA_BarPlotsData_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,options)
%%
cd(analysisParam.pathnamesave)

ConditionsSelection = [1 1 1 1 1 1 1 1; ... %Plate
                       1 2 3 4 5 6 7 8];    %Well     
titleplottosave='BMP2ng';

%Optional options
raworclean = 1; %0 if RAW data, 1 if using CLEAN data (0 default)
blackBG = 0; %0 if white background, 1 if black background (0 default)
channelnums = [2,4,3]; %choose channels in analysisParam.MapChannels.DifferentChannelsPresent, (analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)} default)
stdmean = 1; %1 if plotting std of the mean, 0 if plotting std of data;
angleticks = 45; %angle for xticks in barplots
title = 'BMP 2ng';
[sidx,ordercolors]=sort(channelnums);
uniformlimits = 0;

options = {'raworclean',raworclean,'blackbg',blackBG,'channels',channelnums,'stdmean',stdmean,'angleticks',angleticks,'title',title,'uniformlimits',uniformlimits,'ordercolors',ordercolors};

DA_BarPlotsData_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,options)

%%
cd(analysisParam.pathnamesave)
ConditionsSelection = [2 2 2 2 2 2 2 2; ... %Plate
                       1 2 3 4 5 6 7 8];    %Well     
titleplottosave='BMP3ng';

%Optional options
raworclean = 0; %0 if RAW data, 1 if using CLEAN data (0 default)
blackBG = 0; %0 if white background, 1 if black background (0 default)
channelnums = [2,3,4]; %choose channels in analysisParam.MapChannels.DifferentChannelsPresent, (analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)} default)
stdmean = 1; %1 if plotting std of the mean, 0 if plotting std of data;
angleticks = 0; %angle for xticks in barplots
title = 'BMP 3ng';
[sidx,ordercolors]=sort(channelnums);

options = {'raworclean',raworclean,'blackbg',blackBG,'channels',channelnums,'stdmean',stdmean,'angleticks',angleticks,'title',title,'ordercolors',ordercolors};

DA_BarPlotsData_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,options)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                   VIOLIN PLOTS OF DATA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConditionsSelection = [1 1 1 1 1 1 1 1; ... %Plate
                       1 2 3 4 5 6 7 8];    %Well     
titleplottosave='BMP2ng';

%Optional options
raworclean = 0; %0 if RAW data, 1 if using CLEAN data (0 default)
blackBG = 0; %0 if white background, 1 if black background (0 default)
channelnums = [2,3,4]; %choose channels in analysisParam.MapChannels.DifferentChannelsPresent, (analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)} default)
stdmean = 1; %1 if plotting std of the mean, 0 if plotting std of data;
angleticks = 0; %angle for xticks in barplots
title = 'ISL1-GATA3-TBX6-48-72';
[sidx,ordercolors]=sort(channelnums);
uniformlimits = 1;

options = {'raworclean',raworclean,'blackbg',blackBG,'channels',channelnums,'stdmean',stdmean,'angleticks',angleticks,'title',title,'uniformlimits',uniformlimits,'ordercolors',ordercolors};

DA_ViolinPlotsData_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,options)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                  SCATTER PLOTS OF DATA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConditionsSelection = [1 1 1 1 1 1 1 1; ... %Plate
                       1 2 3 4 5 6 7 8];    %Well     
titleplottosave='BMP2ng';

%Optional options
raworclean = 0; %0 if RAW data, 1 if using CLEAN data (0 default)
blackBG = 0; %0 if white background, 1 if black background (0 default)
channelnums = [2,3,4]; %choose channels in analysisParam.MapChannels.DifferentChannelsPresent, (analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)} default)
stdmean = 1; %1 if plotting std of the mean, 0 if plotting std of data;
angleticks = 0; %angle for xticks in barplots
title = 'BMP24-ISL1-GATA3-BRA-48-72';
[sidx,ordercolors]=sort(channelnums);
uniformlimits = 1;

options = {'raworclean',raworclean,'blackbg',blackBG,'channels',channelnums,'stdmean',stdmean,'angleticks',angleticks,'title',title,'uniformlimits',uniformlimits,'ordercolors',ordercolors};

DA_HeatScatter_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,options)
