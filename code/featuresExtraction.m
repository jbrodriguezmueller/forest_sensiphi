function featuresExtraction(myfolder)
% featuresExtraction(folder)
% Calculates all the features for all the images in the folder 'myfolder',
% and saves them in a .mat file called 'features_myfolder', 
% which contains a matrix with the features for all our images 'collected_features', and a matrix 'names' containing the list of names of the pictures analysed.
%
% /!\ We will need to load the Laplacian images Mp and Ms used with the function edgeDistance
% You first have to calculate those images using generate_mean and save
% those two matrices in a file called laplacianMean.mat


%list=ls('myfolder') %just used to print a clear list of the image in the file
list=dir(myfolder)

nb_data=size(list,1)-2;
names=cell(1,nb_data);


% initialization of the features
fprintf('Initialization of the features \n');
h=zeros(nb_data,1);
s=zeros(nb_data,1);
v=zeros(nb_data,1);
s_=zeros(nb_data,1);
l_=zeros(nb_data,1);
hist_distance=zeros(nb_data,1);
emd_distance=zeros(nb_data,1);
freq_hue=zeros(nb_data,1);
dev_color=zeros(nb_data,1);

nbHue=zeros(nb_data,1);
hueContrast=zeros(nb_data,1);
missingHue=zeros(nb_data,1);
missingContrast=zeros(nb_data,1);
maxPixel=zeros(nb_data,1);
hue_count=zeros(nb_data,1);

modelDistance=[];
hue_model=zeros(nb_data,1);

arithmBrightness=zeros(nb_data,1);
logarithBrightness=zeros(nb_data,1);
brightnessContrast=zeros(nb_data,1);
contrast_quality=zeros(nb_data,1);

bounding_area_ratio=zeros(nb_data,1);
edge_quality=zeros(nb_data,1);
bounding_quality=zeros(nb_data,1);

sum_edges=zeros(nb_data,1);
texture_range=zeros(nb_data,1);
texture_deviation=zeros(nb_data,1);

entropy_r=zeros(nb_data,1);
entropy_g=zeros(nb_data,1);
entropy_b=zeros(nb_data,1);

TextureH1=zeros(nb_data,1);
TextureH2=zeros(nb_data,1);
TextureH3=zeros(nb_data,1);
TextureS1=zeros(nb_data,1);
TextureS2=zeros(nb_data,1);
TextureS3=zeros(nb_data,1);
TextureV1=zeros(nb_data,1);
TextureV2=zeros(nb_data,1);
TextureV3=zeros(nb_data,1);
TextureAvgH=zeros(nb_data,1);
TextureAvgS=zeros(nb_data,1);
TextureAvgV=zeros(nb_data,1);
Low_DOFH=zeros(nb_data,1);
Low_DOFS=zeros(nb_data,1);
Low_DOFV=zeros(nb_data,1);

global_blur=zeros(nb_data,1);

h3=zeros(nb_data,1);
s3=zeros(nb_data,1);
v3=zeros(nb_data,1);

focus_hue=zeros(nb_data,1);
focus_saturation=zeros(nb_data,1);
focus_lightness=zeros(nb_data,1);


XY_100_=zeros(nb_data,1);
numb_conncomp=zeros(nb_data,1);
AvgH=[];
AvgS=[];
AvgV=[];
SI_XY_=[];
Centroid=[];
Color_spread=zeros(nb_data,1);
Complem_colors=zeros(nb_data,1);
Convexity=zeros(nb_data,1);
Centroid_x=[];
Centroid_y=[];
Shape_variance=[];
Shape_skewness=[];
Segment_brightness=[];
Hue_contrast=zeros(nb_data,1);
Saturation_contrast=zeros(nb_data,1);
Brightness_contrast=zeros(nb_data,1);
Blur_contrast=zeros(nb_data,1);





%Loading the Laplacian images Mp and Ms used with the function edgeDistance
%You first have to calculate those images using laplacianMean and save
%those two matrices in a file called laplacianMean.mat
fprintf('Loading laplacianMean');
load laplacianMean



