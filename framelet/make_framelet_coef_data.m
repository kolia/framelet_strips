function res = make_framelet_coef_data(times,ijs,horiz,StimulusSource,RecordsFolder,BinSize)

n = size(ijs,1)  ;
m = length(times) ;

fff = @(r,a,t) ff(r,a,ijs,horiz) ;

r{1} = zeros(m,n) ;
r{2} = 1 ;
r = FoldStimStripsSteps(times,StimulusSource,RecordsFolder,fff,r,BinSize,128) ;

res = r{1}(1:r{2}-1,:) ;

end


function r = ff(r,a,ijs,horiz)

a = a(:,horiz) ;

w = dd_dwt(a) ;
n = size(ijs,1) ;
rr= zeros(1,n) ;
for i=1:n
    if ijs(i,4) > 0
        rr(i) = w{ijs(i,1)}{ijs(i,2)}{ijs(i,3)}(ijs(i,4)) ;
    elseif ijs(i,3)>0
        rr(i) = w{ijs(i,1)}{ijs(i,2)}(ijs(i,3)) ;
    else
        rr(i) = w{ijs(i,1)}(ijs(i,2)) ;
    end
end
r{1}(r{2},:) = rr ;
r{2} = r{2} + 1 ;

end