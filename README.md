# BTOP-2020

Evaluation of the effect of:
- five different electrode densities: 
      256, 128, 64, 32, 19
- two inverse solution algorithms: 
      weighted minimum norm estimate (wMNE)
      exact low resolution electromagnetic tomography (eLORETA)
- two functional connectivity measures: 
      phase locking value (PLV) 
      weighted minimum norm estimate (wPLI)
      
1) Cortical sources ('inputs/sources_50_9_noId.mat') are computed using COALIA model.
2) Scalp EEG are generated by solving the EEG direct problem.
3) Inverse solution are computed to reconstruct cortical sources.
4) Functional connectivity is assessed.
5) Accuracy of the estimaetd networks are computed.


Main script = 'script_pipeline_all.m'
