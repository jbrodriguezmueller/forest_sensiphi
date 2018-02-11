function [IH]=context(Ih,m)
% [IH]=context(Ih,m)
% Performs a uniform blur on Ih, but independantly of its size, with
% ones(m) as a kernel matrix
% Ih must be a 2D image, m an integer >0

    if m>1
        if size(Ih,1)>size(Ih,2)
            m1=floor(m*size(Ih,1)/3072);
            m2=floor(m*size(Ih,2)/2304);
        else
            m1=floor(m*size(Ih,1)/2304);
            m2=floor(m*size(Ih,2)/3072);
        end

        %sums the i,...,i+m1-1 lines of Ih
        sum_Ih=[zeros(m1-1,size(Ih,2));Ih];
        for i=1:m1-1
            sum_Ih=sum_Ih+[zeros(m1-i-1,size(Ih,2));Ih;zeros(i,size(Ih,2))];
        end
        %sums the i,...,i+m2-1 columns of sum_Ih
        sum_Ih2=[zeros(size(Ih,1)+m1-1,m2-1),sum_Ih];
        for i=1:m2-1
            sum_Ih2=sum_Ih2+[zeros(size(Ih,1)+m1-1,m2-i-1) sum_Ih zeros(size(Ih,1)+m1-1,i)];
        end
        %suppress the additional lines and columns
        for i=1:m1-1
            sum_Ih2(1,:)=[];
            sum_Ih2(size(sum_Ih2,1),:)=[];
        end
        for i=1:m2-1
            sum_Ih2(:,1)=[];
            sum_Ih2(:,size(sum_Ih2,2))=[];
        end
        %we have added the value of m1*m2 pixels, so to have an average, we have to
        %divide it by m1*m2
        IH=sum_Ih2/(m1*m2);
    
    else
        IH=Ih;

    end
end