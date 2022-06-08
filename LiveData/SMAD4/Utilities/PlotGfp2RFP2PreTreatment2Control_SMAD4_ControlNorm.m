function PlotGfp2RFP2PreTreatment2Control_SMAD4_ControlNorm(data_direc_OUT,plotError,plotlegend,newplot,blackbackground)

load([data_direc_OUT filesep 'singlecells.mat'])
if newplot
figure;
set(gcf,'Position',[10 10 1200 700])
end
FontNameUse = 'Arial';

% setAnalysisParam_this
global analysisParam;
controlCondition = analysisParam.controlCondition;
colors = distinguishable_colors(analysisParam.nCon,{'w','k'});
% colors([3,5,6],:) = 0;

filterHigh = 65000;
filterLow = 600;
for iCon = 1:analysisParam.nCon;
    for iTime = find(~cellfun('isempty', singleCells{iCon}))
%         x=find(singleCells{iCon}{iTime}(:,7)>600);
%         R = (singleCells{iCon}{iTime}(x,6)./singleCells{iCon}{iTime}(x,7));
        R = (singleCells{iCon}{iTime}(:,6)./singleCells{iCon}{iTime}(:,7));
        
    nuc2nucMeans(iCon,iTime) = meannonan(R((R<filterHigh)));%&(singleCells{iCon}{iTime}(:,5)>nucmin))); % find means of ratios less than filterHigh
    nuc2nucStd(iCon,iTime) = stdnonan(R((R<filterHigh)));%&(singleCells{iCon}{iTime}(:,5)>nucmin))); % 
    nCells(iCon,iTime) = size(R((R<filterHigh)),1);%&(singleCells{iCon}{iTime}(:,5)>nucmin)),1);
    end
end
size(nuc2nucMeans)
preLigand = find(analysisParam.plotX(:)<0);

if isempty(preLigand)
    
    x = analysisParam.plotX(1:size(nuc2nucMeans,2));
xMin = x(1);
xMax = x(length(x));

% plot 
hold on;

control = nuc2nucMeans(controlCondition,:);
control = medfilt1(control,13);
controlSigma = nuc2nucStd(controlCondition,:);

for iCon = analysisParam.orderConditions%1:analysisParam.nCon;
    y = nuc2nucMeans(iCon,:)./control;
plot(analysisParam.plotX(1:size(nuc2nucMeans,2)),y,'Color',colors(iCon,:));
end

if plotError == 1
    for iCon = analysisParam.orderConditions%1:analysisParam.nCon; %[3,5,6,1,2,4,7,8]%
        y = nuc2nucMeans(iCon,:)./control;
        e = QuotientError(nuc2nucMeans(iCon,:),control,nuc2nucStd(iCon,:),controlSigma)./sqrt(nCells(iCon,:));        
        s = errorbar(analysisParam.plotX(1:size(nuc2nucMeans,2)),y,e,'LineWidth',2,'Color',colors(iCon,:));
    end
end



if blackbackground 

if plotlegend
[~, hobj, ~, ~] =legend(analysisParam.conNames(analysisParam.orderConditions),'Location','eastoutside','FontSize',18,'FontName',FontNameUse,'LineWidth',2,'TextColor','w','Color','k','EdgeColor','w');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2,'Color','w');
end
% ht = findobj(hobj,'type','text')
% set(ht,'FontSize',10);
xlabel(['hours after ' analysisParam.ligandName ' added'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold','Color','w');
%,'Interpreter','latex','FontWeight','bold');
ylabel([analysisParam.yMolecule ':RFP:Pretreatment:Control'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold','Color','w');
if ~newplot
title('Nuc:RFP:PreTreatment:Control','Color','w');
end
xlim([xMin xMax]);
% xlim([xMin 48]);
% ylim([0.8 1.5]);

ax = gca; 
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';
ax.ZLimMode = 'manual';

set(gca,'Color','k')
set(gca,'XColor','w')
set(gca,'YColor','w')




fig = gcf;
fig.Color = 'k';
fig.InvertHardcopy = 'off';
set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)
set(findall(fig,'-property','FontName'),'FontName',FontNameUse)

saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'fig')
saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'svg')

