function contrasts_Oddball(spm_dir,conds_mat)

load(conds_mat,'names');
clear matlabbatch
matlabbatch{1}.spm.stats.con.spmmat = {[spm_dir '/SPM.mat']};
matlabbatch{1}.spm.stats.con.delete = 1;
c = 0;


% Oddball vs foil trials, silence
c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Oddball';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	1.0 * startsWith(names,'Oddball');
matlabbatch{1}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';

c = c + 1;
matlabbatch{1}.spm.stats.con.consess{c}.tcon.name = 'Silence';
matlabbatch{1}.spm.stats.con.consess{c}.tcon.weights = ...
	1.0 * startsWith(names,'Silence');
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


% Motion - these get named "SN(1) R?" by virtue of being specified via the
% multi_reg option. Find them and build the F contrast matrix for SPM a row
% at a time.
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


