% Load an image
rgbX = imread('lena.tif') ;
original_x = mean(rgbX,3) ;

% Full size image is large: slow demo... limit size for speed
% original_x = original_x(1:128,1:128) ;
[N,M] = size(original_x) ;

% Add some noise
x = original_x + 30*randn(N,M) ;

% Its wavelet transform
w = dd_dwt(x) ;

% place wavelet coeffs into a vector
v = flatten_cells(w) ;

% mapping key between v and w
IJS = flattened_cell_inds( w ) ;  % dd_dwt(zeros(N,M)) would also work instead of w

% Throw out 10% of coefficients
throw_inds = rand(length(v),1) ;
throw_inds(throw_inds>0.9) = 1 ;
throw_inds(throw_inds<0.9) = 0 ;

v(throw_inds == 1) = 0 ;

% Reconstruct image
x_reconst = ddwt_components( IJS(throw_inds == 0,:) , v , [N M]) ;
x_reconst = x_reconst{1} ;

% Plot images
subplot(2,2,1)
imagesc(original_x)
title('Original image')

subplot(2,2,2)
imagesc(x)
title('Noisy image')

subplot(2,2,3)
imagesc(x_reconst)
title('Wavelet projected')

subplot(2,2,4)
imagesc(x - x_reconst)
title('Difference')