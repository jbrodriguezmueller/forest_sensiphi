function [normalizedDistance]=hueModel(Ih, Is, alpha, k)
% [normalizedDistance]=hueModel(Ih, Is, alpha, k)
% /!\ Ih, Is must be defined and their value must be in [0,1]
% /!\ k must be defined in {1;...;9}
%
% Measure how much the image fits in the k-th hue model, rotated with an
% angle of alpha in [0,360]


colorModel=[180     180     180     180     180;
            90      180     270     270     270;
            30      65      145     145     145;
            80      115     145     145     145;
            90      210     240     240     240;
            90      90      90      90      90;
            30      120     150     240     270;
            30      180     210     210     210;
            30      30      30      30      30];
        
IH=mod(Ih*360+alpha,360);

distance=0;
IS=0;


for i=1:size(Ih,1)
    for j=1:size(Ih,2)
        if ( IH(i,j)<= colorModel(k,1) )
            nearestBorder=IH(i,j);
        elseif (IH(i,j)>colorModel(k,1))&&(IH(i,j)<colorModel(k,2))
            if IH(i,j)-colorModel(k,1)<=colorModel(k,2)-IH(i,j)
                nearestBorder=colorModel(k,1);
            else
                nearestBorder=colorModel(k,2);
            end
        elseif (IH(i,j)>=colorModel(k,2))&&(IH(i,j)<=colorModel(k,3))
            nearestBorder=IH(i,j);
        elseif (IH(i,j)>colorModel(k,3))&&(IH(i,j)<colorModel(k,4))
            if IH(i,j)-colorModel(k,3)<=colorModel(k,4)-IH(i,j)
                nearestBorder=colorModel(k,3);
            else
                nearestBorder=colorModel(k,4);
            end
        elseif (IH(i,j)>=colorModel(k,4))&&(IH(i,j)<=colorModel(k,5))
            nearestBorder=IH(i,j);
        elseif (IH(i,j)>colorModel(k,5))
            if IH(i,j)-colorModel(k,5)<=360-IH(i,j)
                nearestBorder=colorModel(k,5);
            else
                nearestBorder=360;
            end
        end
        
        distance = distance + abs( nearestBorder-IH(i,j) )*Is(i,j);
        IS=IS+Is(i,j);
        
    end
end

normalizedDistance=distance/IS;

end
        
        
        
        
        

        
            