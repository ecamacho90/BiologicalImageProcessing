function IP_SaveAllDataExperiment

global analysisParam

for platenum = 1:analysisParam.NumofPlates
    
load([analysisParam.savingpathforData,'/Plate',num2str(platenum),'_AllDataMatrixDAPInorm.mat'],'AllDataMatrixDAPInorm');
AllDataExperiment{1,platenum} = AllDataMatrixDAPInorm;

end

clear AllDataMatrixDAPInorm

save([analysisParam.savingpathforData,'/AllDataExperiment'])