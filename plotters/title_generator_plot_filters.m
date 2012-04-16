function title = title_generator_plot_filters(CellNum,FilterNum)

if FilterNum == 1
    title = sprintf('Cell %d STA',CellNum) ;
else
    title = sprintf('Cell %d COV filter %d',CellNum,FilterNum-1) ;
end

end