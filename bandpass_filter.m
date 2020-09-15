function x_filtered = bandpass_filter(x,srate,fmin,fmax)
% bandpass filtering
% inputs: x: data, nb_channels*nb_samples
%         srate: sampling rate 
%         fmin: lower limit of the frequency band
%         fmax: upper limit of the frequency band
% output: x_filtered: filtered signal, nb_channels*nb_samples

[nb_channels,nb_samples] = size(x);

% filterorder=4/fmin;
filterorder=0.1;

b1 = fir1(floor(filterorder*srate),[fmin fmax]/(srate/2));

x_filtered=zeros(nb_channels,nb_samples);
for k = 1:nb_channels
    x_filtered(k,:) = filtfilt(b1,1,double(x(k,:)));
end

end