set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'pdf')
    
    
    
    
else


if plotlegend
[~, hobj, ~, ~] =legend(analysisParam.conNames(analysisParam.orderConditions),'Location','eastoutside','FontSize',18,'FontName','Arial','LineWidth',2);
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2);
end
% ht = findobj(hobj,'type','text')
% set(ht,'FontSize',10);
xlabel(['hours after ' analysisParam.ligandName ' added'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold');
%,'Interpreter','latex','FontWeight','bold');
ylabel([analysisParam.yMolecule ':RFP:Pretreatment:Control'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold');
if ~newplot
title('GFP:RFP:PreTreatment:Control');
end
xlim([xMin xMax]);
% xlim([xMin 48]);
% ylim([0.8 1.5]);

ax = gca; 
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';
ax.ZLimMode = 'manual';




fig = gcf;

set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'fig')
saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'svg')


set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'pdf')
    
end
    
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
% plot 
hold on;

control = nuc2nucMeans(controlCondition,:);
control = medfilt1(control,13);
controlSigma = nuc2nucStd(controlCondition,:);

for iCon = analysisParam.orderConditions%1:analysisParam.nCon;
    y = nuc2nucMeans(iCon,:)./control;
plot(analysisParam.plotX(1:size(nuc2nucMeans,2)),y,'Color',colors(iCon,:));
end

if plotError == 1
    for iCon = analysisParam.orderConditions%1:analysisParam.nCon; %[3,5,6,1,2,4,7,8]%
        y = nuc2nucMeans(iCon,:)./control;
        e = QuotientError(nuc2nucMeans(iCon,:),control,nuc2nucStd(iCon,:),controlSigma)./sqrt(nCells(iCon,:));        
        s = errorbar(analysisParam.plotX(1:size(nuc2nucMeans,2)),y,e,'LineWidth',2,'Color',colors(iCon,:));
    end
end



if blackbackground 

if plotlegend
[~, hobj, ~, ~] =legend(analysisParam.conNames(analysisParam.orderConditions),'Location','eastoutside','FontSize',18,'FontName',FontNameUse,'LineWidth',2,'TextColor','w','Color','k','EdgeColor','w');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2,'Color','w');
end
% ht = findobj(hobj,'type','text')
% set(ht,'FontSize',10);
xlabel(['hours after ' analysisParam.ligandName ' added'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold','Color','w');
%,'Interpreter','latex','FontWeight','bold');
ylabel([analysisParam.yMolecule ':RFP:Pretreatment:Control'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold','Color','w');
if ~newplot
title('Nuc:RFP:PreTreatment:Control','Color','w');
end
xlim([xMin xMax]);
% xlim([xMin 48]);
% ylim([0.8 1.5]);

ax = gca; 
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';
ax.ZLimMode = 'manual';

set(gca,'Color','k')
set(gca,'XColor','w')
set(gca,'YColor','w')




fig = gcf;
fig.Color = 'k';
fig.InvertHardcopy = 'off';
set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)
set(findall(fig,'-property','FontName'),'FontName',FontNameUse)

saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'fig')
saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'svg')

set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'Black-GFP2RFP2Pre2Control-SMAD4'],'pdf')
    
    
    
    
else


if plotlegend
[~, hobj, ~, ~] =legend(analysisParam.conNames(analysisParam.orderConditions),'Location','eastoutside','FontSize',18,'FontName','Arial','LineWidth',2);
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2);
end
% ht = findobj(hobj,'type','text')
% set(ht,'FontSize',10);
xlabel(['hours after ' analysisParam.ligandName ' added'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold');
%,'Interpreter','latex','FontWeight','bold');
ylabel([analysisParam.yMolecule ':RFP:Pretreatment:Control'],'FontSize',18,'FontName',FontNameUse,'FontWeight','bold');
if ~newplot
title('GFP:RFP:PreTreatment:Control');
end
xlim([xMin xMax]);
% xlim([xMin 48]);
% ylim([0.8 1.5]);

ax = gca; 
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';
ax.ZLimMode = 'manual';




fig = gcf;

set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'fig')
saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'svg')


set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'GFP2RFP2Pre2Control-SMAD4'],'pdf')
    
end
end