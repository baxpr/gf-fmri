
% TODO 
% PDF to show filtered design matrix to verify ok hpf
% PDF to show activation map similar to NDW_WM_v2
% Verify csv read works for all tasks

% Inputs
deffwd_niigz = '../../INPUTS_SPT/y_t1.nii.gz';
meanfmri_niigz = '../../OUTPUTS_SPT/coregistered_mean_fmriFWD.nii.gz';
fmri_niigz = '../../OUTPUTS_SPT/coregistered_fmriFWD.nii.gz';
eprime_summary_csv = '../../INPUTS_SPT/eprime_summary_SPT.csv';
motion_par = '../../OUTPUTS_SPT/rfwd.par';
out_dir = '../../OUTPUTS_SPT_spm';
fwhm = 4;
hpf = 300;
task = 'SPT';


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
% Read the csv once to get the size, then again to specify field format.
% Matlab is still not clever enough to suss this out on its own. Also there
% are some task-specific things here, e.g. skipping the "Tone" (Foil) event
% for the Oddball task.
names = {}; onsets = {}; durations = {};
ep = readtable([out_dir '/eprime_summary.csv'],'Delimiter','comma');
ep = readtable([out_dir '/eprime_summary.csv'], ...
	'Format',repmat('%q',1,size(ep,2)));
for c = 1:height(ep)
	if strcmp(task,'Oddball') && strcmp(ep.Condition{c},'Tone')
		% Skip this condition
	else
		names{end+1,1} = ep.Condition{c};
		onsets{end+1,1} = eval(ep.OnsetsSec{c});
		durations{end+1,1} = eval(ep.DurationsSec{c});
	end
end
conds_mat = [out_dir '/conds.mat'];
save(conds_mat,'names','onsets','durations');


%% Rename and rescale motion params so SPM can work with it
motion_txt = [out_dir '/motion_params.txt'];
mot = zscore(load(motion_par));
save(motion_txt,'mot','-ascii');


%% First level stats
disp('First level stats')
first_level_stats( ...
	hpf, ...
	[out_dir '/spm_unsmoothed'], ...
	task, ...
	conds_mat, ...
	motion_txt, ...
	[out_dir '/wfmri.nii'], ...
	out_dir ...
	);

first_level_stats( ...
	hpf, ...
	[out_dir '/spm'], ...
	task, ...
	conds_mat, ...
	motion_txt, ...
	[out_dir '/swfmri.nii'], ...
	out_dir ...
	);


