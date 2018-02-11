function [a,b]=find_energy(percentage,vector,n)
%finds the indice a and b, where b-a is the smallest distance with still
%sum_{k=a}^{b}vector(k)>0.9*sum_{k=1}^{size(vector)}vector(k)

%/!\ n is the size of vector
if percentage>1 || percentage<0
    error('percentage must be in [0,1]');
end

total=norm(vector,1);
inverse_percent=(1-percentage)*total;

left_limit=0;
content=0;
while content<inverse_percent
	left_limit=left_limit+1;
    content=content+vector(left_limit);
end
right_limit=0;
content=0;
while content<inverse_percent
    content=content+vector(n-right_limit);
    right_limit=right_limit+1;
end


a=1;
b=n;
percent=percentage*total;
for i=1:left_limit
    for j=0:right_limit-1
        s=0;
        for k=i:n-j
            s=s+vector(k);
        end
        
        if (s>=percent)&&(n-j-i<b-a)
            a=i;
            b=n-j;
        end
    end
end