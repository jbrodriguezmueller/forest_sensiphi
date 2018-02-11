function [ a ] = thirdsAvg( M,margin )
% [ a ] = thirdsAvg( M,margin )
% Returns the average 'a' of the central part matrix with respect to rule of thirds
% This central part is defined as the central ninth of the photo if you
% divide it along the 1/3 and the 2/3 of its height and width, with a
% margin of 'margin' percent around it.
%
%/!\margin must be in [0,1]

v=0;

for x=floor((1-margin)*size(M,1)/3):floor((1+margin)*(2*size(M,1))/3)
    for y=floor((1-margin)*size(M,2)/3):floor((1+margin)*(2*size(M,2))/3)
        
        v=v+M(x,y);
        
    end
end

a=v/((floor((1+margin)*(2*size(M,1))/3)-floor((1-margin)*size(M,1)/3))*(floor((1+margin)*(2*size(M,2))/3)-floor((1-margin)*size(M,2)/3)));

end