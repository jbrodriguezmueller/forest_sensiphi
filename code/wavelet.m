function [cA,cH,cV,cD]=wavelet(I)
% [cA,cH,cV,cD]=wavelet(I)
% Performs a three-level Haar wavelet transform on I, and returns the cells
% cA, cH, cV and cD where forall i in {1,2,3}, cA{i} is the i-th level approximation
% coefficients matrix, and cH{i}, cV{i} and cD{i} are the i-th level
% details coefficients matrices

cA=cell(1,3);
cH=cell(1,3);
cV=cell(1,3);
cD=cell(1,3);

%Performing 3 level Daubechies tranform on I
startImage = I;
for i = 1:3,
  [cA{i},cH{i},cV{i},cD{i}] = dwt2(startImage,'haar');
  startImage = cA{i};
end

end