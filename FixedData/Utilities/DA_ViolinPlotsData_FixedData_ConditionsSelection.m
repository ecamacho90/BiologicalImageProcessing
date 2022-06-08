
function DA_ViolinPlotsData_FixedData_ConditionsSelection(ConditionsSelection,titleplottosave,varargin)

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

%% Check conditions contain the same channels
nCon = size(ConditionsSelection,2);
nChan = length(channelnums);
times = 1:nCon;

FindChannelsinConditions = zeros(nCon,nChan);

for ii = 1:nChan
    
    channelinterest = channelnums(ii);
    
    for jj = 1:nCon
        
        auxvar = find(channelinterest == analysisParam.MapChannels.ChannelsCoordMatrix{ConditionsSelection(1,jj),ConditionsSelection(2,jj)});
        
        if isempty(auxvar)
            error(['DA_BarPlotsData_FixedData_ConditionsSelection: Selected condition ',num2str(jj),' does not contain data for channel ',analysisParam.MapChannels.DifferentChannelsPresent{ii}]);
        
        else
            FindChannelsinConditions(jj,ii) = auxvar;
            
        end
        
    end
    
end

%% Violin plot
figure;
set(gcf,'Position',[10 10 1200 1000])
% colourclusters = {colorconvertorRGB([236,28,36]),colorconvertorRGB([249,236,49]),colorconvertorRGB([64,192,198])};
% colourclusters = {'g','r','b'};

if nChan<4
colourclusters = [colorconvertorRGB([64,192,198]);colorconvertorRGB([185,82,159]);colorconvertorRGB([249,236,49])];
colourclusters = colourclusters(ordercolors,:);

else
    
    colourclusters = distinguishable_colors(nChan,{'w','k'});
    colourclusters = colourclusters(ordercolors,:);
    
end
    
disp('Plotting....')
tiledlayout(nChan,1,'TileSpacing','compact')



alinearrelation = 10;
blinearrelation = 5;


for channelnum = 1:nChan

nexttile

celln = 0;
xticksnum = [];
daystickslabels = {};
plotshandle = [];
legendhandle = {};

  meanData = [];
  stdData = [];  
    for condnum = 1:nCon
        
        

        %Set the interval in which the violin will spread
        daytickmin = alinearrelation*(times(condnum)-times(1));
        daytickmax = alinearrelation*(times(condnum)-times(1))+blinearrelation;
        daytick = (2*alinearrelation*(times(condnum)-times(1))+blinearrelation)/2;

        DataPlot =AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,2+FindChannelsinConditions(condnum,channelnum));
        
%         disp('Computing pdf.....')
        % Obtain the distribution of the data
        [pdf,y] = ksdensity(DataPlot);
        
%         disp('Computed!.....')
        
        % Obtain higher accuracy so that the violin looks nicer:
        ymax = max(DataPlot);%max(y);
        ymin = min(DataPlot);%min(y);
        points = linspace(ymin,ymax,1000);
        
%         disp('Evaluating pdf.....')
        %Repeat ksdensity
        [pdf,y] = ksdensity(DataPlot,points);
%         disp('Evaluated!.....')
        
        %Now, for each point in y, we need to find a change of coordinates
        %between [pdfmin,pdfmax] and [daytickmin,daytickmax]
        
        pdfmax = max(pdf);
        pdfmin = min(pdf);
        
        Aright = (daytick-daytickmax)/(pdfmin-pdfmax);
        bright = daytickmax - Aright*pdfmax;
        
        Aleft = (daytick-daytickmin)/(pdfmin-pdfmax);
        bleft = daytickmin - Aleft*pdfmax;
        
        pdfright = Aright*pdf+bright;
        pdfleft = Aleft*pdf+bleft;
        

        
        
        

        plot(pdfright,y,'Color',colourclusters(channelnum,:),'LineWidth',2);
        hold on
        plot(pdfleft,y,'Color',colourclusters(channelnum,:),'LineWidth',2);
        
        if stdmean
            meanDataAux = zeros(1,AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end));
            
            for posnum = 1:AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end)
                
                indposnum = find(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,end)==posnum);
                meanDataAux(posnum) = mean(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(indposnum,2+FindChannelsinConditions(condnum,channelnum)));
            end
            
            meanData = meannonan(meanDataAux);
            stdData = stdnonan(meanDataAux)/sqrt(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(end,end));
            
        else
                    
            meanData = meannonan(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,2+FindChannelsinConditions(condnum,channelnum)));
            stdData = stdnonan(AllDataExperiment{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)}(:,2+FindChannelsinConditions(condnum,channelnum)));
            
        end
        

        errorbar(daytick, meanData,stdData/2,'LineWidth',2,'Color',colourclusters(channelnum,:));

        
        
        % Set appearance of plot:
        xticksnum = [xticksnum, daytick];
        daystickslabels{condnum} = analysisParam.NamesConditions{ConditionsSelection(1,condnum)}{ConditionsSelection(2,condnum)};
        
        
%             legendhandle{daynum} = ['(',num2str(ids(daynum)),') ',mutregimes{daynum},' D',num2str(days{daynum}),' ', CHIRcond, ' ',LGKcond];
%         if daynum >1
%            plot([daytickaux,daytick], [meanaux,mean(DataPlot)],'Color',colors(conditionnum,:),'LineWidth',1.5) 
%         end
        
        
        
        
    end
    
    
%         xlabel('Hours post treatment')
        ylabel(analysisParam.MapChannels.DifferentChannelsPresent{channelnums(channelnum)},'Color',colorfont);

    if uniformlimits
    ylim([limitschannels(1,channelnums(channelnum)),limitschannels(2,channelnums(channelnum))])
    end


    xlim([0,max(xticksnum)+blinearrelation])
    [xticksordered,indicesxticks] = sort(xticksnum);
    xticks(unique(xticksordered))
    if channelnum<nChan
        xticklabels((cell(1,nCon)));
    else
        xticklabels((daystickslabels(1:nCon)));
    end

    
    
    if channelnum==1
    title(Title,'Color',colorfont)
    end
    
    xtickangle(angleticks)
    
    set(gca, 'LineWidth', 2);
    set(gca,'FontWeight', 'bold')
    set(gca,'FontName','Arial')
    set(gca,'FontSize',18)
    set(gca,'Color',colorbg)
    set(gca,'Color',colorbg)
    set(gca,'XColor',colorfont)
    set(gca,'YColor',colorfont)  
    
end



fig = gcf;
fig.Color = colorbg;
fig.InvertHardcopy = 'off';
set(findall(fig,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)


saveas(fig,[analysisParam.figDir filesep 'DA_ViolinPlots-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'svg')
saveas(fig,[analysisParam.figDir filesep 'DA_ViolinPlots-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}],'fig')

set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig,'filename','-dpdf','-r0')

saveas(fig,[analysisParam.figDir filesep 'DA_ViolinPlots-',colorbgplotname,'-AllGenes-DAPINorm-', titleplottosave, '-', raworcleantitle{raworclean+1}, '.pdf'],'pdf');




    
    


