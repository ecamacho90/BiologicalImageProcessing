%% Plot each condition

clear all
setAnalysisParam_this
global analysisParam

%% Compute means and sterror

load('allPeaks.mat')

% meanNucIntensity = [];
% meanCytIntensity = [];
% meanNuc2CytIntensity = [];
% stdNucIntensity = [];
% stdCytIntensity = [];
% stdNuc2CytIntensity = [];
% ncellsCleanNuc = [];
% ncellsCleanCyt=[];
% ncellsCleanNucCyt=[];

allmeans = zeros(analysisParam.nCon,length(analysisParam.plotX));
allster = zeros(analysisParam.nCon,length(analysisParam.plotX));

allstercells = zeros(analysisParam.nCon,length(analysisParam.plotX));

for iCon=1:analysisParam.nCon
    
    
    
    for iTime = 1:144
        
        meanaux = [];
        ncells = 0;
        nPosreal = 0;
   
        for iPos=1:size(allPeaks,2)
        
        
        
        singleCellClean = allPeaks{iCon,iPos}{iTime};
        
        if isempty(singleCellClean)
            
        else
            
        singleCellCleanNuc = singleCellClean(~isnan(singleCellClean(:,6))&~isinf(singleCellClean(:,6)),:);
        singleCellCleanCyt = singleCellClean(~isnan(singleCellClean(:,7))&~isinf(singleCellClean(:,7)),:);
        singleCellCleanNucCyt = singleCellClean((~isnan(singleCellClean(:,7)))&(~isnan(singleCellClean(:,6)))&(~isinf(singleCellClean(:,6)))&(~isinf(singleCellClean(:,7)))&(singleCellClean(:,6)>0),:);
% 
%         ncellsCleanNuc(i,j) = size(singleCellCleanNuc,1);
%         ncellsCleanCyt(i,j) = size(singleCellCleanCyt,1);
%         ncellsCleanNucCyt(i,j) = size(singleCellCleanNucCyt,1);
%         
%         meanNucIntensity(i,j) = mean(singleCellCleanNuc(:,6));
%         meanCytIntensity(i,j) = mean(singleCellCleanCyt(:,7));
%         meanNuc2CytIntensity(i,j) = mean(singleCellCleanNucCyt(:,6)./singleCellCleanNucCyt(:,7));
%         stdNucIntensity(i,j) = std(singleCellCleanNuc(:,6));
%         stdCytIntensity(i,j) = std(singleCellCleanCyt(:,7));
%         stdNuc2CytIntensity(i,j) = std(singleCellCleanNucCyt(:,6)./singleCellCleanNucCyt(:,7));

            meanaux(iPos) = meannonan(singleCellCleanNucCyt(:,6)+singleCellCleanNucCyt(:,7));
            ncells = ncells + length(singleCellCleanNucCyt(:,7));
            nPosreal = nPosreal+1;
        end
            
        end
        allmeans(iCon,iTime) = mean(meanaux);
        allster(iCon,iTime) = std(meanaux)/sqrt(nPosreal);
        allstercells(iCon,iTime) = std(meanaux)/sqrt(ncells);
        
        
    end
    
    
      
end

x = analysisParam.plotX;
xMin = x(1);
xMax = x(length(x));

%% Plot Nuclear::H2B raw SMAD4 Intensity (standard error of mean over positions)
colors = distinguishable_colors(analysisParam.nCon);
condstoplot = [1:5,7:8]
for ii=condstoplot
    hold on
   errorbar(analysisParam.plotX,allmeans(ii,:),allster(ii,:)/2,'LineWidth',2,'Color',colors(ii,:))
