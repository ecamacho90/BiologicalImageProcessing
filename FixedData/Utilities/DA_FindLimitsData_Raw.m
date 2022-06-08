function DA_FindLimitsData_Raw
%% Description
% Function that will identify all the different channels in the experiment,
% and will find the limits for each of them using all the data. It will
% also save the CleanData, that would have gotten rid of outliers

global analysisParam



minareaaux = 0;
maxareaaux = 0;
minquantile = 0;
maxquantile = 1;


load([analysisParam.savingpathforData,'/AllDataExperiment.mat'],'AllDataExperiment');


%% finding how many channels used in each well

ChannelsPresent = analysisParam.MapChannels.DifferentChannelsPresent;
numchannelspresent = length(ChannelsPresent);
PlateCoordinates = analysisParam.MapChannels.PlateCoordinates;
WellCoordinates = analysisParam.MapChannels.WellCoordinates;
ChannelCoordinates = analysisParam.MapChannels.ChannelCoordinates;
ChannelsMatrix = analysisParam.MapChannels.ChannelsCoordMatrix;


%% generating limits for the panel (per condition)

disp('Generating limits......')

limitschannels = zeros(2,length(ChannelsPresent));


for ChannelNumber = 1:length(ChannelsPresent)
    
    PlateNumAux = PlateCoordinates{ChannelNumber}(1);
    WellNumAux = WellCoordinates{ChannelNumber}(1);
    
    Data = AllDataExperiment{PlateNumAux}{WellNumAux};
    
    % Discriminate by Area if selected
    if minareaaux 
        Data = Data(Data(:,end-1)>minLimArea,:);
    end
    
    if maxareaaux 
        Data = Data(Data(:,end-1)<maxLimArea,:);
    end
    
    % Take just the data for the specific channel
    DataAll = Data(:,2+ChannelCoordinates{ChannelNumber}(1));
    
    
    
    for imageswithchannel = 1:length(PlateCoordinates{ChannelNumber})
        
        for positionnumber = 1:analysisParam.ImagesperWell
            PlateNumAux = PlateCoordinates{ChannelNumber}(imageswithchannel);
            WellNumAux = WellCoordinates{ChannelNumber}(imageswithchannel);
    
            Data = AllDataExperiment{PlateNumAux}{WellNumAux};
            
            % Discriminate by Area if selected
            if minareaaux 
                Data = Data(Data(:,end-1)>minLimArea,:);
            end

            if maxareaaux 
                Data = Data(Data(:,end-1)<maxLimArea,:);
            end

            % Take just the data for the specific channel
            DataAll = [DataAll;Data(:,2+ChannelCoordinates{ChannelNumber}(imageswithchannel))];
            
        end
        
    end
    
    %Compute limits
    
    limitsaux = [quantile(DataAll,minquantile); ...
                quantile(DataAll,maxquantile)];    
            
    limitschannels(:,ChannelNumber) = limitsaux;
     
        
end

%%

disp('Saving Clean Data.....')

AllDataExperimentClean = cell(1,analysisParam.NumofPlates);
minarea2 = -2;
maxarea2 = -2;

for platenumber = 1:analysisParam.NumofPlates
   AllDataExperimentClean{platenumber} = {};
    
for wellnumber = analysisParam.WellsWithData{platenumber}

    AllDataExperimentClean{platenumber}{wellnumber} = [];
    AllDataAux = AllDataExperiment{platenumber}{wellnumber};  
    
            for channelnumber = 1:4
                
                AllDataAux = AllDataAux(AllDataAux(:,2+channelnumber)>limitschannels(1,ChannelsMatrix{platenumber,wellnumber}(channelnumber)),:);
                AllDataAux = AllDataAux(AllDataAux(:,2+channelnumber)<limitschannels(2,ChannelsMatrix{platenumber,wellnumber}(channelnumber)),:);
                
            end
            
            if minarea2<0
                minarea2 = min(AllDataAux(:,end-1));
            else
                minarea2 = min([minarea2;AllDataAux(:,end-1)]);
            end
            
            if maxarea2<0
                maxarea2 = max(AllDataAux(:,end-1));
            else
                maxarea2 = max([maxarea2;AllDataAux(:,end-1)]);
            end
                
            
    AllDataExperimentClean{platenumber}{wellnumber} = AllDataAux;        
end

end

quantiles = [minquantile,maxquantile];
limAreas = [minarea2,maxarea2];
AllDataExperiment = AllDataExperimentClean;

%%

%%

limitsbars = zeros(2,numchannelspresent);
for channelnum = 1:numchannelspresent

% MatrixToPlot=[];
% grp1=[];
meanData = [];
stdData = [];

    for imageswithchannel = 1:length(PlateCoordinates{channelnum})

            PlateNumAux = PlateCoordinates{channelnum}(imageswithchannel);
            WellNumAux = WellCoordinates{channelnum}(imageswithchannel);
            ChannelNumAux = ChannelCoordinates{channelnum}(imageswithchannel);
    
            Data = AllDataExperiment{PlateNumAux}{WellNumAux};

            meanDataAux = zeros(1,Data(end,end));
            
            for posnum = 1:Data(end,end)
                
                indposnum = find(Data(:,end)==posnum);
                meanDataAux(posnum) = mean(Data(indposnum,2+ChannelNumAux));
            end
            
            meanData = [meanData,meannonan(meanDataAux)];
            stdData = [stdData,stdnonan(meanDataAux)/sqrt(Data(end,end))];
            
  
    end
    
    limitsbars(:,channelnum) = [min((meanData-stdData/2));max((meanData+stdData/2))];
    
end



save([analysisParam.savingpathforData,'/AllDataExperiment'],'AllDataExperiment','limitschannels','quantiles','limAreas','limitsbars','analysisParam');

disp('Saved data')
