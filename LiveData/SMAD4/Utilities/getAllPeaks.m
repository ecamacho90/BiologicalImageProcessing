function [ allPeaks plotX ] = getAllPeaks
%getAllPeaks reads peaks array in outfiles from a directory defined in analysisParam 
%            into allPeaks, an mxn cell where m is conditoins and n is positions
%   %% TO DO: line 8 should be based on different parameters. need to standardize allPeaks dims.
%   Probably get rid of other ways of reading data.
%%
global analysisParam;

allPeaks = cell(size(analysisParam.positionConditions,1),size(analysisParam.positionConditions,2));
%% for most fixed cell imaging
if isfield(analysisParam,'outDirecStyle') && analysisParam.outDirecStyle == 2
    
    
    for iCon = 1:analysisParam.nCon
    filenames = dir(fullfile(analysisParam.outDirec, ['Out__' analysisParam.conPrefix{iCon} '*.mat'])); %get outfiles    
        for iPos = 1:length(filenames);
        pp=load([analysisParam.outDirec filesep filenames(iPos).name]); 
    allPeaks{iCon,iPos} = pp.peaks;

        end
    end
end   

%% for outdirectory containing series of outfiles which matlab reads in correct order
if isfield(analysisParam,'outDirecStyle') && analysisParam.outDirecStyle == 3
    allPeaks = allPeaks';
    filenames = dir(fullfile(analysisParam.outDirec, ['*.mat'])); %get outfiles
            for iFile = 1:length(filenames);
                pp=load([analysisParam.outDirec filesep filenames(iFile).name]); 
                allPeaks{iFile} =  pp.peaks;
            end
            allPeaks = allPeaks';
end

%% for most andor live imaging datasets
    
if  analysisParam.outDirecStyle == 1 || ~isfield(analysisParam,'outDirecStyle')
 
for iPos = 0:analysisParam.nPos-1;
   load([analysisParam.outDirec filesep 'pos' int2str(analysisParam.positionConditions(iPos+1)) '.mat'],'peaks')
    %peaks(length(peaks)) = []; %why does it remove the last value?
   allPeaks{iPos+1} = peaks(1:analysisParam.lastTimePoint);
    clear('peaks');
    
end

plotX = (0:length(allPeaks{1})-1)*analysisParam.nMinutesPerFrame./60;
plotX = plotX-analysisParam.tLigandAdded;
analysisParam.plotX = plotX;


end
%%
i = find(cellfun(@isempty,allPeaks));
allPeaks(i)= {nan(1,9)};
save('allPeaks.mat','allPeaks','plotX');
end