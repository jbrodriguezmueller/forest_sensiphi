function [texture,low_DOF]=waveletTexture(Ihsv)
% [texture,low_DOF]=waveletTexture(Ihsv)
% Returns the 4x3 matrix 'texture' containing 12 wavelet features to
% analyse the texture of the image (cf paper1), and a 3x1 matrix 'low_DOF'
% containing a measure of the low depth of field of the image.
%
% In 'texture': lines 1,2,3,4 correspond to the 1st, 2nd and 3rd level and
% to the sum of the average wavelet coefficients of the column, and  columns 1,2,3  to h,s,v 
% In 'low_DOF': the 1st row contains the low DOF feature for H, the 2nd row the one for S, and the 3rd row the one for V

X_4=floor(size(Ihsv,1)/(8*4));
X3_4=floor(3*size(Ihsv,1)/(8*4));
Y_4=floor(size(Ihsv,2)/(8*4));
Y3_4=floor(3*size(Ihsv,2)/(8*4));

%applies a 3-level wavelet transform
[cA,cH,cV,cD]=wavelet(Ihsv);

%The matrix containing the results (lines 1,2,3,4 correspond to the 1st, 2nd and 3rd level and to the sum of the average wavelet coefficients of the column, columns 1,2,3  to h,s,v)
texture=zeros(4,3);
low_DOF=zeros(3,1); %1st row for H, 2nd for S, 3rd for V
sH=zeros(3,1);
sS=zeros(3,1);
sV=zeros(3,1);

%construction of the k-level features
for k = 1:3
    sumH=cH{k}(:,:,1) + cV{k}(:,:,1) + cD{k}(:,:,1);
    sumS=cH{k}(:,:,2) + cV{k}(:,:,2) + cD{k}(:,:,2);
    sumV=cH{k}(:,:,3) + cV{k}(:,:,3) + cD{k}(:,:,3);
    
    %L1 norm
    absH=abs(cH{k}(:,:,1)) + abs(cV{k}(:,:,1)) + abs(cD{k}(:,:,1));
    absS=abs(cH{k}(:,:,2)) + abs(cV{k}(:,:,2)) + abs(cD{k}(:,:,2));
    absV=abs(cH{k}(:,:,3)) + abs(cV{k}(:,:,3)) + abs(cD{k}(:,:,3));
    sH(k,1)=norm(absH(:),1);
    sS(k,1)=norm(absS(:),1);
    sV(k,1)=norm(absV(:),1);

    for i = 1:floor(size(Ihsv,1)/(2^k))
        for j = 1:floor(size(Ihsv,2)/(2^k))
            texture(k,1)=texture(k,1) + sumH(i,j);
            texture(k,2)=texture(k,2) + sumS(i,j);
            texture(k,3)=texture(k,3) + sumV(i,j);
            
            if ((k==3)&&(((i>X_4)&&(i<X3_4))&&((j>Y_4)&&(j<Y3_4))))
                low_DOF(1)=low_DOF(1)+ sumH(i,j);
                low_DOF(2)=low_DOF(2)+ sumS(i,j);
                low_DOF(3)=low_DOF(3)+ sumV(i,j);
            end
            
        end
    end
    
    if k==3
        low_DOF(1)=low_DOF(1)/texture(k,1);
        low_DOF(2)=low_DOF(2)/texture(k,2);
        low_DOF(3)=low_DOF(3)/texture(k,3);
    end
    
    texture(k,1)=texture(k,1)/sH(k,1);
    texture(k,2)=texture(k,2)/sS(k,1);
    texture(k,3)=texture(k,3)/sV(k,1);
end

texture(4,1)=texture(1,1)+texture(2,1)+texture(3,1);
texture(4,2)=texture(1,2)+texture(2,2)+texture(3,2);
texture(4,3)=texture(1,3)+texture(2,3)+texture(3,3);


end