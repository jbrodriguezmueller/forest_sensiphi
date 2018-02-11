function [ a ] = edgeSum( Ir,Ig,Ib)
%[ a ] = edgeSum( Ir,Ig,Ib)
% x=sum(sum(edge(Ir)))/(size(Ir,1)*size(Ir,2));
% y=sum(sum(edge(Ig)))/(size(Ig,1)*size(Ig,2));
% z=sum(sum(edge(Ib)))/(size(Ib,1)*size(Ib,2));
% 
% a=((x+y+z)/3);

x=sum(sum(edge(Ir)))/(size(Ir,1)*size(Ir,2));
y=sum(sum(edge(Ig)))/(size(Ig,1)*size(Ig,2));
z=sum(sum(edge(Ib)))/(size(Ib,1)*size(Ib,2));

a=((x+y+z)/3);
end

