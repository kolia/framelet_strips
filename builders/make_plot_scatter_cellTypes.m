function plot_index = make_plot_scatter_cellTypes(filename , dkls , type , dkl1 , dkl2 , cellTypes , varargin)

kl = gather_cells_runs(dkls , dkl1 , dkl2 ) ;
plot_index.accessors = {dkl1 dkl2} ;

% kl
% kl.values

plot_scatter_cellTypes(kl.values(:,:,1) , kl.values(:,:,2) , cellTypes , type) ;

for i=1:length(varargin)
    feval(varargin{i}{2},varargin{i}{1}) ;
end

prepare_plot_pdf(filename)

saveas(gcf,filename)
plot_index.plot{1,1}.filename = filename ;
close all
end