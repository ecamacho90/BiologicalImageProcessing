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

fileIn = dir(['Background_Exp31_120200814_31639 PM.tif'])
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

