
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

load('conds.mat')
matlabbatch{1}.spm.stats.con.spmmat = {'spm_out/SPM.mat'};
matlabbatch{1}.spm.stats.con.delete = 1;
c = 0;


% 0back, 2back for all stimulus types
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = '0back';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	1.0 * startsWith(names,'0-Back');
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = '2back';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	1.0 * startsWith(names,'2-Back');
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = '2back gt 0back';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back') - startsWith(names,'0-Back'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% Each stimulus type for both memory conditions
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') + startsWith(names,'0-Back_Body'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') + startsWith(names,'0-Back_Face'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Place';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Place') + startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Tools';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Tools') + startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% 2back gt 0back for each stimulus
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body 2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') - startsWith(names,'0-Back_Body'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face 2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') - startsWith(names,'0-Back_Face'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Place 2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Place') - startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Tools 2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Tools') - startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% Stimulus types compared vs "Other", 0/2back combined
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body gt NonBody';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(endsWith(names,'Body') / sum(endsWith(names,'Body'))) ...
	- (~endsWith(names,'Body') / sum(~endsWith(names,'Body')));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face gt NonFace';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(endsWith(names,'Face') / sum(endsWith(names,'Face'))) ...
	- (~endsWith(names,'Face') / sum(~endsWith(names,'Face')));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Place gt NonPlace';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(endsWith(names,'Place') / sum(endsWith(names,'Place'))) ...
	- (~endsWith(names,'Place') / sum(~endsWith(names,'Place')));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Tools gt NonTools';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(endsWith(names,'Tools') / sum(endsWith(names,'Tools'))) ...
	- (~endsWith(names,'Tools') / sum(~endsWith(names,'Tools')));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% Stimulus types compared with each other, 0/2back combined
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body gt Face';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') + startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Face') + startsWith(names,'0-Back_Face'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body gt Place';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') + startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Place') + startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body gt Tools';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') + startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Tools') + startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face gt Place';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') + startsWith(names,'0-Back_Face')) ...
	- (startsWith(names,'2-Back_Place') + startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face gt Tools';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') + startsWith(names,'0-Back_Face')) ...
	- (startsWith(names,'2-Back_Tools') + startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Place gt Tools';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Place') + startsWith(names,'0-Back_Place')) ...
	- (startsWith(names,'2-Back_Tools') + startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% Stimulus types compared with each other on 2gt0 contrast
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body2gt0 gt Face2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') - startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Face') - startsWith(names,'0-Back_Face'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body2gt0 gt Place2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') - startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Place') - startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Body2gt0 gt Tools2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Body') - startsWith(names,'0-Back_Body')) ...
	- (startsWith(names,'2-Back_Tools') - startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face2gt0 gt Place2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') - startsWith(names,'0-Back_Face')) ...
	- (startsWith(names,'2-Back_Place') - startsWith(names,'0-Back_Place'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Face2gt0 gt Tools2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Face') - startsWith(names,'0-Back_Face')) ...
	- (startsWith(names,'2-Back_Tools') - startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Place2gt0 gt Tools2gt0';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	(startsWith(names,'2-Back_Place') - startsWith(names,'0-Back_Place')) ...
	- (startsWith(names,'2-Back_Tools') - startsWith(names,'0-Back_Tools'));
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';


% Inverse of all existing contrasts since SPM won't show us both sides
numc = numel(matlabbatch{1}.spm.stats.con.consess);
for k = 1:numc
	c = c + 1;
	matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = ...
		['Neg ' matlabbatch{1}.spm.stats.con.consess{c-numc}.tcon.name];
	matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
		- matlabbatch{1}.spm.stats.con.consess{c-numc}.tcon.weights;
	matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';
end

