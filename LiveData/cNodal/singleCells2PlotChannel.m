function [ output_args ] = singleCells2PlotChannel( singleCells,channel,filterHigh )
%singleCells2Plots generates a few plots to quickly look at singleCells
%dataset
%   
global analysisParam;
% format time


% get ratios
colors = distinguishable_colors(analysisParam.nCon,{'w','k'});

for iCon = 1:analysisParam.nCon;
    for iTime = find(~cellfun('isempty', singleCells{iCon}))
        
        R = singleCells{iCon}{iTime}(:,channel);
     
        
    nuc2nucMeans(iCon,iTime) = meannonan(R(R<filterHigh)); % find means of ratios less than filterHigh
    nuc2nucStd(iCon,iTime) = stdnonan(R(R<filterHigh)); % 
    nCells(iCon,iTime) = size(R(R<filterHigh),1);
    end
end
% plot nuc2nucMeans
hold on;
for iCon = 1:analysisParam.nCon;
%     size(nuc2nucMeans)
plot(analysisParam.plotX,nuc2nucMeans(iCon,1:analysisParam.lastTimePoint),'Color',colors(iCon,:));
end
%legend(analysisParam.conNames,'Location','best');
xlabel(['hours after ' analysisParam.ligandName ' added']);
x = analysisParam.plotX;
xMin = x(1);
xMax = x(length(x));
xlim([xMin xMax]);
if channel==5
title([analysisParam.yNuc]);
ylabel(['nuclear ' analysisParam.yNuc]);
% savefig([analysisParam.figDir filesep analysisParam.yNuc '.fig']);
end
if channel==6
title([analysisParam.yMolecule]);
ylabel(['nuclear ' analysisParam.yMolecule]);
%savefig(['figures/' analysisParam.yMolecule '.fig']);
end   
if channel==3
title(['Area']);
ylabel(['Mean Area']);
%savefig(['figures/' analysisParam.yMolecule '.fig']);
end  

% plot mean with cell STD
% figure; clf; hold on;
% for iCon = 1:analysisParam.nCon;
% errorbar(analysisParam.plotX(1:size(nuc2nucMeans,2)),nuc2nucMeans(iCon,:),nuc2nucStd(iCon,:),'Color',colors(iCon,:),'LineWidth',2);
% end
% legend(analysisParam.conNames,'Location','best');
% xlabel(['hours after ' analysisParam.ligandName ' added']);
% ylabel([analysisParam.yMolecule ' : ' analysisParam.yNuc]);
% title('mean signaling w/ cell std');

% plot # of cells in each mean
% figure; clf; hold on;
% for iCon = 1:analysisParam.nCon;
% plot(analysisParam.plotX(1:size(nuc2nucMeans,2)),nCells(iCon,:),'Color',colors(iCon,:),'LineWidth',2);
% end
% legend(analysisParam.conNames,'Location','eastoutside');
% xlabel(['hours after ' analysisParam.ligandName ' added']);
% ylabel('# of cells');
% title('detected cells');

end

