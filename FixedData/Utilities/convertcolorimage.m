function cimg = convertcolorimage(img,colornumber)


if colornumber == 1 %B&W
    cimg = cat(3,img, img, img);
    
elseif colornumber == 2 %CYAN
    cimg = cat(3,zeros(size(img)), img, img);
    
elseif colornumber == 3 %MAGENTA
    cimg = cat(3,img, zeros(size(img)), img); 
    
elseif colornumber == 4 %YELLOW
    cimg = cat(3,img, img, zeros(size(img)));       
    
elseif colornumber == 5 %BLUE
    cimg = cat(3,zeros(size(img)), zeros(size(img)), img );  
    
elseif colornumber == 6 %RED
    cimg = cat(3,img, zeros(size(img)), zeros(size(img)) );    
    
elseif colornumber == 7 %RED
    cimg = cat(3,zeros(size(img)),img , zeros(size(img)) );   
end