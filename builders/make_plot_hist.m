function plot_index = make_plot_hist( filename , data , accessor , varargin )

close all

data_array = gather_cells_runs( data , accessor ) ;
plot_index.accessors = {accessor} ;

figure('Position',[1 500 600 500])

hist( data_array.values(abs(data_array.values)>0) )
set(gca,'FontSize',28)

for i=1:length(varargin)
    feval( varargin{i}{2} , varargin{i}{1} ) ;
end

prepare_plot_pdf( filename )
saveas( gcf , filename )

plot_index.plot{1}.filename = filename ;

end