% /!\ the for loop starts at 3 (4 for mac)because list(1).name='.' and list(2).name='..' 
fprintf('Feature extraction \n');
for image=3:size(list)
    tic
    i=image-2;
    string=strcat(myfolder,'/',list(image).name)

    names{i}=list(image).name;

    Irgb=imread(string);
    Irgb=im2double(Irgb);
    
    Ir=Irgb(:,:,1);
    Ig=Irgb(:,:,2);
    Ib=Irgb(:,:,3);
    
    Ihsv=rgb2hsv(Irgb);

    Ih=Ihsv(:,:,1);
    Is=Ihsv(:,:,2);
    Iv=Ihsv(:,:,3);
    
    Ihsl=rgb2hsl(Irgb);

    Ih_=Ihsl(:,:,1);
    Is_=Ihsl(:,:,2);
    Il_=Ihsl(:,:,3);


    %average hue, saturation, value (HSV)
    h(i)=mean2(Ih);
    s(i)=mean2(Is);
    v(i)=mean2(Iv);

    %average saturation and lightness (HSL)
    s_(i)=mean2(Is_);
    l_(i)=mean2(Il_);

    %colorfulness
    [hist_distance(i),emd_distance(i)]=rgbCubes(Ir,Ig,Ib);

    %most frequent hue and standard deviation of colorfulness
    Ihb=findReplace(Ih,Ihsl);
    idx=Ihb>0;
    freq_hue(i)=mode(mode(Ihb(idx)));
    dev_color(i)=std(var(Ihb));

    %Number of distinct hues present and missing in the image, their
    %contrast and number of pixels that belong to the most frequent hue
    n=20;
    C=0.1;
    c=0.01;
    [~, nbHue(i), hueContrast(i), missingHue(i), missingContrast(i), maxPixel(i)]=hueHistogram(Ihsl,n,C,c);

    %Hue count (re-using hueHistogram with a different color space and C)
    n=20;
    C=0.05;
    c=0.01;
    [~,Hue_count,~,~,~,~]=hueHistogram(Ihsv,n,C,c);
    hue_count(i)=n-Hue_count;


    fprintf('Hue model fitting \n');
    %hue models fitting
    model_threshold=10;
    modelNormalDistance=zeros(9,1);
    for k=1:9
        g=@(alpha)hueModel(Ih_,Is_,alpha,k);
        alpha0=fminbnd(g,0,360);
        [normalizedDistance]=hueModel(Ih_,Is_,alpha0,k);
        modelNormalDistance(k,1)=normalizedDistance;
    end
    modelDistance=[modelDistance;transpose(modelNormalDistance)];
    model=modelNormalDistance.*(modelNormalDistance<model_threshold);
    if sum(model)>0
        hue_model(i)=max(find(model));
    else
        [~,hue_model(i)]=min(modelNormalDistance);
    end
    
    % arithmetic and logarithmic average brightness + brightness contrast
    [arithmBrightness(i),logarithBrightness(i),brightnessContrast(i)]=brightness(Ir,Ig,Ib);
    

    %Contrast quality
    [contrast_quality(i)]=brightnessHistogram(Ir,Ig,Ib);

    fprintf('Getting bounding_area_ratio \n');
    %Edge distribution metric
    [bounding_area_ratio(i)]=bounding_box(Ir,Ib,Ig);

    %spatial distribution of the high frequency edges and area of the bounding box
    [edge_quality(i),bounding_quality(i)]=edgeDistance(Ir,Ig,Ib,Mp,Ms);

    %sum of edges
    sum_edges(i)=edgeSum(Ir,Ig,Ib);
    
    %range of texture
    a=rangefilt(Ihsv);
    texture_range(i)=sum(mean2(a))/3;

    %standard deviation of texture
    b=stdfilt(Ihsv);
    texture_deviation(i)=sum(mean2(b))/3;

    %entropy of the red, green and blue matrices
    entropy_r(i)=entropy(Ir);
    entropy_g(i)=entropy(Ig);
    entropy_b(i)=entropy(Ib);

    
    fprintf('Getting the wavelet related features \n');
    %wavelet related features
    [texture,low_DOF]=waveletTexture(Ihsl);

    TextureH1(i)=texture(1,1);
    TextureH2(i)=texture(2,1);
    TextureH3(i)=texture(3,1);
    TextureS1(i)=texture(1,2);
    TextureS2(i)=texture(2,2);
    TextureS3(i)=texture(3,2);
    TextureV1(i)=texture(1,3);
    TextureV2(i)=texture(2,3);
    TextureV3(i)=texture(3,3);
    TextureAvgH(i)=texture(4,1);
    TextureAvgS(i)=texture(4,2);
    TextureAvgV(i)=texture(4,3);
    
    Low_DOFH(i)=low_DOF(1);
    Low_DOFS(i)=low_DOF(2);
    Low_DOFV(i)=low_DOF(3);
    

    fprintf('Getting the blur feature \n');
    %blur measure
    [global_blur(i)]=gaussian_blur(Ir,Ig,Ib);


    %averages from rule of thirds
    margin=0;
    h3(i)=thirdsAvg(Ih,margin);
    s3(i)=thirdsAvg(Is,margin);
    v3(i)=thirdsAvg(Iv,margin);

    %Average hue, saturation and lightness of the focus region
    margin=0.1;
    focus_hue(i)=thirdsAvg(Ih_,margin);
    focus_saturation(i)=thirdsAvg(Is_,margin);
    focus_lightness(i)=thirdsAvg((Ir+Ig+Ib)/3,margin);

    
    fprintf('Getting all the segmentation related features \n');
    %all the region composition features (ie the segmentation related
    %features)
    k=2;
    m=1;
    [nb_cc,avgH,avgS,avgV,XY_100,SI_XY,centroid,color_spread,complem_colors,convexity,centroid_x,centroid_y,shape_variance,shape_skewness,lightness,hue_contrast,saturation_contrast,brightness_contrast,blur_contrast]=seg1(Irgb,k,m);
    XY_100_(i)=XY_100;
    numb_conncomp(i)=nb_cc;
    AvgH=[AvgH; transpose(avgH)];
    AvgS=[AvgS; transpose(avgS)];
    AvgV=[AvgV; transpose(avgV)];
    SI_XY_=[SI_XY_; transpose(SI_XY)];
    Color_spread(i)=color_spread;
    Complem_colors(i)=complem_colors;
    Centroid=[Centroid; transpose(centroid)];
    Convexity(i)=convexity;
    Centroid_x=[Centroid_x; transpose(centroid_x)];
    Centroid_y=[Centroid_y; transpose(centroid_y)];
    Shape_variance=[Shape_variance; transpose(shape_variance)];
    Shape_skewness=[Shape_skewness; transpose(shape_skewness)];
    Segment_brightness=[Segment_brightness; transpose(lightness)];
    Hue_contrast(i)=hue_contrast;
    Saturation_contrast(i)=saturation_contrast;
    Brightness_contrast(i)=brightness_contrast;
    Blur_contrast(i)=blur_contrast;

    toc
end

collected_features=[h s v s_ l_ hist_distance emd_distance freq_hue dev_color nbHue missingHue hueContrast missingContrast maxPixel hue_count modelDistance hue_model arithmBrightness logarithBrightness brightnessContrast contrast_quality bounding_area_ratio bounding_quality edge_quality sum_edges texture_range texture_deviation entropy_r entropy_g entropy_b TextureH1 TextureH2 TextureH3 TextureS1 TextureS2 TextureS3 TextureV1 TextureV2 TextureV3 TextureAvgH TextureAvgS TextureAvgV global_blur h3 s3 v3 focus_hue focus_saturation focus_lightness numb_conncomp XY_100_ SI_XY_ Centroid AvgH AvgS AvgV Segment_brightness Color_spread Complem_colors Centroid_x Centroid_y Shape_variance Shape_skewness Convexity Hue_contrast Saturation_contrast Brightness_contrast Blur_contrast Low_DOFH Low_DOFS Low_DOFV];

save(strcat('features_','Carysfort'),'collected_features','names');