
% TODO 
% PDF to show filtered design matrix to verify ok hpf
% PDF to show activation map similar to NDW_WM_v2

% Inputs
deffwd_niigz = '../INPUTS/y_deffwd.nii.gz';
meanfmri_niigz = '../OUTPUTS/coregistered_mean_fmriFWD.nii.gz';
fmri_niigz = '../OUTPUTS/coregistered_fmriFWD.nii.gz';
eprime_summary_csv = '../INPUTS/eprime_summary_WM.csv';
out_dir = '../OUTPUTS';
fwhm = 4;
hpf = 300;


%% Copy inputs to out_dir and unzip


%% Warp
matlabbatch{1}.spm.util.defs.comp{1}.def = {deffwd_niigz};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
	fullfile(out_dir,'meanfmri.nii')
	fullfile(out_dir,'fmri.nii')
	};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'w';


%% Smooth
matlabbatch{1}.spm.spatial.smooth.data = {fullfile(out_dir,'wfmri.nii')};
matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';


%% Condition info into SPM-style .mat
names = {}; onsets = {}; durations = {};
ep = readtable(fullfile(out_dir,'eprime_summary.csv'),'Format',repmat('%q',1,10));
for c = 1:height(ep)
	names{c,1} = ep.Condition{c};
	onsets{c,1} = eval(ep.OnsetsSec{c});
	durations{c,1} = eval(ep.DurationsSec{c});
end
save(fullfile(out_dir,'conds.mat'),'names','onsets','durations');



%% First level stats
matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(out_dir,'spm')};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {fullfile(out_dir,'swfmri.nii')};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = ...
	struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {fullfile(out_dir,'conds.mat')};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 300;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{1}.spm.stats.fmri_spec.mask = {[spm('dir') '/tpm/mask_ICV.nii,1']};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


%% Estimate
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[out_dir '/spm/SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;


%% Contrasts
spm_contrasts_WM([out_dir '/spm/SPM.mat'])

