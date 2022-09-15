%% Readme


%% 1.- Max Projections:
%1.- Copy setupMovieFolder to the folder of your experiment
%2.- Go to setupMovieFolder
%3.- Change imageDirec to the path to your raw images
%4.- Change newDirec to the path where you want to save the max projections
%(normally go one folder up to the raw images folder, i.e. where you copied setupMovieFolder)
%5.- Run it by running setupMovieFolder on the Command Window
% This will create the max projections in a folder called MaxI

%% 2.- Segmentation on Ilastik using the max projections
%1.- Segment nucleus using the first color, background using second color
%2.- Save Simple Segmentation!!!!!
%3.- Batch process using Simple Segmentation!!


%% 3.- Data extraction on Matlab
%1.- Copy setUserParamForECA_ESI017_20x1024.m in the experiment folder
2.- Copy setAnalysisParam_this in the experiment folder and customize it to your experiment
3.- Copy computeCellsV2_this in the experiment folder and run step by step

