
% Inputs
deffwd_niigz = '';
meanfmri_niigz = '';
fmri_niigz = '';
eprime_summary_csv = '';
out_dir = '';
fwhm = 6;
hpf = 300;


% Warp
matlabbatch{1}.spm.util.defs.comp{1}.def = ...
	{'DEF_FWD/y_t1.nii'};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
	'cmeanfmri.nii'
	'cfmri.nii'
	};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'w';

%% Smooth
matlabbatch{1}.spm.spatial.smooth.data = ...
	{'wfmri.nii'};
matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

%% Condition info into SPM-style .mat
names = {}; onsets = {}; durations = {};
ep = readtable('eprime_wm_summary.csv','Format',repmat('%q',1,10));
for c = 1:height(ep)
	names{c,1} = ep.Condition{c};
	onsets{c,1} = eval(ep.OnsetsSec{c});
	durations{c,1} = eval(ep.DurationsSec{c});
end
save('conds.mat','names','onsets','durations');



%% First level stats
matlabbatch{1}.spm.stats.fmri_spec.dir = {'spm_out'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = ...
	{'swfmri.nii'};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = ...
struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = ...
	{'conds.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 300;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{1}.spm.stats.fmri_spec.mask = ...
	{[spm('dir') '/tpm/mask_ICV.nii,1']};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


%% Estimate
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'spm_out/SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;


%% Contrasts
spm_contrasts_WM

