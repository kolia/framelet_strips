function [h,cmap] = myimage(varargin)

% figure
% h = axes() ;

MAT = varargin{end} ;

m = min(min(MAT)) ;
M = max(max(MAT)) ;

cmap = make_colormap(-m/(M-m)) ;
colormap(cmap) ;

if length(varargin) == 1
    h = imagesc(MAT) ;
else
    h = imagesc(varargin{1},varargin{2},MAT) ;
end