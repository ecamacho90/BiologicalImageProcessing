function NNeig = assignnumberneighbours3(X,Y,Z,distance)

% X, Y, Z are nx1 vectors with the x,y and z coordinates of the points,
% respectively
% Distance is the size of the ball around the points in which we will count
% the number of neighbours
   
IdX = rangesearch([X,Y,Z],[X,Y,Z],distance);

NNeig = cellfun(@length,IdX,'uni',true);
    