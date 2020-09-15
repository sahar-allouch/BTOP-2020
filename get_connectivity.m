function cmat = get_connectivity(data,srate,fmin,fmax,conn)

% compute connectivity matrix
% inputs: data: nb_regions*nb_samples
%         srate: sampling frequency
%         fmin: lower limit of the frequency band
%         fmax: upper limit of the frequency band
%         conn: connectivity measure "PLV" or "wPLI"
% cmat: symmetric connectivity matrix, nb_regions*nb_regions
% 
% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com
        
if conn=="PLV"
    %% PLV
    % fmin = 8;
    % fmax = 12;
    conn_PLV = PLV_slidingWindow (data, srate, fmin, fmax);
    cmat = conn_PLV + conn_PLV';
    
elseif conn=="wPLI"
    %% wPLi
    window = 0.3;
    conn_wPLI = wPLI_ft(data,srate,window);
    cmat = conn_wPLI + conn_wPLI';
    
end
end

