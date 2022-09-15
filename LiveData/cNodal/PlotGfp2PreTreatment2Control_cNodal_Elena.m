function PlotGfp2PreTreatment2Control_cNodal_Elena(singleCells,plotError)

global analysisParam;
controlCondition = analysisParam.controlCondition;
colors = distinguishable_colors(analysisParam.nCon,{'w','k'});
filterHigh = 65000;
for iCon = 1:analysisParam.nCon;
    for iTime = find(~cellfun('isempty', singleCells{iCon}))
        R = singleCells{iCon}{iTime}(:,6);%(singleCells{iCon}{iTime}(:,6)+singleCells{iCon}{iTime}(:,7));
        
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
% plot 
hold on;

control = nuc2nucMeans(controlCondition,1:analysisParam.lastTimePoint);
control = medfilt1(control,13);
controlSigma = nuc2nucStd(controlCondition,1:analysisParam.lastTimePoint);
conditionstoplot = [1,2,3,4,7,6,5]
for iCon = conditionstoplot
    y = nuc2nucMeans(iCon,1:analysisParam.lastTimePoint)./control;
plot(analysisParam.plotX,y,'Color',colors(iCon,:));
end

if plotError == 1
    for iCon = conditionstoplot
        y = nuc2nucMeans(iCon,1:analysisParam.lastTimePoint)./control;
        e = QuotientError(nuc2nucMeans(iCon,1:analysisParam.lastTimePoint),control,nuc2nucStd(iCon,1:analysisParam.lastTimePoint),controlSigma)./sqrt(nCells(iCon,1:analysisParam.lastTimePoint));        
        s = errorbar(analysisParam.plotX,y,e,'LineWidth',2,'Color',colors(iCon,:));
    end
end



[~, hobj, ~, ~] =legend(analysisParam.conNames{conditionstoplot},'Location','eastoutside');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',1.5);
% ht = findobj(hobj,'type','text')
% set(ht,'FontSize',10);
xlabel(['hours after ' analysisParam.ligandName ' added']);
ylabel([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
title('cNodal:PreTreatment:Control');
xlim([xMin xMax]);

fig = gcf;
    fig.Color = 'w';
    set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)
set(findall(fig,'-property','FontName'),'FontName','Arial')
    fig.InvertHardcopy = 'off';
saveas(fig,['figures/','PlotGfp2PreTreatment2Control_cNodal'],'svg')
saveas(fig,['figures/','PlotGfp2PreTreatment2Control_cNodal'],'fig')
saveas(fig,['figures/','PlotGfp2PreTreatment2Control_cNodal'],'png')
