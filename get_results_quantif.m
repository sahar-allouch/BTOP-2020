function [results] = get_results_quantif(cmat_ref,cmat_est)

% Compute the accuracy of the estimated network compared to the reference network.
% inputs: cmat_ref: reference connectivity matrix, nb_regions*nb_regions
%         cmat_est: estimated connectivity matrix, nb_regions*nb_regions
% output: results, struct with 3 fileds(sensitivity, specificity, accuracy), length(struct) = nb_trials.

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

tmp_ref = cmat_ref>0;
tmp_est = cmat_est>0;

TP = sum((tmp_est + tmp_ref) == 2,'all');
FP = sum((tmp_est - tmp_ref) == 1,'all');
FN = sum((tmp_ref - tmp_est) == 1,'all');   
TN = 0;

results.sensitivity = TP/(TP+FN);
results.specificity = TN/(TN+FP);
results.accuracy = (TN+TP)/(TN+TP+FN+FP);

end
