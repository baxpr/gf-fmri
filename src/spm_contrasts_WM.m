function spm_contrasts_WM(spm_dir,conds_mat)

load(conds_mat,'names');
clear matlabbatch
matlabbatch{1}.spm.stats.con.spmmat = {[spm_dir '/SPM.mat']};
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


% Motion
SPM = load([spm_dir '/SPM.mat']);
mot_inds = strncmp('Sn(1) R',SPM.SPM.xX.name,7);
mot_indsf = find(mot_inds);
mot_con = zeros(sum(mot_inds),size(mot_inds,2));
for m = 1:sum(mot_inds)
	mot_con(m,mot_indsf(m)) = 1;
end
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.fcon.name = 'Motion';
matlabbatch{1}.spm.stats.con.consess{c}.fcon.weights = mot_con;
matlabbatch{1}.spm.stats.con.consess{c}.fcon.sessrep = 'replsc';



%% Run it
spm_jobman('run',matlabbatch);
