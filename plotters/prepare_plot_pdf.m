function prepare_plot_pdf(filename)

% load(filename)
sprintf('trying to print to pdf:\n%s\n',filename)
print_pdf(filename)
savefig(filename,'pdf','-r864')
% [pathstr, name] = fileparts(filename) ;
% unix(sprintf('ln -s %s.pdf ~/Desktop/%s.pdf',filename,name)) ;

end