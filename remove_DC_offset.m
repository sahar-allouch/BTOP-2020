function x_noDc = remove_DC_offset(x)

% removing DC offset
% inputs: x: data, nb_channels*nb_samples
% output: x_noDC, nb_channels*nb_samples

[nb_channels,nb_samples] = size(x);

x_noDc = zeros(nb_channels,nb_samples);

for i=1:nb_channels
    x_noDc(i,:) = x(i,:) - mean(x(i,:));
end

end