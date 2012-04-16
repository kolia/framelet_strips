function plot_index = make_plot_1D_ratios(filename,data,model,dkls)

close all
n = min(5 , size(model.params,2)) ;
for i=1:n
    d = data.data*model.params(:,i) ;
    r = data.reference_data*model.params(:,i) ;
    
%     plot_hist_ratio(d,r) ;
%     saveas(gcf,sprintf('%s_hist_%d',filename,i))
%     close all

    plot_kde_ratio(d,r, @(x)exp(model.log_ratio(model,x(:),i))) ;
    this_filename = sprintf('%s_kde_%d',filename,i) ;

    if i == 1
        s = 'STA' ;
    else
        s = sprintf('COV filter %d',i-1) ;
    end
    
    title(sprintf('%s         %.2f bits',s,dkls.dkl{i}),'FontSize',34)
    
    prepare_plot_pdf(this_filename)
    saveas(gcf,this_filename)
    
    plot_index.plot{i,1}.filename = this_filename ;
    plot_index.plot{i,1}.filename_suffix = sprintf('_%d',i) ;
    plot_index.plot{i,1}.filter_i = i ;
    close all
end

end