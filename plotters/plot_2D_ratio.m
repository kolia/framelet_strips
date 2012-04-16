function h = plot_2D_ratio(data,ref)

xx = ref(:,1) ;
yy = ref(:,2) ;

zz = log(eval_ratio(data,ref)) ;

z1 = eval_ratio(data(:,1),ref(:,1)) ;
z2 = eval_ratio(data(:,2),ref(:,2)) ;
z  = log(z1.*z2) ;

inds = isfinite(z) & abs(z)<5 & isfinite(zz) & abs(zz)<5 ;

XX = xx(inds) ;
YY = yy(inds) ;
zz = zz(inds) ;
z  =  z(inds) ;

close all

% subplot(2,1,1)
hold on
tri = delaunay(XX,YY) ;
trisurf(tri,XX,YY,zz, z-zz) ;
trisurf(tri,XX,YY,z , z-zz) ;
title('log ratios')
hold off

% subplot(2,1,2)
% h = trisurf(tri,XX,YY,z-zz ) ;
% title('log separable - log ratio')


end

function z = eval_ratio(data,ref)

kde_data = kde( data' , 'rot') ;
kde_ref  = kde( ref'  , 'rot') ;

XX = ref ;

z = evaluate(kde_data,XX')./evaluate(kde_ref,XX') ;

end