function PlotGfpNucCyto2PreTreatment(singleCells,plotError)
global analysisParam;

colors = distinguishable_colors(analysisParam.nCon,{'w','k'});
filterHigh = 65000;
for iCon = 1:analysisParam.nCon;
    for iTime = find(~cellfun('isempty', singleCells{iCon}))
        R = (singleCells{iCon}{iTime}(:,6)+singleCells{iCon}{iTime}(:,7));
        
    nuc2nucMeans(iCon,iTime) = meannonan(R(R<filterHigh)); % find means of ratios less than filterHigh
    nuc2nucStd(iCon,iTime) = stdnonan(R(R<filterHigh)); % 
    nCells(iCon,iTime) = size(R(R<filterHigh),1);
    end
end

preLigand = find(analysisParam.plotX(:)<0);

x = analysisParam.plotX;
xMin = x(1);
xMax = x(length(x));

for iCon = 1:analysisParam.nCon;
normalizer = mean(nuc2nucMeans(iCon,preLigand));
yy = std(nuc2nucMeans(iCon,preLigand));
x = nuc2nucMeans(iCon,:);
nuc2nucMeans(iCon,:) = x./normalizer;
xx=nuc2nucStd(iCon,:);
nuc2nucStd(iCon,:) = QuotientError(x,normalizer,xx,yy);

end
% plot nuc2nucMeans
hold on;

for iCon = 1:analysisParam.nCon;
    plot(analysisParam.plotX,nuc2nucMeans(iCon,1:analysisParam.lastTimePoint),'Color',colors(iCon,:));
end
if plotError == 1
    for iCon = 1:analysisParam.nCon;
        e = nuc2nucStd(iCon,:)./sqrt(nCells(iCon,:));
        s = errorbar(analysisParam.plotX,nuc2nucMeans(iCon,1:analysisParam.lastTimePoint),e,'LineWidth',.1,'Color',colors(iCon,:));
    end
end

legend(analysisParam.conNames,'Location','eastoutside');
xlabel(['hours after ' analysisParam.ligandName ' added']);
ylabel([analysisParam.yMolecule]);
title([analysisParam.yMolecule,':PreTreatment']);
xlim([xMin xMax]);

end