%     plot(meanNucIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

xlim([xMin,xMax])

legend(analysisParam.conNames{condstoplot},'Location','eastoutside');
title('Nuclear+Cytoplasmic Intensity');
xlabel('Time (hours)')
ylabel('cNodal nuc+cyt intensity')

%% Plot Nuclear::Cyto raw SMAD4 Intensity (standard error of mean over cells) 
colors = distinguishable_colors(analysisParam.nCon);
figure
for ii=1:analysisParam.nCon
    hold on
   errorbar(analysisParam.plotX,allmeans(ii,:),allstercells(ii,:)/2,'LineWidth',2,'Color',colors(ii,:))
%     plot(meanNucIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

legend(analysisParam.conNames,'Location','eastoutside');
title('Nuclear SMAD4 Intensity');
xlabel('Time (hours)')
ylabel('SMAD4 nuc intensity')

%% Normalize by preligand
preLigand = find(analysisParam.plotX(:)<0);

for iCon = 1:analysisParam.nCon;
normalizer = mean(allmeans(iCon,preLigand));
yy = std(allmeans(iCon,preLigand))/sqrt(length(preLigand));

x = allmeans(iCon,:);
allmeansP(iCon,:) = x./normalizer;

xx=allster(iCon,:);
allsterP(iCon,:) = QuotientError(x,normalizer,xx,yy);
end

%% Plot Nuclear::Cyto normalized to preligand SMAD4 Intensity
colors = distinguishable_colors(analysisParam.nCon);

for ii=1:analysisParam.nCon
    hold on
   errorbar(allmeansP(ii,:),allsterP(ii,:)/2,'LineWidth',2,'Color',colors(ii,:))
%     plot(meanNucIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

legend(analysisParam.conNames,'Location','eastoutside');
title('Nuclear SMAD4 Intensity');
xlabel('Time (hours)')
ylabel('SMAD4 nuc intensity')

%% Normalize by control condition
controlCondition = analysisParam.controlCondition;
control = allmeansP(controlCondition,:);
control = medfilt1(control,13);
controlSigma = allsterP(controlCondition,:);

%% Plot Nuclear::Cyto normalized to preligand and control condition SMAD4 Intensity
colors = distinguishable_colors(analysisParam.nCon);

for ii=1:analysisParam.nCon
    hold on
    y = allmeansP(ii,:)./control-1+normalizer;
    e = QuotientError(allmeansP(ii,:),control,allsterP(ii,:),controlSigma)
   errorbar(y,e/2,'LineWidth',2,'Color',colors(ii,:))
%     plot(meanNucIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

legend(analysisParam.conNames,'Location','eastoutside');
title('Nuclear SMAD4 Intensity');
xlabel('Time (hours)')
ylabel('SMAD4 nuc intensity')


%% Plot Nuclear SMAD4 Intensity
colors = distinguishable_colors(analysisParam.nCon);

for i=1:analysisParam.nCon
    hold on
%    errorbar(meanNucIntensity(i,:),stdNucIntensity(i,:)/2,'LineWidth',2,'Color',colors(i,:))
    plot(meanNucIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

legend(analysisParam.conNames,'Location','eastoutside');
title('Nuclear SMAD4 Intensity');
xlabel('Time (hours)')
ylabel('SMAD4 nuc intensity')

%%
colors = distinguishable_colors(analysisParam.nCon);

figure('Position',[100 100 1200 1000])


plotX = (0:(length(singleCells{i})-1))*analysisParam.nMinutesPerFrame./60-analysisParam.tLigandAdded;

for i=1:analysisParam.nCon
    hold on
%     errorbar(meanNucIntensity(i,:),stdNucIntensity(i,:))
    plot(plotX,meanNuc2CytIntensity(i,:),'LineWidth',2,'Color',colors(i,:))
end

lgd=legend(analysisParam.conNames,'Location','northeast');
title(lgd,'Conditions','Interpreter','latex')
title('With 10uM SB');
set(gca, 'LineWidth', 1);
fs = 14;
set(gca,'FontSize', fs)
set(gca,'FontWeight', 'bold')
set(gca,'TickLabelInterpreter','latex')
xlabel('\textbf{Time (hours)}','Interpreter','latex')
ylabel('\textbf{SMAD4 nuc:cyto}','Interpreter','latex')

xlim([min(plotX),max(plotX)])
ylim([0.5,1.3])
print('Nuc2CytoSmad4_Exp9','-depsc')


