function simulated_sources = get_source_mat(filename,srate,trim)

% concatnate the simulated cortical sources into one 2d-array
% inputs: filename: path of the simulated cortical sources sources ("inputs/sources_50_9_noId.mat"

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

load(filename)
labels = {'TH_0', 'r_BSTS_1', 'r_CAC_2', 'r_CMF_3', 'r_CUN_4', 'r_ENT_5', 'r_FP_6', 'r_FUS_7', 'r_IP_8', 'r_IT_9', 'r_ISTC_10', 'r_LOCC_11', 'r_LOF_12', 'r_LING_13', 'r_MOF_14', 'r_MT_15', 'r_PARC_16', 'r_PARH_17', 'r_POPE_18', 'r_PORB_19', 'r_PTRI_20', 'r_PCAL_21', 'r_PSTC_22', 'r_PC_23', 'r_PREC_24', 'r_PCUN_25', 'r_RAC_26', 'r_RMF_27', 'r_SF_28', 'r_SP_29', 'r_ST_30', 'r_SMAR_31', 'r_TP_32', 'r_TT_33', 'l_BSTS_34', 'l_CAC_35', 'l_CMF_36', 'l_CUN_37', 'l_ENT_38', 'l_FP_39', 'l_FUS_40', 'l_IP_41', 'l_IT_42', 'l_ISTC_43', 'l_LOCC_44', 'l_LOF_45', 'l_LING_46', 'l_MOF_47', 'l_MT_48', 'l_PARC_49', 'l_PARH_50', 'l_POPE_51', 'l_PORB_52', 'l_PTRI_53', 'l_PCAL_54', 'l_PSTC_55', 'l_PC_56', 'l_PREC_57', 'l_PCUN_58', 'l_RAC_59', 'l_RMF_60', 'l_SF_61', 'l_SP_62', 'l_ST_63', 'l_SMAR_64', 'l_TP_65', 'l_TT_66'};

for i=1:67
    simulated_sources(i,:)=eval(genvarname(labels{i}));
    clear (genvarname(labels{i}))
end

clear t i labels
simulated_sources(1,:)=[];
% trim the first sec, unstable output
simulated_sources(:,1:trim*srate)=[];

end