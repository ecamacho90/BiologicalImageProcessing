function NNeig = assignnumberneighbours2(X,Y,distance)

% X, Y, Z are nx1 vectors with the x,y and z coordinates of the points,
% respectively
% Distance is the size of the ball around the points in which we will count
% the number of neighbours
   
IdX = rangesearch([X,Y],[X,Y],distance);

NNeig = cellfun(@length,IdX,'uni',true);
    