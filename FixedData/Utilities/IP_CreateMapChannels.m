function IP_CreateMapChannels

global analysisParam;

%analysisParam.pathnamedata = '/Users/elenacamachoaguilar/Dropbox (Personal)/Rice/Experiments/181029_Commitment_time_7/Data/181109_BMPCommitment_Experiment_7_Timepoints/';
dataDir = analysisParam.pathnamedata;%
addpath(dataDir);

% Path to Ilastiks exported files:
datasetname = '/exported_data';

ChannelsPresent = {};
numchannelspresent = 0;
PlateCoordinates = {};
WellCoordinates = {};
ChannelCoordinates = {};

MaxWellWithData = 0;

for platenum = 1:analysisParam.NumofPlates
    aux=length(analysisParam.WellsWithData{platenum});
    MaxWellWithData = max(MaxWellWithData,aux);
end

ChannelsMatrix = cell(analysisParam.NumofPlates,18);


disp('Finding channels........')


for PlateNumber = 1:analysisParam.NumofPlates
    for WellNumber = analysisParam.WellsWithData{PlateNumber} 
        for ChannelNumber = 1:analysisParam.ChannelMaxNum{PlateNumber}(WellNumber)
            Channelaux = analysisParam.Channelsnames{PlateNumber}{WellNumber}{ChannelNumber};
            if ~any(strcmp(ChannelsPresent,Channelaux))
                numchannelspresent = numchannelspresent+1;
                ChannelsPresent{numchannelspresent} = Channelaux;
                PlateCoordinates{numchannelspresent}=[PlateNumber];
                WellCoordinates{numchannelspresent}=[WellNumber];
                ChannelCoordinates{numchannelspresent}=[ChannelNumber];
                ChannelsMatrix{PlateNumber,WellNumber} = [ChannelsMatrix{PlateNumber,WellNumber},numchannelspresent];

            else
                coord = find(strcmp(ChannelsPresent,Channelaux)==1);
                PlateCoordinates{coord}=[PlateCoordinates{coord},PlateNumber];
                WellCoordinates{coord}=[WellCoordinates{coord},WellNumber];
                ChannelCoordinates{coord}=[ChannelCoordinates{coord},ChannelNumber];
                ChannelsMatrix{PlateNumber,WellNumber} = [ChannelsMatrix{PlateNumber,WellNumber},coord];

            end

        end

    end
end


disp('Channels found')
analysisParam.MapChannels.ChannelsCoordMatrix = ChannelsMatrix;
analysisParam.MapChannels.DifferentChannelsPresent = ChannelsPresent;
analysisParam.MapChannels.PlateCoordinates = PlateCoordinates;
analysisParam.MapChannels.WellCoordinates = WellCoordinates;
analysisParam.MapChannels.ChannelCoordinates = ChannelCoordinates;
ChannelsPresent
disp('Map created')
disp('IP_CreateMapChannels finished')
