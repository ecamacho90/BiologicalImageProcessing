function DA_HeatScatter_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,varargin)


global analysisParam;

if ( length(varargin) == 1 )
    varargin = varargin{:};
end

raworclean = 0;
blackBG = 0;
stdmean = 1;
angleticks = 0;
uniformlimits = 1;
distancepoints = 0.05;


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

%% Check conditions contain the same channels

nCon = size(ConditionsSelection,2);
nChan = length(channelnums);

FindChannelsinConditions = zeros(nCon,nChan);

for ii = 1:nChan
    
    channelinterest = channelnums(ii);
    
    for jj = 1:nCon
        
        auxvar = find(channelinterest == analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,jj),ConditionsSelection(2,jj)});
        
        if isempty(auxvar)
            error(['DA_BarPlotsData_FixedData_ConditionsSelection: Selected condition ',num2str(jj),' does not contain data for channel ',analysisParam.MapChannels.DifferentChannelsPresent{channelinterest}]);
        
        else
            FindChannelsinConditions(jj,ii) = auxvar;
            
        end
        
    end
    
end

%%

figure;
set(gcf,'Position',[10 10 1400 800])

x=parula;

nrows=ceil(nCon/5);


    
    
for condnum = 1:nCon


    if nCon<6
        subplot(1,nCon,condnum)

    else
        subplot(nrows,5,condnum)
    end

    DataPlot =AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,2+FindChannelsinConditions(condnum,:));
        
    ndimensions = size(DataPlot,2);

    pointsize=5;

    % figure('Position',[100 100 1700 1700])
    disp('Plotting')

    if ndimensions == 3

        scatter3(DataPlot(:,1),DataPlot(:,2),DataPlot(:,3),pointsize,assignnumberneighbours3(DataPlot(:,1),DataPlot(:,2),DataPlot(:,3),distancepoints),'filled','MarkerEdgeAlpha',1)

        colormap(x(50:end,:))

        xlabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(1)},'Color',colorfont);
        ylabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(2)},'Color',colorfont);
        zlabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(3)},'Color',colorfont);
        
        if uniformlimits
            xlim([limitschannels(1,channelnums(1)),limitschannels(2,channelnums(1))])
            ylim([limitschannels(1,channelnums(2)),limitschannels(2,channelnums(2))])
            zlim([limitschannels(1,channelnums(3)),limitschannels(2,channelnums(3))])
        end
        

        set(gca, 'LineWidth', 2);
        set(gca,'FontWeight', 'bold')
        set(gca,'FontName','Arial')
        set(gca,'FontSize',18)
        set(gca,'Color',colorbg)

        set(gca,'XColor',colorfont)
        set(gca,'YColor',colorfont) 
        set(gca,'ZColor',colorfont)

    else

        scatter(DataPlot(:,1),DataPlot(:,2),pointsize,assignnumberneighbours2(DataPlot(:,1),DataPlot(:,2),distancepoints),'MarkerEdgeAlpha',1)
        xlabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(1)},'Color',colorfont);
        ylabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(2)},'Color',colorfont);
        
        if uniformlimits
            xlim([limitschannels(1,channelnums(1)),limitschannels(2,channelnums(1))])
            ylim([limitschannels(1,channelnums(2)),limitschannels(2,channelnums(2))])
        end
        
        grid on

       set(gca, 'LineWidth', 2);
        set(gca,'FontWeight', 'bold')
        set(gca,'FontName','Arial')
        set(gca,'FontSize',18)
        set(gca,'Color',colorbg)

        set(gca,'XColor',colorfont)
        set(gca,'YColor',colorfont) 


    end

        title(analysisParam.NamesConditions{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)},'Color',colorfont)
end

fig = gcf;
fig.Color = colorbg;
fig.InvertHardcopy = 'off';
set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

saveas(fig,[analysisParam.figDir filesep 'DA_HeatScatter-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'svg')
saveas(fig,[analysisParam.figDir filesep 'DA_HeatScatter-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'fig')
saveas(fig,[analysisParam.figDir filesep 'DA_HeatScatter-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'png')

set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'DA_HeatScatter-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}, '.pdf'],'pdf');


    
    
