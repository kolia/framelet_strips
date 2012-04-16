function plot_index = make_plot_bar( filename , data , accessor , cell_types , varargin )

close all

data_array = gather_cells_runs( data , accessor ) ;
plot_index.accessors = {accessor} ;

figure('Position',[1 500 600 500])

% data_array.values = data_array.values(abs(data_array.values)>0) ;

types = fieldnames(cell_types) ;
[N,bins] = hist(data_array.values) ;
typedN = zeros(length(N),length(types)) ;
colors = cell(length(types),1) ;
for i=1:length(types)
    size(data_array.values)
    cell_types.(types{i}).cells
    d = data_array.values( cell_types.(types{i}).cells , : , : ) ;
    d = d(d>0) ;
    NN = hist( d(:) , bins) ;
    typedN(:,i) = NN(:) ;
    colors{i} = cell_types.(types{i}).color ;
end

bar( bins , typedN , colors , 'stack')
set(gca,'FontSize',28)
legend({'biphasic off' ; 'monophasic off' ; 'medium off'},'FontSize',20)

for i=1:length(varargin)
    feval( varargin{i}{2} , varargin{i}{1} ) ;
end

prepare_plot_pdf( filename )
saveas( gcf , filename )

plot_index.plot{1}.filename = filename ;

end