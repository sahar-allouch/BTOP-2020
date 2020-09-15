function cmat_thre = threshold_strength(cmat,p)

% thresholding connectivity matrix by keeping nodes with the highest 
% (p*100)% strength values. A node’s strength was defined as the sum of the 
% weights of its corresponding edges.  

% inputs: cmat: connectivity matix, nb_regions*nb_regions
% p = proportion of nodes kept in the network, it ranges from 0 to 1 
% output: cmat_thre: thresholded connectivity matrix

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

str = sum(cmat);
nb_rois = size(cmat,1);

[~,I] = maxk(str,floor(p*nb_rois));

cmat_thre = zeros(nb_rois);
for j = 1:nb_rois
    for k = 1:nb_rois
        if ismember(j,I) && ismember(k,I)
            cmat_thre(j,k) = cmat(j,k);
        end
    end
end

end