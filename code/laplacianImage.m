function [laplacian_img]=laplacianImage(Ir,Ig,Ib)
% [laplacian_img]=laplacianImage(Ir,Ig,Ib)
% Returns the laplacian image of a picture, Ir Ig and Ib being the red,
% green and blue channels of that picture
% This laplacian image size has been resized to 100x100, and the sum of its
% values has been normalized to 1.

h = fspecial('laplacian', 0.2);
IR=abs(imfilter(Ir,h,'replicate'));
IG=abs(imfilter(Ig,h,'replicate'));
IB=abs(imfilter(Ib,h,'replicate'));

edge_img=(IR+IG+IB)/3;

laplacian_img=imresize(edge_img,[100 100]);
laplacian_img=laplacian_img/norm(laplacian_img(:),1);

end