function success = save_figure(filename,figure_handles)

if isa(figure_handles,'cell')
    for i=1:length(figure_handles)
        hgsave(figure_handles{i},sprintf('%s_%d',filename,i))
    end
else
    hgsave(figure_handles,filename)
end

close all
success = 1 ;

end