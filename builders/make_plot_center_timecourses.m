function plot_index = make_plot_center_timecourses(filename , all_timecourses , types , ExperimentNum)

hold on
cell_types = fieldnames(types) ;
legends = cell( 1 , length(cell_types) ) ;
h= zeros(length(cell_types),1) ;
for t=1:length(cell_types)             % For each cell type:
    legends{t} = types.(cell_types{t}).legend ;
    if isfield(types.(cell_types{t}),'cells')
        for i=1:length(types.(cell_types{t}).cells)
            c = types.(cell_types{t}).cells(i) ;
            timecourse = zeros(128,1) ;
            for r=1:size(all_timecourses,2)         % Average timecourse over runs
                if ~isempty(all_timecourses{c,r}) && isstruct(all_timecourses{c,r}) && isfield(all_timecourses{c,r},'center_timecourse')
                    timecourse = timecourse + all_timecourses{c,r}.center_timecourse ;
                end
            end
            timecourse = timecourse / norm(timecourse) ;
            h(t) = plot(-(128:-1:1)*4 , timecourse(end:-1:1) , 'Color' , types.(cell_types{t}).color  , 'LineWidth' , 4) ;
        end
    end
end
legend(h , legends , 'Location' , 'SouthWest', 'FontSize',26)
xlim([-512 0])
xlabel('time  (ms)','FontSize',26)
ylabel('stimulus intensity','FontSize',26)
title(sprintf('STA timecourses for Experiment %d',ExperimentNum),'FontSize',32)
hold off

set(gca,'FontSize',28)

prepare_plot_pdf(filename)
saveas(gcf,filename)
plot_index.plot{1,1}.filename = filename ;
close all

end