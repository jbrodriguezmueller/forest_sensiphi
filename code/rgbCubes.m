function [ hist_distance, emd_distance ] = rgbCubes( Ir, Ig, Ib )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n=4;
limit=n+1;
n2=n*n;
nbBox=n^3;

IR=n*Ir+1;
IG=n*Ig+1;
IB=n*Ib+1;

distribution=zeros(n,n,n);

for i=1:size(Ir,1)
    for j=1:size(Ir,2)
        if IR(i,j)==limit
            IR(i,j)=n;
        end
        if IG(i,j)==limit
            IG(i,j)=n;
        end
        if IB(i,j)==limit
            IB(i,j)=n;
        end
        
        distribution(floor(IR(i,j)),floor(IG(i,j)),floor(IB(i,j)))=distribution(floor(IR(i,j)),floor(IG(i,j)),floor(IB(i,j)))+1;
    end
end

H=zeros(nbBox,1);
Y=ones(nbBox,1)/nbBox;
A=zeros(nbBox,nbBox);
D2=zeros(nbBox,nbBox);
max_=0;

for i=1:n
    for j=1:n
        for k=1:n
            H(k+n*(j-1)+n2*(i-1))=distribution(i,j,k);
            
            for i2=1:n
                for j2=1:n
                    for k2=1:n
                        c1=[0.5+(i-1);  0.5+(j-1);  0.5+(k-1)]/n;
                        c2=[0.5+(i2-1); 0.5+(j2-1); 0.5+(k2-1)]/n;
                        C1=rgb2luv(c1);
                        C2=rgb2luv(c2);
                        A(k+n*(j-1)+n2*(i-1),k2+n*(j2-1)+n2*(i2-1))=norm(c1-c2,2);
                        D2(k+n*(j-1)+n2*(i-1),k2+n*(j2-1)+n2*(i2-1))=norm(C1-C2,2);
                        max_=max(max_,norm(c1-c2,2));
                    end
                end
            end
        end
    end
end

H=H/(size(Ir,1)*size(Ir,2));

A=1-A/max_;

hist_distance=sqrt( transpose(H-Y)*A*(H-Y) );

emd_distance=emd(H,D2,n);

end

