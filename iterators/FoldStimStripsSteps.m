function [Result,Count]=FoldStimStripsSteps(Spike,StimulusSource,RecordFolder,F,Result,BinSize,N_bins,Start)
% SIGNATURE:
% [Result,Count]=FoldStimStripsSteps(SpikeTimes,StimulusSource,RecordsFolder,F,Initial,BinSize,N_bins,[Start])
%
% DESCRIPTION:
%   fold (aka reduce) a function F over the stimulus data at specified times (Spike).
%   At each time Spike(i), the stimulus at various Timeshifts into the past are used.
%   You can use this function whenever you need to traverse the stimulus.
%
%   This function is equivalent to doing the following 'for' loop:
%
%       Result = Initial ;
%       for t=Spike
%          Result  = F(Result , MatrixOfStimAtTime_t , t) ;
%       end
%
%   where MatrixOfStimAtTime_t is N-by-M,
%   where N is the number of TimeShifts,
%   and   M is the number of strips in each frame.
%
% INPUT:
%   Spike: a list of times (in units of samples, 1 sample = 0.1ms).
%   StimulusRecord: an obscure file which says which stimulus Record file
%       corresponds to which time.
%   RecordFolder: where all the Record files (the stimulus) are located.
%   TimeShifts: what times (frames) in the past before Spike(i) will be used.
%   F: the function being iterated. F should take 3 arguments, as above.
%   Initial: the initial value given to F.

global indentation

% try load('utility/temp_indentation') , catch ME , ME.stack ; indentation = '' ; end
fprintf(indentation)

if nargin<8 , Start = 0 ; end

L=length(StimulusSource);

Record   = -1 ;
Spike    = Spike(Spike<L);
N_Spikes = length(Spike) ; 
% fprintf('%sNumber of spikes: %d\n',indentation,N_Spikes)
Count    = zeros(N_Spikes,1) ;
Records  = cell(800,1) ;
TimeSpan = BinSize*N_bins ;

for i = 1:N_Spikes

    changed_record = 0 ;
    while Record < StimulusSource(Spike(i),end-1)
        if Record > 1 , Records{Record} = [] ; end
        Record = Record+1 ;
        Records{Record+1} = load(sprintf('%s/Record%d',RecordFolder,Record)) ;
        changed_record = 1 ;
    end
    if changed_record
        fprintf('. ')
%         fprintf('Record in memory %3d \tNumber of spikes %4d', Record, N_Spikes)
%         fprintf(' \tSpike number %4d \tTime %8d\n',i,Spike(i))
    end
    TimeSlot = Spike(i) - Start - (0:TimeSpan-1) ;
    if min(TimeSlot)>0 && min(StimulusSource(TimeSlot,end))>0
%     [min(TimeSlot) max(TimeSlot)]
%     [min(StimulusSource(TimeSlot,end)) max(StimulusSource(TimeSlot,end))]
        
%         size(Records)
%         Record
%         size(Records{Record+1}.FrameRecord)
%         [ max(StimulusSource(TimeSlot,end))]
        
        Slice = Records{Record+1}.FrameRecord(StimulusSource(TimeSlot,end),:) ;
        if StimulusSource( TimeSlot(end) , end-1 ) ~= Record   % If TimeSlot overlaps two records
            BridgeTimes = StimulusSource( TimeSlot , end-1 ) ~= Record ;
            Slice(BridgeTimes,:) = Records{Record}.FrameRecord(StimulusSource(TimeSlot(BridgeTimes),end),:) ;
        end
        Slice = double(squeeze(sum(reshape(Slice,BinSize,N_bins,200),1)))./BinSize ;
        Result=F(Result,Slice-.5,Spike(i));
        Count(i)=1;
    end
end
fprintf('\n')
end