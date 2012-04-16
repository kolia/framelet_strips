function plot_index = make_plot_2D_ratios(filename,data,model)

n = min(size(model.params,2) , 4) ;
plot_index.filename_base = filename ;
for i=1:n
    for j=i+1:n
        plot_2D_ratio(data.data*model.params(:,[i j]),data.reference_data*model.params(:,[i j])) ;
        this_filename = sprintf('%s_%d-%d',filename,i,j) ;
        saveas(gcf,this_filename)
        plot_index.plot{i,j}.filename = this_filename ;
        plot_index.plot{i,j}.filename_suffix = sprintf('_%d-%d',filename,i,j) ;
        plot_index.plot{i,j}.filter_i = i ;
        plot_index.plot{i,j}.filter_j = j ;
        close all
    end
end

end