function [nucMask,memMask,bgMask] = readIlastikFileNucMemBG(filename,complement)
% mask = readIlastikFile(filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read ilastik h5 file and output binary mask.
% complement will take the complement of the mask. use this if the objects
% are label 1. If bg is label 1, then set complement = 0.

if ~exist('complement','var')
    complement = 0;
end

immask = h5read(filename, '/exported_data');
immask = squeeze(immask);

nucMask = immask == 1;
memMask = immask == 2;
bgMask = immask == 3;


for ii = 1:size(nucMask,3)
    nucMask2(:,:,ii) = nucMask(:,:,ii)';
    memMask2(:,:,ii) = memMask(:,:,ii)';
    bgMask2(:,:,ii) = bgMask(:,:,ii)';
end

nucMask = nucMask2;
memMask = memMask2;
bgMask = bgMask2;

if complement
    nucMask = imcomplement(nucMask);
    memMask = imcomplement(memMask);
    bgMask = imcomplement(bgMask);
end