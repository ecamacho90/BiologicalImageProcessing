function IP_NormaliseDataDAPI

global analysisParam

ChannelMax = 4;


for platenum = 1:analysisParam.NumofPlates
    
disp(['Plate number:',num2str(platenum)])

% analysisParam.NumofWells = 8;
AllDataCell = cell(1,1);
AllDataMatrix = cell(1,analysisParam.NumofWells);
AllDataMatrixDAPInorm = cell(1,analysisParam.NumofWells);
CellNumberPosition = cell(1,analysisParam.NumofWells);

for wellnum = analysisParam.WellsWithData{platenum}
    
load([analysisParam.savingpathforData,'/Plate',num2str(platenum),'_Well',num2str(wellnum),'_Data.mat'],'alldata');
AllDataCell{wellnum} = alldata;

    for positionnumber = 1:size(alldata,2)
        AllDataMatrix{wellnum} = [AllDataMatrix{wellnum};[alldata{positionnumber},positionnumber*ones(size(alldata{positionnumber},1),1)]];
        if isempty(alldata{positionnumber})
        else
        AllDataMatrixDAPInorm{wellnum} = [AllDataMatrixDAPInorm{wellnum};[alldata{positionnumber}(:,1:3),alldata{positionnumber}(:,4:(ChannelMax+2))./alldata{positionnumber}(:,3),alldata{positionnumber}(:,ChannelMax+3),positionnumber*ones(size(alldata{positionnumber},1),1)]]; % [xposition,yposition,rawDAPI,normalisedCDX2,normalisedSOX2,normalisedBRA,Area,PositioninWell] 
        end
        CellNumberPosition{wellnum}(positionnumber) = size(alldata{positionnumber},1);
    end
      
end

NamesConditions = analysisParam.NamesConditions{platenum};


minnormValues = min(AllDataMatrixDAPInorm{analysisParam.WellsWithData{platenum}(1)}(:,3:(ChannelMax+2)));
maxnormValues = max(AllDataMatrixDAPInorm{analysisParam.WellsWithData{platenum}(1)}(:,3:(ChannelMax+2)));

for wellnum = analysisParam.WellsWithData{platenum}
    minnormValues = min([minnormValues;AllDataMatrixDAPInorm{wellnum}(:,3:(ChannelMax+2))]);
    maxnormValues = max([maxnormValues;AllDataMatrixDAPInorm{wellnum}(:,3:(ChannelMax+2))]);
end

analysisParam.minnormValues = minnormValues;
analysisParam.maxnormValues = maxnormValues;

save([analysisParam.savingpathforData,'/Plate',num2str(platenum),'_AllDataMatrixDAPINorm.mat'])

end