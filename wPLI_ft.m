function wPLI = wPLI_ft(data,srate,window)

% Compute Connectivity matrix using the weighted phase lag index wPLI implemented in fieldtrip
% inputs: data, nb_regions*nb_samples
%         srate: sampling rate
%         window: window length in seconds
% output: wPLi, connectivity matrix, nb_regions*nb_regions

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%%
load('inputs/sources','sources');

elec.chanpos = sources.Loc;
elec.elecpos = sources.Loc;
elec.label = sources.Label;
elec.unit = 'm';

%%
nb_samples = size(data,2);
% fmin = 1;fmax = 45;
% f_interest = fmin+(fmax-fmin)/2;
% window = 6/(f_interest); 

nb_win = floor(nb_samples/(srate*window));


for i=1:nb_win
    ftData.time{i} =  window*(i-1):1/srate:window*i-1/srate;
    ftData.trial{i} = data(:,(1+window*srate*(i-1)):(window*srate*i));
end

ftData.fsample = srate;
ftData.elec = elec;
ftData.label = elec.label';

%% cross-spectrum
cfg = [];
cfg.method = 'mtmfft';
cfg.output = 'powandcsd';
cfg.taper = 'hanning';
cfg.foilim = [1 45];
cfg.tapsmofrq = 2;
cfg.pad = 'nextpow2';
cfg.keeptrials = 'yes';

freq = ft_freqanalysis(cfg, ftData);

%% wpli
cfg = [];
cfg.method = 'wpli';

conn_wPLI = ft_connectivityanalysis(cfg,freq);

conn_wPLI = mean(conn_wPLI.wplispctrm,2);
conn_wPLI = abs(conn_wPLI);   

wPLI = zeros(66,66);
for c = 1:65
    ids = 1:66-c;
    wPLI (c+1:66,c) = conn_wPLI(ids,1);
    conn_wPLI(ids) = [];
end

end


