function [ singleCells ] = allPeaks2singleCells( allPeaks )
%allPeaks2singleCells reformats allPeaks so that it is position agnostic
%   TO DO: dims of singleCells should be based on size of allPeaks, and not analysisParam.
%          better to use cellfun instead of the loop as written
global analysisParam;

if  analysisParam.isAndorMovie    
for iCon = 1:analysisParam.nCon;
    %for each position
    for iPos = 1:analysisParam.nPosPerCon;
        
        %for each timepoint
        for iTime = 1:length(allPeaks{iCon,iPos})
            if iPos == 1;
            singleCells{iCon}{iTime}=allPeaks{iCon,iPos}{iTime};
            else
                singleCells{iCon}{iTime}=[singleCells{iCon}{iTime};allPeaks{iCon,iPos}{iTime}];
            end
        end
    end
end
end

if analysisParam.isFixedCells
   for iCon = 1:analysisParam.nCon;
    %for each position
    for iPos = 1:analysisParam.nPosPerCon;
              
            if iPos == 1;
            singleCells{iCon}=allPeaks{iCon,iPos};
            else
            singleCells{iCon}=[singleCells{iCon};allPeaks{iCon,iPos}];
            end
        end
    end
end 
singleCells = singleCells';
end

