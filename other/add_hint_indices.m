function indices = add_hint_indices(hints,indices)

for i=1:length(indices)
    indices{i} = [hints length(hints)+(indices{i}(:)')] ;
end

end