function framelet_repeat_data = make_framelet_repeat_data(framelet_repeat_datastore , framelet_score)

[c,inds] = intersect(framelet_repeat_datastore.inds,framelet_score.inds) ;

% sum(abs(c-framelet_score.inds))
% [min(inds) max(inds)]
% size(framelet_repeat_datastore)

framelet_repeat_data = framelet_repeat_datastore ;
framelet_repeat_data.data = framelet_repeat_datastore.data(:,inds) ;

end