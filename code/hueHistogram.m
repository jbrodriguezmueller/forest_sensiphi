function [H, nbHue, hueContrast, missingHue, missingContrast, maxPixel]=hueHistogram(Ihsl,n,C,c)
%[H, nbHue, hueContrast, missingHue, missingContrast,maxPixel]=hueHistogram(Ihsl,n,C,c);
%Constructs of the hue histogram H of the image, counts the number of
%significant hues and missing hues, and calculates their contrasts
%Also returns the percentage of pixels belonging to the most frequent hue

%Construction of the histogram
H=zeros(n,1);
nonConsidered=0;
    
for i=1:size(Ihsl,1)
    for j=1:size(Ihsl,2)
        if ((Ihsl(i,j,2)<=0.2) || (Ihsl(i,j,3)>=0.95 || Ihsl(i,j,3)<=0.15))
            nonConsidered = nonConsidered+1;
        else
            for k=1:n
               if ((Ihsl(i,j,1)>=(k-1)/n) && (Ihsl(i,j,1)<=k/n))
                   H(k)=H(k)+1;
               end 
            end
        end
    end
end

Q=max(H);
nbHue=0;
missingHue=0;
hueContrast=0;
missingContrast=0;

for k=1:n
    if (H(k)>(C*Q))
        nbHue=nbHue+1;
        
        for l=1:n
            if (H(l)>(C*Q))
                %contrast is the distance between the two hue
                %considered,which are on a wheel
                contrast=min(abs((k-l)/n), 1-abs((k-l)/n));
                hueContrast=max(hueContrast,contrast);
            end
        end
    end
    
    if (H(k)<(c*Q))
        missingHue=missingHue+1;
        
        for l=1:n
            if (H(l)<(c*Q))
                %contrast is the distance between the two hue
                %considered,which are on a wheel
                contrast=min(abs((k-l)/n), 1-abs((k-l)/n));
                missingContrast=max(missingContrast,contrast);
            end
        end
    end
    
end

maxPixel=Q/(size(Ihsl,1)*size(Ihsl,2)-nonConsidered);


end