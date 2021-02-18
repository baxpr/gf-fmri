function first_level_stats(hpf,spm_dir,task,conds_mat,motion_txt,fmri_nii,out_dir)


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
spm_jobman('run',matlabbatch);


%% Estimate
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[spm_dir '/SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch);


%% Contrasts
switch task
	case 'WM'
		contrasts_WM(spm_dir,conds_mat)
	otherwise
		error('Task %s is unknown',task)
end


