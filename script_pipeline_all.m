% main script
% Steps: 
% 1) loading simulated cortical sources, remove dc offset, bandpass filtering [1-45], extract trials
% 2) Functional connectivity, plot simulated networks
% 3) EEG direct problem
% 4) EEG inverse problem
% 5) Functional connectivity, plot estimated networks
% 6) Accuracy assessment

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%% add fieldtrip path
addpath S:\Matlab_Toolboxes\fieldtrip-20200423
ft_defaults

%%
srate = 2048;
fmin = 1;
fmax = 45;
epoch_length = 10;
p = 0.12; % threshold = 12%

conn = 'wPLI'; % 'PLV' or 'wPLI'

%% loading simulations + remove DC offset + bandpass filter

% load simulations
simul_filename = 'inputs/sources_50_9_noId';
trim = 1; % sec
% simulated sources
simul = get_source_mat(simul_filename,srate,trim);

[nb_rois,nb_samples] = size(simul);

% remove DC offset
simul_noDC = remove_DC_offset(simul);

% bandpass filter
simul_filtered = bandpass_filter(simul_noDC,srate,fmin,fmax);

clear simul_filename trim simul simul_noDC

%% get connectivity matrix of each trial

nb_trials = 36;
cmat_ref = zeros(nb_trials+1,nb_rois,nb_rois);

for i=1:nb_trials
    
    % get epoch #i, epoch length = 10 sec
    trial = simul_filtered(:,1+srate*(epoch_length*(i-1)):srate*(epoch_length*i));
    
    % get connectivity matrix for epoch #i
    cmat_ref(i,:,:) = get_connectivity(trial,srate,fmin,fmax,conn);
    
end

clear trial

% cmat_ref(nb_trials+1,:,:) = mean(cmat_ref(1:nb_trials,:,:),1);

%% thresholding connectivity matrices

cmat_ref_thre = zeros(nb_trials,nb_rois,nb_rois);

for i=1:nb_trials
    
    c = (reshape(cmat_ref(i,:,:),[nb_rois,nb_rois]));
    %     p = 0.12;
    cmat_ref_thre(i,:,:) = threshold_strength(c,p);
    
end

clear c

%%
% uncomment this section if you want to reject trials whose networks are
% not 100% as the desired reference network

% load('inputs/cmat_2patches_COALIA','cmat_2patches')
% j=1;
% for i=1:nb_trials
%     cmat = reshape(cmat_ref_thre(i,:,:),[nb_rois,nb_rois]);
%     if isequal(cmat>0,cmat_2patches)
%         good_trials(j) = i;
%         j=j+1;
%     end
% end
% save('inputs/good_trials_50_9','good_trials')

% load('inputs/good_trials_50_9','good_trials')
% nb_trials = 30;
% cmat_ref_thre = cmat_ref_thre(good_trials(1:nb_trials),:,:);

%%

c = mean(cmat_ref(1:nb_trials,:,:),1);
c = (reshape(c(1,:,:),[nb_rois,nb_rois]));
cmat_ref_thre(nb_trials+1,:,:) = threshold_strength(c,p);
clear cmat_ref c

% get the average connectivity matrix + threshold
cmat_ref_thre(nb_trials+2,:,:) = mean(cmat_ref_thre(1:nb_trials,:,:),1);
c = reshape(cmat_ref_thre(nb_trials+2,:,:),[nb_rois,nb_rois]);
% p = 0.12;
cmat_ref_thre(nb_trials+3,:,:) = threshold_strength(c,p);


%% plot reference networks in BrainNet Viewer (BNV)

for i = 1:nb_trials+3
    cmat = reshape(cmat_ref_thre(i,:,:),[nb_rois,nb_rois]);
    plot_BNV(cmat,['simul_' conn '_trial' num2str(i)]);
end

%%
montages = {'EGI_HydroCel_256','EGI_HydroCel_128','EGI_HydroCel_64',...
    'EGI_HydroCel_32','10-20_19'};

for m = 1:length(montages)
    
    %% EEG
    eeg = compute_eeg(simul_filtered,montages{m});
    
    %% inverse solution
    filters = get_inverse_solution(eeg,srate,montages{m});
    
    %%
    % filters order: 1 = eloreta, 2 = wmne
    inv_meth = {'eloreta','wmne'};
    
    for f = 1:size(filters,1)
        tmp_filter = reshape(filters(f,:,:),[size(filters,2),size(filters,3)]);
        estimated_sources = tmp_filter*eeg;
        
        %%
        nb_trials = 36;
        cmat_est = zeros(nb_trials,nb_rois,nb_rois);
        for i=1:nb_trials
            % get epoch #i
            trial = estimated_sources(:,1+srate*(epoch_length*(i-1)):srate*(epoch_length*i));
            % get connectivity matrix of epoch #i
            cmat_est(i,:,:) = get_connectivity(trial,srate,fmin,fmax,conn);
        end
        clear trial
        
        %%
        % nb_trials = 30;
        % cmat_est = cmat_est(good_trials(1:nb_trials),:,:);
        cmat_est(nb_trials+1,:,:) = mean(cmat_est(1:nb_trials,:,:),1);
        
        % thresholding
        cmat_est_thre = zeros(nb_trials+1,nb_rois,nb_rois);
        for i=1:nb_trials+1
            c = reshape(cmat_est(i,:,:),[nb_rois,nb_rois]);
            %  p = 0.12;
            cmat_est_thre(i,:,:) = threshold_strength(c,p);
        end
        
        %%%%
        cmat_est_thre(nb_trials+2,:,:) = mean(cmat_est_thre(1:nb_trials,:,:),1);
        c = reshape(cmat_est_thre(nb_trials+2,:,:),[nb_rois,nb_rois]);
        % p = 0.12;
        cmat_est_thre(nb_trials+3,:,:) = threshold_strength(c,p);
        %%%%
        
        clear cmat_est c
        for i = 1:nb_trials+3
            cmat = reshape(cmat_est_thre(i,:,:),[nb_rois,nb_rois]);
            plot_BNV(cmat,['est_' conn '_' inv_meth{f} '_' montages{m} '_trial' num2str(i)]);
        end
        
        
        %% get the accuracy of estimated networks
        results = struct('sensitivity',[],'specificity',[],'accuracy',[]);
        
        for i =1:nb_trials
            tmp_ref = reshape(cmat_ref_thre(i,:,:),[nb_rois,nb_rois]);
            tmp_est = reshape(cmat_est_thre(i,:,:),[nb_rois,nb_rois]);
            
            results(i)= get_results_quantif(tmp_ref,tmp_est);
        end
        
        mkdir('results')
        save(['results/results_' conn '_' inv_meth{f} '_' montages{m}],'results');
        
    end
end


