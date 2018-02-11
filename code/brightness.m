function [ arithmBrightness,logarithmBrightness, brightnessContrast ] = brightness( Ir,Ig,Ib )
%[ arithmBrightness,logarithmBrightness, brightnessContrast ] = brightness( Ir,Ig,Ib )
% Calculates the average arithmetic brightness, the average logarithmic
% brightness, and a brightness contrast using a 100 bins histogram
% note: need Ir,Ig,Ib to have values in [0;1]


%arithmetic average brightness
M=(Ir+Ig+Ib)/3;
arithmBrightness=mean2(M);


%logarithmic average brightness + brightness histogram
sum=0;
epsilon=0.001;

B=zeros(100,1);
N=100*M;
for m=1:size(Ir,1)
    for n=1:size(Ir,2)
        sum = sum + log(epsilon + M(m,n));
        
        if (N(m,n)~=100)
            B(floor(N(m,n))+1)=B(floor(N(m,n))+1)+1;
        else
            B(100)=B(100)+1;
        end
    end
end

logarithmBrightness=exp(sum/(size(Ir,1)*size(Ir,2)));

[C,I]=max(B);

area=C;
a=I;
b=I;
nbPixel=size(Ir,1)*size(Ir,2);

while (area/nbPixel)<0.98
    if a>1
        a=a-1;
        area=area+B(a);
    end
    if b<100
        b=b+1;
        area=area+B(b);
    end
end

brightnessContrast=b-a+1;

end

