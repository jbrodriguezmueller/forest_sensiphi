function [contrast_quality]=brightnessHistogram(Ir,Ig,Ib)
%[contrast_quality]=brightnessHistogram(Ir,Ig,Ib)
% Returns the width of the smallest region containing 0.98percent of the
% brightness histogram of the image

Ir=255*Ir;
Ig=255*Ig;
Ib=255*Ib;


Hr=zeros(256,1);
Hg=zeros(256,1);
Hb=zeros(256,1);

for i=1:size(Ir,1)
    for j=1:size(Ir,2)
        Hr(1+floor(Ir(i,j)))=Hr(1+floor(Ir(i,j)))+1;
        Hg(1+floor(Ig(i,j)))=Hg(1+floor(Ig(i,j)))+1;
        Hb(1+floor(Ib(i,j)))=Hb(1+floor(Ib(i,j)))+1;
    end
end

H=(Hr+Hg+Hb)/(size(Ir,1)*size(Ir,2));

percentage=0.98;
[a,b]=find_energy(percentage,H,256);

contrast_quality=b-a;

end

