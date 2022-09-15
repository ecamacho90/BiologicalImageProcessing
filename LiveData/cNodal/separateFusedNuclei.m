function [newNuclearMask, fusedMask] = separateFusedNuclei(nuclearMask, options) 
    % separate fused nuclei in a binary image
    %
    % [newNuclearMask, fusedMask] = separateFusedNuclei(nuclearMask, options) 
    %
    % uses erosion of fused nuclei as seeds for seeded watershed within the
    % original mask
    %
    % nuclearMask:       input binary mask of nuclei
    % options:          structure with fields
    % -minAreaStd:      only objects with A > mean(A) + minAreaStd*std(A)
    %                   can be considered fused (default 1)
    % -minSolidity:     only objects with solidity less than this can be
    %                   considered fused (default off, 0.95 is good value)
    %                   NOTE: this part is computationally expensive
    %                   set value <= 0 to turn off and speed up
    % -erodeSize        in pixels
    %
    % newNucleiMask:    mask with separated nuclei
    % fusedMask:        mask containing potentially fused nuclei

    
    % ---------------------
    % Idse Heemskerk, 2016
    % ---------------------
    
    if ~exist('options','var')
        options = struct();
    end
    if ~isfield(options,'minSolidity')
        minSolidity = 0;
    else
        minSolidity = options.minSolidity;
    end
    if ~isfield(options,'minAreaStd')
        minAreaStd = 1;
    else
        minAreaStd = options.minAreaStd;
    end
    
    CC = bwconncomp(nuclearMask);
    if minSolidity > 0
        stats = regionprops(CC, 'ConvexArea', 'Area');
        convexArea = [stats.ConvexArea];
    else
        stats = regionprops(CC, 'Area');
    end
    area = [stats.Area];
    
    if ~isfield(options,'erodeSize')
        erodeSize = round(sqrt(mean(area))/pi);
    else
        erodeSize = options.erodeSize;
    end
    
    if minSolidity > 0
        fusedCandidates = area./convexArea < minSolidity & area > mean(area) + minAreaStd*std(area);
    else
        fusedCandidates = area > mean(area) + minAreaStd*std(area);
    end
    sublist = CC.PixelIdxList(fusedCandidates);
    sublist = cat(1,sublist{:});

    fusedMask = false(size(nuclearMask));
    fusedMask(sublist) = 1;

%     figure,
%     imshow(cat(3,nuclearMask,fusedMask,0*fusedMask))

    nucmin = imerode(fusedMask,strel('disk',erodeSize));

%     figure,
%     imshow(cat(3,mat2gray(nuclearMask),fusedMask,nucmin))
    
    % dilation by 1 pixel because otherwise the distance on the edge is
    % zero so the mask is shrunk by 1 pixel
    outside = ~imdilate(fusedMask,strel('disk',1));
    basin = imcomplement(bwdist(outside));
    basin = imimposemin(basin, nucmin | outside);

    L = watershed(basin);
    newNuclearMask = nuclearMask & L > 1 | nuclearMask - fusedMask;
    
    newNuclearMask = bwareaopen(newNuclearMask, round(0.2*mean(area)));
end