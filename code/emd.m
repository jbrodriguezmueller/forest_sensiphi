function [distance2]=emd(H,D,n)
nbBox=n^3;
nbBox2=nbBox*nbBox;

A=zeros(2*nbBox,nbBox2);
f=zeros(1,nbBox2);

for i=1:nbBox
    for j=1:nbBox
        A(i,j+nbBox*(i-1))=1;
        A(i+nbBox,i+nbBox*(j-1))=1;
        f(1,j+nbBox*(i-1))=D(i,j);
    end
end


b=ones(2*nbBox,1)/nbBox;
for i=1:nbBox
    b(i)=H(i);
end

Aeq=ones(1,nbBox2);

beq=min( norm(H,1),1);

lb=zeros(1,nbBox2); 
ub=[];

[~,distance2] = linprog(f,A,b,Aeq,beq,lb,ub);

end







