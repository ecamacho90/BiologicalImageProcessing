function [ sigmaz ] = QuotientError( x,y,sigmax,sigmay )
%QuotientError determines the error of x divided by y when sigmax is the
%standard deviation of x and sigmay is the standard deviation of y
%   
sigmaz = x./y .* sqrt(((sigmax./x).^2)+((sigmay./y).^2));



end

