function [M]=laplacianMean(foldername)
% [M]=laplacianMean(foldername)
% Gives the mean across all the 100x100 normalized Laplacian images of the pictures in this folder
%
% /!\ the for loop starts at 3 (should be 4 for mac) because list(1).name='.' and list(2).name='..' 

list=dir(foldername);

% /!\ the for loop starts at 3 (should be 4 for mac) because list(1).name='.' and list(2).name='..' 

M=zeros(100,100);

for image=3:size(list)
    string=strcat(foldername,'/',list(image).name);

    Irgb=imread(string);
    Irgb=im2double(Irgb);
    
    Ir=Irgb(:,:,1);
    Ig=Irgb(:,:,2);
    Ib=Irgb(:,:,3);
    
    [laplacian_img]=laplacianImage(Ir,Ig,Ib);
    
    M=M+laplacian_img;
end

size(list,1)
M=M/(size(list,1)-2);
    
