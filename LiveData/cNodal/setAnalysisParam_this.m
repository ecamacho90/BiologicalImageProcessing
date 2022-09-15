function setAnalysisParam_this
% for use with quickAnalysis function
global analysisParam;
fprintf(1, '%s called to define params\n',mfilename);

analysisParam.conNames = {'mTeSR 0-48h';'WNT3A 3ng/ml 0-48h';'WNT3A 30ng/ml 0-48h';'WNT3A 300ng/ml 0-48h';...
                         'CHIR 24uM 0-48h';'CHIR 12uM 0-48h';'CHIR 6uM 0-48h ';'Activin 50ng/ml 0-48h'};

analysisParam.tLigandAdded = 2; %time ligand added in hours
analysisParam.lastTimePoint = 144;

%% Main analysis parameters
analysisParam.nPos = 64; %total number of positions in dataset
analysisParam.nCon = 8; %total number of separate conditions
analysisParam.nMinutesPerFrame = 20; %minutes per frame
analysisParam.controlCondition = 1; %Negative control
analysisParam.orderConditions = [1,4,2,3,4,7,6,5];

%% normally won't have to modify below
%%compute cells parameters
analysisParam.userParam = 'setUserParamForECA_ESI017_20x1024';
analysisParam.chan = [1 2]; %nuclear channel listed first
analysisParam.data_direc = 'MaxI';

analysisParam.ligandName = 'treatment';
analysisParam.yMolecule = 'mCit-Nodal';
analysisParam.yNuc = 'CFP-H2B';




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