function result = fold_stimulus(result,f,SpikeTimes,StimTimes,Nsamples,SuperSample,Npixels,BitFilename)
% result    : initial value of fold.
% SpikeTimes: spike times.
% StimTimes : frame times as extracted from the event marker, in the same
%             units as SpikeTimes. Don't forget that, if the checkerboard
%             is at 30 Hz,you should suppress one every two.
% Nsamples  : how many samples in the past before a spike?
% SuperSamp : how many samples per inter-frame-interval? Integer.
% Npixels   : Number of pixels in each frame.
% BitFilename: 'binarysource1000Mbits'
%
% This function assumes that InterFrameIntervals are always close to a
% fixed value. In particular, it ignores DoubleFrames, which are rare.
fid=fopen(BitFilename,'r','ieee-le');
BitFile=fread(fid,'uint16');
fclose(fid);

SpikeTimes = double(SpikeTimes);

IdxFrame = 1 ;
Nframes  = ceil( Nsamples/SuperSample ) + 1 ;

for ispike=1:length(SpikeTimes)
    if rem(ispike,500) == 0; fprintf('ispike = %d\n',ispike); end;
    dIdxFrame = find( StimTimes(IdxFrame:end) < SpikeTimes(ispike),1,'last') ;
    
    if ~isempty(dIdxFrame) && (IdxFrame-1 + dIdxFrame>Nframes)
        IdxFrame = IdxFrame-1 + dIdxFrame ;
        
        indexes = (-Nframes*Npixels+1:0) + (IdxFrame+1)*Npixels + 1 ;  % indices of pixels in BitFile

        k = floor(indexes/16) ;             % this is how BitFile maps to pixel values
        j = mod(indexes,16) ;               % apparently

        binary = bitand(BitFile(k+1)',2.^j)>0 ;

        binary = repmat( reshape( binary(end:-1:1) ,[Npixels Nframes]) , [SuperSample 1] ) ;
        binary = reshape( binary , Npixels, [] )' ;    % SuperSample using repmat

        T = StimTimes(IdxFrame+1)-StimTimes(IdxFrame) ;
        modulo = floor( SuperSample*(SpikeTimes(ispike) - StimTimes(IdxFrame))/T ) ;

        % Start at correct SuperSampling phase
%         [SuperSample*Nframes-Nsamples-modulo+1 SuperSample*Nframes Nsamples modulo]
        binary = binary( SuperSample*Nframes-Nsamples-modulo+1:end-modulo, : ) ; 

        result = f(result,binary) ;
    end
end

result

end