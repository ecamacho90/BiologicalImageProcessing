%% Row Images

pathtodata = 'C:\Users\ssyoo\OneDrive\Desktop\celldensity';
pathtosavedata = 'C:\Users\ssyoo\OneDrive\Desktop\celldensity';
mkdir([pathtosavedata, filesep, 'MaxProj'])

NWells = 6; %wells in the plate
RowNumber = 3;
NWells2 = 5; %wells taken in the file
% Nwells2 = 5 because the 6th well in row 2 was 0.5k and was not pictured
% with the rest of the cells in that row.


NChannels = 4;
NZstacks = 3;
NPositionsperWell = 9;


fileIn = dir([pathtodata filesep 'P1_Row',num2str(RowNumber),'_*.tif'])
fileIn = fileIn.name;
reader = bfGetReader(fileIn);

NChannels = reader.getSizeC;
nT = reader.getSizeT;
NZstacks = reader.getSizeZ;
            
for expnum = 1
    
    for wellnum = (1:NWells2)
        
        disp(['Computing Max Proj images Well number = ',num2str(wellnum),'/',num2str(NWells)])
        
        for imnum = 1:NPositionsperWell
            wellconvert = ((RowNumber-1)*NWells+(1:NWells));
            fileOut = [pathtosavedata filesep 'MaxProj/','P',num2str(expnum),'_W',num2str(wellconvert(wellnum)),'_',num2str(imnum),'_MAXProj.tif'];
            for channelnum = 1:NChannels
                z=1;
                idx = channelnum+(z-1)*NChannels+(imnum-1)*NChannels*NZstacks+(wellnum-1)*NPositionsperWell*NChannels*NZstacks;
                imaux = imread(fileIn,idx);
                maxprojchan = imaux;
                
                for z = 2:NZstacks
                    idx = channelnum+(z-1)*NChannels+(imnum-1)*NChannels*NZstacks+(wellnum-1)*NPositionsperWell*NChannels*NZstacks;
                    imaux = imread(fileIn,idx);
                    
                    maxprojchan = max(maxprojchan,imaux);
                    
                    
                    
                end
                
                if channelnum==1
                imwrite(maxprojchan,fileOut,'Compression','none');
                else
                    imwrite(maxprojchan,fileOut,'writemode','append','Compression','none');
                end
                    
                
            end
        end



    end
end

disp('All Max Projections have been created')

%% Well Images
mkdir('MaxProj')
for expnum = 1
    
    for wellnum = 1:5
        
        for imnum = 1:9

            
            fileIn = dir(['P',num2str(expnum),'_W',num2str(wellnum),'_',num2str(imnum),'_*.tif'])
            fileIn = fileIn.name;
            fileOut = ['MaxProj/','P',num2str(expnum),'_W',num2str(wellnum),'_',num2str(imnum),'_MAXProj.tif'];

            reader = bfGetReader(fileIn);

            nT = reader.getSizeT;
            nC = reader.getSizeC;


                sX = reader.getSizeX;
                sY = reader.getSizeY;
                empty = zeros(sY,sX);


            ii=1;

            jj=1;
            img(:,:) =  bfMaxIntensity(reader,ii,jj);
            imwrite(img,fileOut,'Compression','none');

            for jj = 2:4
            img(:,:) =  bfMaxIntensity(reader,ii,jj);        
            imwrite(img,fileOut,'writemode','append','Compression','none');
            end

        end
    end
end

  %% Background  

fileIn = dir(['Background320210618_61059 PM.tif'])
            fileIn = fileIn.name;
            fileOut = [fileIn(1:16),'_MAXProj.tif'];

            reader = bfGetReader(fileIn);

            nT = reader.getSizeT;
            nC = reader.getSizeC;


                sX = reader.getSizeX;
                sY = reader.getSizeY;
                empty = zeros(sY,sX);


            ii=1;

            jj=1;
            img(:,:) =  bfMaxIntensity(reader,ii,jj);
            imwrite(img,fileOut,'Compression','none');

            for jj = 2:4
            img(:,:) =  bfMaxIntensity(reader,ii,jj);        
            imwrite(img,fileOut,'writemode','append','Compression','none');
            end



  %% Background  

fileIn = dir(['Background_Exp31_120200814_31639 PM.tif'])
            fileIn = fileIn.name;
            fileOut = ['Background','_MAXProj.tif'];

            reader = bfGetReader(fileIn);

            nT = reader.getSizeT;
            nC = reader.getSizeC;


                sX = reader.getSizeX;
                sY = reader.getSizeY;
                empty = zeros(sY,sX);


            ii=1;

            jj=1;
            img(:,:) =  bfMaxIntensity(reader,ii,jj);
            imwrite(img,fileOut,'Compression','none');

            for jj = 2:4
            img(:,:) =  bfMaxIntensity(reader,ii,jj);        
            imwrite(img,fileOut,'writemode','append','Compression','none');
            end

