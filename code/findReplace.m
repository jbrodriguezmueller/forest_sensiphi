function [ Ih ] = findReplace( Ih, Ihsl )
%[ Ih ] = findReplace( Ih, Ihsl )
%Returns the matrix Ih, where all the pixels with a saturation lower than
%0.2 or a lightness out of ]0.15,0.95[ have been set to 0.
% if Ihsl(i,j,2)<=0.2 || (Ihsl(i,j,3)>=0.95 || Ihsl(i,j,3)<=0.15)
%     Ih(i,j)=0;
% end


for i=1:size(Ih,1)
    for j=1:size(Ih,2)
        if Ihsl(i,j,2)<=0.2 || (Ihsl(i,j,3)>=0.95 || Ihsl(i,j,3)<=0.15)
            Ih(i,j)=0;
        end
    end
end

end

