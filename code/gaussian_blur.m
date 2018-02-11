function [blur]=gaussian_blur(Ir,Ig,Ib)
% [blur]=gaussian_blur(Ir,Ig,Ib)
% using theta=0.45
% blur is in [-1; 0], -1 being completely blurred, and 0 a very sharp image

I_blurred=(Ir+Ig+Ib)/3;

M=size(I_blurred,1);
N=size(I_blurred,2);

Y=fft2(I_blurred)/sqrt(M*N);

theta=0.45;

abs_Y=abs(Y);

[row,column]=find(abs_Y>theta);

select_row=row<M/2;
select_column=column<N/2;
m=max(row.*select_row);
n=max(column.*select_column);

blur=max(2*(m-floor(M/2))/M,2*(n-floor(N/2))/N);

end