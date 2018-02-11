function [bounding_area_ratio]=bounding_box(Ir,Ib,Ig)
% [bounding_area_ratio]=bounding_box(Ir,Ib,Ig)
% Considering a picture whose red, green and blue channels are given in Ir,
% Ig and Ib, edgeDistance computes its laplacian image, and returns the
% ratio of the area of the bounding box containing 81% of the edge energy,
% and the area of the photo

h = fspecial('laplacian', 0.2);
IR=abs(imfilter(Ir,h,'replicate'));
IG=abs(imfilter(Ig,h,'replicate'));
IB=abs(imfilter(Ib,h,'replicate'));

edge_img=(IR+IG+IB)/3;

percentage=0.9;
[a1,b1]=find_energy(percentage,sum(edge_img,2),size(edge_img,1));
[a2,b2]=find_energy(percentage,sum(edge_img,1),size(edge_img,2));

bounding_area_ratio=(b1-a1+1)*(b2-a2+1)/(size(edge_img,1)*size(edge_img,2));