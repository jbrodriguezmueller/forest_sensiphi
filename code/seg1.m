function [nb_cc,avgH,avgS,avgV,XY_100,SI_XY,centroid,color_spread,complem_colors,convexity,centroid_x,centroid_y,shape_variance,shape_skewness,brightness,hue_contrast,saturation_contrast,brightness_contrast,blur_contrast]=seg1(Irgb,k,m)
% [nb_cc,avgH,avgS,avgV,XY_100,SI_XY,centroid,color_spread,complem_colors,...
% convexity,centroid_x,centroid_y,shape_variance,shape_skewness,brightness,...
% hue_contrast,saturation_contrast,brightness_contrast,blur_contrast]=seg1(Irgb,k,m)   
% 
% Performs a color-based segmentation process on our image in the LUV color
% space, using kmeans and bnconncomp
% Then, returns all the segmentation related features (in matrices)
% 
% Returns an error if the image contains less than 5 'objects'

Ir=Irgb(:,:,1);
Ig=Irgb(:,:,2);
Ib=Irgb(:,:,3);

Ihsv=rgb2hsv(Irgb);
Ih=Ihsv(:,:,1);
Is=Ihsv(:,:,2);
Iv=Ihsv(:,:,3);

Iluv=RGBim2Luv(Irgb);

I(:,:,1)=context(Iluv(:,:,1),m);
I(:,:,2)=context(Iluv(:,:,2),m);
I(:,:,3)=context(Iluv(:,:,3),m);

%we have to reshape Iluv to apply kmeans to it
X=size(I,1);
Y=size(I,2);
XY=X*Y;
iLuv=reshape(I,[XY 3]);

ID=kmeans(iLuv,k);

%we now have an image where each pixel has an indice i in [1,k],
%corresponding to the cluster it is in
cluster=reshape(ID,[X Y]);
imtool(cluster);

%we now want to find patches of connected components
binary_cluster=cell(1,k);
connected_cluster=cell(1,k);
num_pixels=cell(1,k);
k_biggest=zeros(2,k);
nb_cc=0;
for j=1:k
    binary_cluster{j}=cluster<j+1;
    cluster=cluster+k*binary_cluster{j};
    
    connected_cluster{j}=bwconncomp(binary_cluster{j});
    nb_cc=nb_cc+connected_cluster{j}.NumObjects;
    
    num_pixels{j}=cellfun(@numel,connected_cluster{j}.PixelIdxList);
    [k_biggest(1,j),k_biggest(2,j)]=max(num_pixels{j}); %biggest(1,k)=nb of pixel in it, biggest(1,k)= its index number
end

%we want to select the 5-th biggest connected components and
%analyse them
if nb_cc<5
    error('/!\ ERROR: This image analysis produce less than 5 connected components! It means that that we can"t analyse its 5 biggest connected components, and that some results ARE false.');
end

biggest_patches=cell(2,5); %1st row for the number of pixels in the patch, 2nd row for the list of the indices of the pixels in this patch
XY_100=0;
avgH=-1*ones(5,1);
avgS=-1*ones(5,1);
avgV=-1*ones(5,1);
SI_XY=zeros(5,1);
centroid=zeros(5,1);
lightness=zeros(5,1);
num_pixels_=num_pixels; %we need to modifie num_pixels in the loop, but we will also need it later

centroid_x=zeros(3,1);
centroid_y=zeros(3,1);
shape_variance=zeros(3,1);
shape_skewness=zeros(3,1);
brightness=zeros(3,1);

blur_matrix=zeros(size(Ir));
blur=zeros(5,1);

for i=1:5;
    %finds the new biggest patch and puts its information in biggest_patches
    [biggest_patches{1,i},J]=max(k_biggest(1,:)); %J is the index of the cluster this patch is from (in [1,k])
    IDX=k_biggest(2,J); %IDX is its index in connected_cluster{J}.PixelIdxList
    biggest_patches{2,i}=connected_cluster{J}.PixelIdxList{IDX};
    
    %construction of the features linked to the i-th patch
    if biggest_patches{1,i}>XY/100
        XY_100=XY_100+1;
    end
    avgH(i)=mean(Ih(biggest_patches{2,i}));
    avgS(i)=mean(Is(biggest_patches{2,i}));
    avgV(i)=mean(Iv(biggest_patches{2,i}));
    SI_XY(i)=biggest_patches{1,i}/XY;
    avg_x=mean(mod(biggest_patches{2,i}-1,X)+1);
    avg_y=mean(floor((biggest_patches{2,i}-1)/X)+1);
    r=floor(3*avg_x/X)+1;
    c=floor(3*avg_y/Y)+1;
    centroid(i)=10*r+c;
    lightness(i)=mean(Ir(biggest_patches{2,i})+Ig(biggest_patches{2,i})+Ib(biggest_patches{2,i}));
    blur_matrix(biggest_patches{2,i})=(Ir(biggest_patches{2,i})+Ig(biggest_patches{2,i})+Ib(biggest_patches{2,i}))/3;
    blur(i)=gaussian_blur(blur_matrix,blur_matrix,blur_matrix);
    
    
    num_pixels_{J}(IDX)=0;
    [k_biggest(1,J),k_biggest(2,J)]=max(num_pixels_{J});
    
    %those features from paper2 only consider the 3 biggest segments
    if i<4
        centroid_x(i)=avg_x/X;
        centroid_y(i)=avg_y/Y;
        difference_x=((mod(biggest_patches{2,i}-1,X)+1)-avg_x)/X;
        difference_y=((floor((biggest_patches{2,i}-1)/X)+1)-avg_y)/Y;
        for j=1:biggest_patches{1,i}
            shape_variance(i)=shape_variance(i)+difference_x(j)^2+difference_y(j)^2;
            shape_skewness(i)=shape_skewness(i)+difference_x(j)^3+difference_y(j)^3;
        end
        shape_variance(i)=shape_variance(i)/biggest_patches{1,i};
        shape_skewness(i)=shape_skewness(i)/biggest_patches{1,i};
        brightness(i)=lightness(i);
    end
end

%features from paper1
color_spread=0;
complem_colors=0;
%features from paper2
hue_contrast=0;
saturation_contrast=0;
brightness_contrast=0;
blur_contrast=0;
for i=1:5
    for j=1:5
        color_spread=color_spread+abs(avgH(i)-avgH(j));
        complem_colors=complem_colors+min(abs(avgH(i)-avgH(j)),1-abs(avgH(i)-avgH(j)));
        hue_contrast=max(hue_contrast,min(abs(avgH(i)-avgH(j)),1-abs(avgH(i)-avgH(j))));
        saturation_contrast=max(saturation_contrast,abs(avgS(i)-avgS(j)));
        brightness_contrast=max(brightness_contrast,abs(lightness(i)-lightness(j)));
        blur_contrast=max(blur_contrast,abs(blur(i)-blur(j)));
    end
end


%analysis of the convexity of the shapes in the image
convexity=0;
for j=1:k
    %we first need to detect all the shapes which surface is >200/XY
    for i=1:size(num_pixels{j},2)
        if (num_pixels{j}(i))>(XY/200)
            pixel_list=cell2mat(connected_cluster{j}.PixelIdxList(i));
            shape_x=mod(pixel_list-1,X)+1;
            shape_y=floor((pixel_list-1)/X)+1;
            [~,conv_area]=convhull(shape_x,shape_y);
            if (num_pixels{j}(i)/conv_area)>0.8
                convexity=convexity+num_pixels{j}(i);
            end
        end
    end
end
convexity=convexity/XY;


end

