function plv = PLV_slidingWindow(signals,srate,fmin,fmax)

% inputs: signals: datat matrix, nb_channels*nb_samples
%         srate: sampling frequency
%         fmin: lower limit of the frequency band
%         fmax: upper limit of the frequency band

% output: connectivity matrices, nb_channels*nb_channels

% This code was originally developped by Aya Kabbara. 
% contact: aya.kabbara7@gmail.com

%% Extract the instantaneous phase using Hilbert Transform
[nchannels,numSamples] = size(signals);

% f_interest = fmin+(fmax-fmin)/2;
% window = 6/(f_interest); % Use 6 cycles as recomended by Lachaux et al.2000

window = size(signals,2)/srate; %PLV static

winSamples = floor(window * srate);
N = floor(numSamples/winSamples);
plv = zeros(N,nchannels, nchannels);

inst_phase = zeros(nchannels,numSamples);
for channelCount = 1:nchannels
    inst_phase(channelCount, :) = angle(hilbert((signals(channelCount, :))));
end

%% Dynamic PLV
No = winSamples/2+1;

for count = 1:N
    for channelCount = 1:nchannels-1
        channelData = squeeze(inst_phase(channelCount, No-winSamples/2:No+winSamples/2-1));
        for compareChannelCount = channelCount+1:nchannels
            compareChannelData = squeeze(inst_phase(compareChannelCount, No-winSamples/2:(No+winSamples/2-1)));
            diff = channelData(:, :) - compareChannelData(:, :);
            diff = diff';
            plv(count,channelCount,compareChannelCount) = abs(sum(exp(1i*diff)))/length(diff);
        end
    end
    
    No = No+winSamples;
end

%% Static PLV
plv = mean(plv,1);
plv = reshape(plv(1,:,:),[nchannels,nchannels]);

end