function [freq_list, stim, trigger,ttrans] = fgen_STEP(type,fs,notedur)
%% This function is used to generate random sequence
% Inputs:
%./ type
%./ fs = sampling rate (Hz); default 44100
%./ notedur = note duration (unit in ms); default = 50ms
% Outputs:
% ./ freq_list = sequence of tones for this trial
% ./ stim = stimulus used to present in the experiment (sample rate = design.fs)
% ./ ttrans = ttransition time from the onset of stimulus (unit in ms)
% Extra function required: fgenTone; framp
% __________________ Created by Sijia Zhao (UCL), last edited on 2020-07-22

if nargin <2; fs=44100; notedur=50;end % default

ifstim=1;
savewav=1; % to save wav file?

num_seg_pre = randi([40,50]);num_seg_post = 40; % jittered transition time

switch type
    case 'STEP'
        Npattern_post = 2;
    case 'noSTEP'
        Npattern_post = 1;
    otherwise
        warning('Unexpected type for control STEP.');
        return
end

% creating the pool of 20 log-spaced frequencies
freqs_pool=[...
    222,250,280,315,354,...
    397,445,500,561,630,...
    707,793,890,1000,1122,...
    1259,1414,1587,1781,2000];
Ntot = numel(freqs_pool); %total number of frequencies
if Npattern_post > Ntot; disp('Alphabet size too big. Check Npattern_post'); return; end

%% Output freq_list: Generate seqeunce type by type
switch type
    case 'noSTEP'
        p = randi(Ntot); % Decide which one from the pool will be selected
        freq = freqs_pool(p);
        num_seg_total= num_seg_pre+num_seg_post;
        freq_list = freq * ones(1,num_seg_total); % repmat(freq, 1, num_seg_total);% Generating the sequence of repeating freq
    case 'STEP'
        freq = datasample(freqs_pool,2,'Replace', false); % freq(1) for pre & freq(2) for post
        freq_list_pre = repmat(freq(1),1,num_seg_pre);
        freq_list_post = repmat(freq(2),1,num_seg_post);
        freq_list = [freq_list_pre freq_list_post];
end
freq_list = freq_list';

%% Output ttrans: Transition time
switch type
    case 'noSTEP'
        ttrans = 0;
    case 'STEP'
        ttrans = num_seg_pre * notedur;
end

%% Output stim: Generate seq stim for this trial
stim=[]; % stim=stereo soundfile
if ifstim
    for currTone=1:numel(freq_list)
        tone = fgenTone(freq_list(currTone), notedur, fs);
        stim = [stim tone]; %Concatenate the tone sequence by add next tone in the array
    end
    stim = stim*0.8;
end

%% Write to wav file
if savewav == 1; filename=[type '.wav']; audiowrite(filename, stim, fs); end
end
