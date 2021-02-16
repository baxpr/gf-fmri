
% TODO 
% Add motion params to model
% PDF to show filtered design matrix to verify ok hpf
% PDF to show activation map similar to NDW_WM_v2
% Verify csv read works for all tasks

% Inputs
deffwd_niigz = '../INPUTS/y_t1.nii.gz';
meanfmri_niigz = '../OUTPUTS_notopup/coregistered_mean_fmriFWD.nii.gz';
fmri_niigz = '../OUTPUTS_notopup/coregistered_fmriFWD.nii.gz';
eprime_summary_csv = '../INPUTS/eprime_summary_WM.csv';
out_dir = '../OUTPUTS_spm_notopup';
fwhm = 4;
hpf = 300;
task = 'WM';


%% Copy inputs to out_dir and unzip
% Use hardcoded filenames hereafter for convenience
copyfile(deffwd_niigz,[out_dir '/y_deffwd.nii.gz'])
copyfile(meanfmri_niigz,[out_dir '/meanfmri.nii.gz'])
copyfile(fmri_niigz,[out_dir '/fmri.nii.gz'])
copyfile(eprime_summary_csv,[out_dir '/eprime_summary.csv']);
system([' gunzip -f ' out_dir '/*.nii.gz']);


%% Warp
disp('Warp')
clear matlabbatch
matlabbatch{1}.spm.util.defs.comp{1}.def = {[out_dir '/y_deffwd.nii']};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
	[out_dir '/meanfmri.nii']
	[out_dir '/fmri.nii']
	};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'w';
spm_jobman('run',matlabbatch);


%% Smooth
disp('Smoothing')
clear matlabbatch
matlabbatch{1}.spm.spatial.smooth.data = {[out_dir '/wfmri.nii']};
matlabbatch{1}.spm.spatial.smooth.fwhm = [fwhm fwhm fwhm];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run',matlabbatch);


%% Save condition info into SPM-style .mat
names = {}; onsets = {}; durations = {};
ep = readtable([out_dir '/eprime_summary.csv'],'Delimiter','comma');
%ep = readtable([out_dir '/eprime_summary.csv'], ...
%	'Format',repmat('%q',1,size(ep,2)));
for c = 1:height(ep)
	names{c,1} = ep.Condition{c};
	onsets{c,1} = eval(ep.OnsetsSec{c});
	durations{c,1} = eval(ep.DurationsSec{c});
end
conds_mat = [out_dir '/conds.mat'];
save(conds_mat,'names','onsets','durations');


%% First level stats
disp('First level stats')
spm_first_level_stats( ...
	hpf, ...
	[out_dir '/spm_unsmoothed'], ...
	task, ...
	conds_mat, ...
	[out_dir '/wfmri.nii'], ...
	out_dir ...
	);

spm_first_level_stats( ...
	hpf, ...
	[out_dir '/spm'], ...
	task, ...
	conds_mat, ...
	[out_dir '/swfmri.nii'], ...
	out_dir ...
	);


