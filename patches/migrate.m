function migrate(from , to , cmd)

if nargin<3
    cmd = 'ln -s' ;
end

warning off
mkdir(to)

migr(from,to,cmd,'framelet_moments_reference.mat')

starts = [1 4 7 10 13 16 20 23 26]*10000 ;

for i=1:9
    migr(from,to,cmd,sprintf('framelet_repeat_datastore_%d_1_30000.mat',starts(i))) ;
end
    

for e=1:2
    for c=1:25
        migr(from,to,cmd,'framelet_moments.mat',e,c)
        migr(from,to,cmd,'framelet_score.mat',e,c)
        for r=1:6
            migr(from,to,cmd,'framelet_data.mat',e,c,r)
        end
    end
end

warning on

end


function migr(from,to,command,filename,e,c,r)

if nargin == 4
    filedir = '' ;    
elseif nargin == 5
    filedir = sprintf('Experiment_%d',e) ;
elseif nargin == 6
    filedir = sprintf('Experiment_%d/Cell_%d',e,c) ;
else
    filedir = sprintf('Experiment_%d/Cell_%d/Run_%d',e,c,r) ;
end

mkdir(sprintf('%s/%s',to,filedir)) ;
unix(sprintf('%s %s/%s/%s/%s %s/%s/%s/%s',command,pwd,from,filedir,filename,pwd,to,filedir,filename)) ;

fprintf('\nmigrated: %s',filename) ;

end