function [contrast,conname] = first_level_stats(hpf,spm_dir,task, ...
	conds_mat,motion_txt,fmri_nii,wmt1_nii,out_dir)

%% Init for printing windows
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_figure('Create','Graphics','SPM12');


%% First level stats
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_spec.dir = {spm_dir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {fmri_nii};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = ...
	struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {[out_dir '/conds.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motion_txt};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = hpf;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{1}.spm.stats.fmri_spec.mask = {[spm('dir') '/tpm/mask_ICV.nii,1']};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

% Capture the graphical output
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{1}.string = ...
	fullfile(out_dir,'first_level_design.png');
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.outputs = {};
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.fun = 'spm_window_print';

% Run
spm_jobman('run',matlabbatch);


%% Estimate
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[spm_dir '/SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch);


%% Contrasts
switch task
	case 'Oddball'
		contrasts_Oddball(spm_dir,conds_mat)
		contrast = 1;
	case 'SPT'
		contrasts_SPT(spm_dir,conds_mat)
		contrast = 3;
	case 'WM'
		contrasts_WM(spm_dir,conds_mat)
		contrast = 3;
	otherwise
		error('Task %s is unknown',task)
end
q = load([spm_dir '/SPM.mat']);
conname = q.SPM.xCon(contrast).name;


%% Results display
% Not used - use fsleyes instead
return
xSPM = struct( ...
    'swd', spm_dir, ...
    'title', '', ...
    'Ic', contrast, ...
    'n', 0, ...
    'Im', [], ...
    'pm', [], ...
    'Ex', [], ...
    'u', 0.005, ...
    'k', 10, ...
    'thresDesc', 'none' ...
    );
[hReg,xSPM] = spm_results_ui('Setup',xSPM);

% Show on the subject MNI anat
spm_sections(xSPM,hReg,wmt1_nii)

% Jump to global max activation
spm_mip_ui('Jump',spm_mip_ui('FindMIPax'),'glmax');

% Or jump to specified position
%spm_mip_ui('Jump',spm_mip_ui('FindMIPax'),view_loc);

% Capture the graphical output
clear matlabbatch
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{1}.string = ...
	fullfile(out_dir,'first_level_results.png');
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.outputs = {};
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.fun = 'spm_window_print';
spm_jobman('run',matlabbatch);


