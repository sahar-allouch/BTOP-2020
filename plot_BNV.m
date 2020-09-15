function [] = plot_BNV(cmat,outputFilename)

% plotting the networks using BrainNet Viewer (http://www.nitrc.org/projects/bnv/)
% Xia M, Wang J, He Y (2013) BrainNet Viewer: A Network Visualization Tool for Human Brain Connectomics. PLoS ONE 8: e68910.


% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

dlmwrite('inputs/BNV/PLV.edge',cmat, 'delimiter', '\t');

surfaceFile = 'inputs/BNV/BrainMesh_ICBM152_smoothed.nv';
nodeFile = 'inputs/BNV/desikan_RR_LL_COALIAorder.node';
edgeFile = 'inputs/BNV/PLV.edge';
optionFile = 'inputs/BNV/opt_2patches_COALIA.mat';

mkdir('BNV_imag')
outputFile = ['BNV_imag/' outputFilename '.png'];
BrainNet_MapCfg(surfaceFile,nodeFile,edgeFile,optionFile,outputFile);

end

