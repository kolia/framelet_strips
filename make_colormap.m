function map = make_colormap(p)

cmap = colormap('jet') ;

map = zeros(64,3) ;

fact = 0.85 ;
flow  = min(1,max(fact,p*2)) ;
fhigh = min(1,max(fact,(1-p)*2)) ;


trans = fix(64*p) ;
for i=1:trans
    j = fix(flow*(64-1/2*(i-1)/p - 32)+32) ;
%     [i j]
    map(i,:) = cmap(j,:) ;
end

for i=trans+1:64
    j = fix(fhigh*(33-1/2*(64-(64-i)/(1-p)) - 32))+32 ;
%     [i j]
    map(i,:) = cmap(j,:) ;
end


% trans = fix(64*p)+1 ;
% for i=1:trans
%     map(i,:) = cmap(64-fix(1/2*(i-1)/p),:) ;
% end
% 
% for i=trans+1:64
%     map(i,:) = cmap(33-fix(1/2*(64-(64-i)/(1-p))),:) ;
% end