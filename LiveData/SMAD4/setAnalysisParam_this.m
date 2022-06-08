function setAnalysisParam_this
% for use with quickAnalysis function
global analysisParam;
fprintf(1, '%s called to define params\n',mfilename);

analysisParam.conNames = {'C1','C2','C3','C4','C5','C6','C7','C8','C9'};

analysisParam.tLigandAdded = 0; %time ligand added in hours
analysisParam.lastTimePoint = 80;
%% normally won't have to modify below
%%compute cells parameters
analysisParam.userParam = 'setUserParamForECA_ESI017_20x1024';
analysisParam.chan = [2 1]; %nuclear channel listed first
analysisParam.data_direc = 'MaxI';
%% Main analysis parameters
analysisParam.nPos = 55; %total number of positions in dataset
analysisParam.nCon = 11; %total number of separate conditions
analysisParam.nMinutesPerFrame = 15; %minutes per frame
analysisParam.ligandName = 'treatment';
analysisParam.yMolecule = 'GFP-SMAD4';
analysisParam.yNuc = 'RFP-H2B';

analysisParam.controlCondition = 11;
analysisParam.orderConditions = [11,1:10];

%% Shouldn't need to modify below
analysisParam.figDir = 'figures';
analysisParam.outDirec = 'MIP-OutfilesV2';
analysisParam.isFixedCells = 0;
analysisParam.isAndorMovie = 1;
analysisParam.outDirecStyle = 1;% 1 for Andor IQ style (i.e., posX.mat) % 2 for Out_ConditionPrefix_X.mat style
 %directory containing outfiles for each position 
analysisParam.nPosPerCon = analysisParam.nPos./analysisParam.nCon; %set how many positions per condition
analysisParam.backgroundPositions = nan; %array of positions for bg subtraction
analysisParam.fig = 20; %set which figure to start plotting at
%find x Axis
% load([analysisParam.outDirec filesep 'pos0.mat']);
% plotX = 0:(length(peaks)-1)*analysisParam.nMinutesPerFrame./60;
% analysisParam.plotX = plotX-analysisParam.tLigandAdded;
% analysisParam.plotX = (0:(length(peaks)-1))*analysisParam.nMinutesPerFrame./60-analysisParam.tLigandAdded;
analysisParam.plotX = (0:(analysisParam.lastTimePoint-1))*analysisParam.nMinutesPerFrame./60-analysisParam.tLigandAdded;
positionConditions = zeros(analysisParam.nPosPerCon,analysisParam.nCon);
positionConditions(:) = 0:analysisParam.nPos-1;
analysisParam.positionConditions = positionConditions';
end