function [filters] = get_inverse_solution(eeg,srate,montage)

% compute EEG inverse solution using eLORETA and wMNE
% inputs: eeg: nb_channels*nb_samples
% srate: sampling rate
% montage: montage based on which EEg data was computed. {'EGI_HydroCel_256',
% 'EGI_HydroCel_128','EGI_HydroCel_64','EGI_HydroCel_32','10-20_19'}.

% Outputs: filters: 2*nb_regions*nb_channels, nb_regions denotes the number
% of cortical sources, nb_channels denotes the number of EEG channels. The
% first dimension refers to the inverse solution (1=eLORETA, 2=wMNE)

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com


load('inputs/sources','sources') % sources location and orientation
load(['inputs/ftChannels_' montage],'elec') % channel file
load('inputs/ftHeadmodel','ftHeadmodel') % headmodel
load(['inputs/ftLeadfield_' montage],'ftLeadfield') % leadfield

%% noise covariance
noiseCov = inverse.CalculateNoiseCovarianceTimeWindow(eeg(:,0.5*srate:1.5*srate));     
%%
nb_trials = 1;
pre_spik = 1.5;
post_spik = 2.5;

% ft_datatype_raw
% label: {N*1 cell}
% time: {1*nb_trials cell}
% trial: {1*nb_trials cell}

for i=1:nb_trials
    ftData.trial{i} = eeg(:,srate*(5*i-pre_spik):srate*(5*i+post_spik));
    ftData.time{i}  = -pre_spik:1/srate:post_spik;
end

ftData.elec = elec;
ftData.label = elec.label';
ftData.fsample = srate;

clear eeg

filters = [];
f = 1;

%% eLORETA
cfg                     = [];
cfg.method              = 'eloreta';
cfg.sourcemodel         = ftLeadfield;
cfg.sourcemodel.mom     = transpose(sources.Orient);
cfg.headmodel           = ftHeadmodel;
cfg.eloreta.keepfilter  = 'yes';
cfg.eloreta.keepmom     = 'no';
cfg.eloreta.lambda      = 0.05;
src                     = ft_sourceanalysis(cfg,ftData);

filters(f,:,:)          = cell2mat(transpose(src.avg.filter));
f = f+1;

%% wMNE
weightExp = 0.5;
weightLimit = 10;
SNR = 3;

Gain=cell2mat(ftLeadfield.leadfield);
GridLoc = sources.Loc;
GridOrient = sources.Orient;

filters(f,:,:) = inverse.ComputeWMNE(noiseCov,Gain,GridLoc,GridOrient,weightExp,weightLimit,SNR);

end
