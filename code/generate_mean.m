% construction of 2 reference matrices
clear 

fprintf('Construction of Mp and Ms');
[Mp]=laplacianMean('PQs/good_images');
[Ms]=laplacianMean('PQs/bad_images');

save laplacianMean
