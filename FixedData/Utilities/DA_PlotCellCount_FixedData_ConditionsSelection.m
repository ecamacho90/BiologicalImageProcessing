
function DA_PlotCellCount_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,varargin)


global analysisParam;

if ( length(varargin) == 1 )
    varargin = varargin{:};
end

raworclean = 0;
blackBG = 0;
stdmean = 1;
angleticks = 0;
uniformlimits = 1;


raworcleantitle = {'RAW','CLEAN'};

Title=[titleplottosave,' ', raworcleantitle{raworclean+1}];


channelnums = analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,1),ConditionsSelection(2,1)};


while ~isempty(varargin)
    switch lower(varargin{1})
          case {'raworclean'}
              raworclean = varargin{2};   
          case {'blackbg'}
              blackBG = varargin{2};  
          case {'channels'}
              channelnums = varargin{2}; 
              ordercolors = 1:length(channelnums);
          case {'stdmean'}
              stdmean = varargin{2}; 
          case {'angleticks'}
              angleticks = varargin{2};  
          case {'title'}
              Title = [varargin{2}];  
          case {'uniformlimits'}
              uniformlimits = [varargin{2}]; 
          case {'ordercolors'}
              ordercolors = [varargin{2}]; 
              

    otherwise
        error(['Unexpected option: ' varargin{1}])
    end
      varargin(1:2) = [];
end

analysisParam.figDir = [analysisParam.pathnamesave filesep 'figures'];
mkdir(analysisParam.figDir)


%%

if raworclean
    load([analysisParam.savingpathforData filesep 'AllDataExperimentClean.mat'])
    
else
    load([analysisParam.savingpathforData filesep 'AllDataExperiment.mat'])
    
end

if blackBG
    
    colorbg = 'k';
    colorfont = 'w';
    colorbgplotname = 'BLACK';
    
else
    
    colorbg = 'w';
    colorfont = 'k';
    colorbgplotname = 'WHITE';
end


%% Violin plot
nCon = length(ConditionsSelection);
nCon = length(ConditionsSelection);

%% Bar Plot
    
figure;
set(gcf,'Position',[10 10 1200 1000])
% colourclusters = {colorconvertorRGB([236,28,36]),colorconvertorRGB([249,236,49]),colorconvertorRGB([64,192,198])};
% colourclusters = {'g','r','b'};
    

% tiledlayout(nChan,1,'TileSpacing','compact')




celln = 0;
xticksnum = [];
daystickslabels = {};
plotshandle = [];
legendhandle = {};
% MatrixToPlot=[];
% grp1=[];
meanData = [];
stdData = [];
    
    for condnum = 1:nCon
        
        if stdmean
            meanDataAux = zeros(1,AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end));
            
            for posnum = 1:AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end)
                
                indposnum = find(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,end)==posnum);
                meanDataAux(posnum) = length(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(indposnum,1))*(10000^2)/(665.6^2);%34.77/5;
            end
            
            meanData = [meanData,meannonan(meanDataAux)];
            stdData = [stdData,stdnonan(meanDataAux)/sqrt(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end))];
            
        else
                    
            meanData = [meanData,(length(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,1))/AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end))*(10000^2)/(665.6^2)];%*34.77/5];
            stdData = [stdData,0];
            
        end
        

        daystickslabels{condnum} = analysisParam.NamesConditions{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)};
        
  
    end
    
    hold on

    bar(1:nCon,meanData,'EdgeColor',colorfont);
    errorbar(1:nCon,meanData,stdData/2,'.','Color',colorfont)
    
    
    ylabel('cells/cm2','Color',colorfont);

    xticks(1:nCon)
    
  ylim([0,400000])
    

        xticklabels((daystickslabels(1:nCon)));    

    

    title('Final Cell count/cm^2','Color',colorfont)

    
    xtickangle(angleticks)
    
    set(gca, 'LineWidth', 2);
    set(gca,'FontWeight', 'bold')
    set(gca,'FontName','Arial')
    set(gca,'FontSize',18)
    set(gca,'Color',colorbg)
    set(gca,'Color',colorbg)
    set(gca,'XColor',colorfont)
    set(gca,'YColor',colorfont)  
    




fig = gcf;
fig.Color = colorbg;
fig.InvertHardcopy = 'off';
set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

saveas(fig,[analysisParam.figDir filesep 'DA_CountCells-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'svg')
saveas(fig,[analysisParam.figDir filesep 'DA_CountCells-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'fig')

set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'DA_CountCells-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}, '.pdf'],'pdf');



