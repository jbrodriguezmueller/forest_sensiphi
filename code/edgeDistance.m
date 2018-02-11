function [edge_quality,bounding_quality]=edgeDistance(Ir,Ig,Ib,Mp,Ms)
% [edge_quality,bounding_quality]=edgeDistance(Ir,Ig,Ib,Mp,Ms)
%
% Considering a picture whose red, green and blue channels are given in Ir,
% Ig and Ib, edgeDistance computes its normalized 100x100 laplacian image,
% and compares it to Mp and Ms. 
% Mp and Ms have to be to be two normalized 100x100 laplacian images also
% (they are supposed to be the mean Laplacian image of the good (resp. bad)
% photos). They can be constructed using the function laplacianMean.
% edge_quality=ds-dp , where ds (resp dp) is the distance between this
% laplacian image and Ms (resp Mp)
%
% bounding_quality is 1-the area of the bounding box containing 96.04% of
% the edge energy

%Mp and Ms are the mean Laplacian image of the good and bad photos, respectively
[laplacian_img]=laplacianImage(Ir,Ig,Ib);

DP=laplacian_img-Mp;
DS=laplacian_img-Ms;
dp=norm(DP(:),1);
ds=norm(DS(:),1);

edge_quality=ds-dp;

percentage=0.98;
[a1,b1]=find_energy(percentage,sum(laplacian_img,2),size(laplacian_img,1));
[a2,b2]=find_energy(percentage,sum(laplacian_img,1),size(laplacian_img,2));

bounding_quality=1-(b1-a1+1)*(b2-a2+1)/10000;
