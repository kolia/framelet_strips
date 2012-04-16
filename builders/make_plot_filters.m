function plot_index = make_plot_filters(filename,framelet_score,model,title_gen,CellNum)

n = min(size(model.params,2) , 5) ;
plot_index = cell(n,1) ;

close all
hs = plot_filters( - model.params(:,1:n) , framelet_score) ;  % INVERTING SIGN !!!

for i=1:n

    if nargin>5
        title( title_gen(CellNum,i) )
    end
    
    if n>1
        this_filename = sprintf('%s_%d',filename,i) ;
    else
        this_filename = filename ;
    end
    saveas(hs{i},this_filename)

    figure(hs{i})
    prepare_plot_pdf(this_filename)
    
    plot_index{i}.filename = this_filename ;
    
end

end