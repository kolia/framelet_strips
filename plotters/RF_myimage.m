function h = RF_myimage(spatial_domain,MAT)

if iscell(MAT)
    MAT  = MAT{1} ;
end

h = myimage(spatial_domain*0.022,[1 512],MAT) ;
    colorbar('FontSize',34,'location','East') ;
ah = gca ;
set(ah,'FontSize',34)
    xlabel('space (mm)','FontSize',38)
    ylabel('time (ms)','FontSize',38)