function PlotGfp2Rfp2PreTreatment(singleCells,plotError)
global analysisParam;

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

if isempty(preLigand)
    
    x = analysisParam.plotX(1:size(nuc2nucMeans,2));
xMin = x(1);
xMax = x(length(x));
hold on
    
    for iCon = 1:analysisParam.nCon;
    plot(analysisParam.plotX(1:size(nuc2nucMeans,2)),nuc2nucMeans(iCon,:),'Color',colors(iCon,:));
    end
if plotError == 1
    for iCon = 1:analysisParam.nCon;
        e = nuc2nucStd(iCon,:)./sqrt(nCells(iCon,:));
        s = errorbar(analysisParam.plotX(1:size(nuc2nucMeans,2)),nuc2nucMeans(iCon,:),e,'LineWidth',.1,'Color',colors(iCon,:));
    end
end

legend(analysisParam.conNames,'Location','eastoutside');
xlabel(['hours after ' analysisParam.ligandName ' added']);
ylabel([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
title([analysisParam.yMolecule,':',analysisParam.yNuc,':PreTreatment']);
xlim([xMin xMax]);

else
    
    
x = analysisParam.plotX(1:size(nuc2nucMeans,2));
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
    plot(analysisParam.plotX(1:size(nuc2nucMeans,2)),nuc2nucMeans(iCon,:),'Color',colors(iCon,:));
end
if plotError == 1
    for iCon = 1:analysisParam.nCon;
        e = nuc2nucStd(iCon,:)./sqrt(nCells(iCon,:));
        s = errorbar(analysisParam.plotX(1:size(nuc2nucMeans,2)),nuc2nucMeans(iCon,:),e,'LineWidth',.1,'Color',colors(iCon,:));
    end
end

legend(analysisParam.conNames,'Location','eastoutside');
xlabel(['hours after ' analysisParam.ligandName ' added']);
ylabel([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
title([analysisParam.yMolecule,':',analysisParam.yNuc,':PreTreatment']);
xlim([xMin xMax]);

end