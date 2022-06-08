%% Row Images
clear all

%%
pathtodata = '/Volumes/Elena-2020/220131_bCatFixed_Exp44/P1_220220131_51638 PM_20220131_54348 PM';

allfiles = dir([pathtodata filesep 'P*.tif']);

PlateNumber = 1;
nwellsperrow = 6;
nposperwell = 6;

for ii = 1:length(allfiles)
    currentfile = allfiles(ii);
    filename = currentfile.name
    
    iistar = str2double(filename((end-7):(end-4)))+1
    
    if iistar<(nwellsperrow*nposperwell+1)
        
%         istar = ii;
        Wellnumber = ceil(iistar/nposperwell);
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
    newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
    pause()
    elseif iistar<(2*nwellsperrow*nposperwell+1)
        
        Wellnumber = ceil(iistar/nposperwell);
        Wellnumber = -1*Wellnumber+19;
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
        newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
        pause()
        
    elseif iistar<(3*nwellsperrow*nposperwell+1)
        
        Wellnumber = ceil(iistar/nposperwell);
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
    newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
    pause()
        
    end
%     currPrefix = strtok(filename,'_');
    
%     platenumber = str2num(filename(2));
%     rownumber = double(filename(4))-'A'+1;
%     wellinrow = str2num(filename(5:6));
%     positionnumber = str2num(filename(13:16));
%     
%     wellnumber = wellinrow+(rownumber-1)*6;
%     
%     newname = ['P',num2str(platenumber),'_W',num2str(wellnumber),'_',num2str(positionnumber),'.tif']
    
    movefile([pathtodata filesep filename], [pathtodata filesep newname])
    
end


%%
pathtodata = '/Volumes/Elena-2020/220211_Sumin_Spring_Exp53_rep2/P2_20220211_114936 AM_20220211_122744 PM';

allfiles = dir([pathtodata filesep 'P*.tif']);

PlateNumber = 2;
nwellsperrow = 6;
nposperwell = 6;

for ii = 1:length(allfiles)
    currentfile = allfiles(ii);
    filename = currentfile.name
    
    iistar = str2double(filename((end-7):(end-4)))+1
    
    if iistar<37
        
%         istar = ii;
        Wellnumber = ceil(iistar/nposperwell);
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
    newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
%     pause()
    elseif iistar<73
        
        Wellnumber = ceil(iistar/nposperwell);
        Wellnumber = -1*Wellnumber+19;
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
        newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
%         pause()
        
    else
        
        Wellnumber = ceil(iistar/nposperwell);
        Imagenumber = rem(iistar,nposperwell);
        
        if Imagenumber == 0 
            Imagenumber =nposperwell;
            
        end
        
    newname = [filename(1:2),'_W',num2str(Wellnumber),'_',num2str(Imagenumber),'.tif']
%     pause()
        
    end
%     currPrefix = strtok(filename,'_');
    
%     platenumber = str2num(filename(2));
%     rownumber = double(filename(4))-'A'+1;
%     wellinrow = str2num(filename(5:6));
%     positionnumber = str2num(filename(13:16));
%     
%     wellnumber = wellinrow+(rownumber-1)*6;
%     
%     newname = ['P',num2str(platenumber),'_W',num2str(wellnumber),'_',num2str(positionnumber),'.tif']
    
    movefile([pathtodata filesep filename], [pathtodata filesep newname])
    
end
