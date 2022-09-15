function plotGFP2RFP(singleCells)
global analysisParam;
% format time

mkdir(analysisParam.figDir);
% get ratios
colors = distinguishable_colors(analysisParam.nCon,{'w','k'});
filterHigh = 65000;
for iCon = 1:analysisParam.nCon;
    for iTime = find(~cellfun('isempty', singleCells{iCon}))
        R = singleCells{iCon}{iTime}(:,6)./(singleCells{iCon}{iTime}(:,5));
        
    nuc2nucMeans(iCon,iTime) = meannonan(R(R<filterHigh)); % find means of ratios less than filterHigh
    nuc2nucStd(iCon,iTime) = stdnonan(R(R<filterHigh)); % 
    nCells(iCon,iTime) = size(R(R<filterHigh),1);
    end
end

preLigand = find(analysisParam.plotX(:)<0);

x = analysisParam.plotX;
xMin = x(1);
xMax = x(length(x));
%% plot nuc2nucMeans gfp2rfp only

hold on;
for iCon = 1:analysisParam.nCon;
plot(analysisParam.plotX,nuc2nucMeans(iCon,1:analysisParam.lastTimePoint),'Color',colors(iCon,:));
end
%legend(analysisParam.conNames,'Location','eastoutside');
xlabel(['hours after ' analysisParam.ligandName ' added']);
ylabel([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
title([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
xlim([xMin xMax]);
end