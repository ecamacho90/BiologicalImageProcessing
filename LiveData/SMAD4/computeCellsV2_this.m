% computeCells_this is run after MaxI and Ilastik

%% parameters
clear;
tic;
setAnalysisParam_this;
global analysisParam;
data_direc = analysisParam.data_direc;
file_suffix = '.tif'; % may have to make further adjustments if not using andor .tif files
chan = analysisParam.chan; %first value is nuc channel, following contains other channels
paramfile = analysisParam.userParam; %the paramfile for preprocessing images
positions = [0:analysisParam.nPos-1]; %positions to run (assumes andor dataset naming conventions)
mkdir([data_direc '-OutfilesV2']);
mkdir('scripts&paramfiles');
%%
parfor pos = positions
    outfile = fullfile([data_direc '-OutfilesV2'],['pos' int2str(pos) '.mat']);
segmentCellsAndorMovie_SMAD4_3SEG( data_direc,pos,chan,paramfile,outfile );
end
toc;
copyfile(which(paramfile),['scripts&paramfiles/UserParamCopy.m']); %saves userParam with dataset
disp('Images and masks processed');

%%
analysisParam.figDir = 'figuresV2';
analysisParam.outDirec = 'MaxI-OutfilesV2';
 mkdir([analysisParam.figDir]);
%  plotMembrane;
 allPeaks = getAllPeaks;
 singleCells = allPeaks2singleCells(allPeaks);
 
 save('singleCells','singleCells')
 
 %%
 data_direc_OUT='/Volumes/Experiments/Experiment1';
 mkSignalingPlots_SMAD4(data_direc_OUT,singleCells,1);
 
    %%
  load('singleCells.mat')
 plotCounts_black(singleCells,1)
 
 %%
 data_direc_OUT='/Volumes/Experiments/Experiment1';
 mkSignalingPlots_SMAD4_Cytoplasm(data_direc_OUT,singleCells,1)

 %%
  analysisParam.figDir = 'figures';
  mkdir(analysisParam.figDir);
  data_direc_OUT='/Volumes/Experiments/Experiment1';


