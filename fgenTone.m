function sig=fgenTone(freq,seg_size,fs)
% Need extra function: framp
% Sijia Zhao (last edited 2020-07-22)

if nargin <3
    fs= 44100;
end

%create a tone of frequency f
sd = 1/fs;
n=1:fs*(seg_size)/1000;
%N=length(n);
t=n*sd;
stim=sin(2*pi*freq*t);

full_stim=framp(5,stim,fs); % add 5ms ramp-up and ramp-down to the stimulus
sig=full_stim;

end