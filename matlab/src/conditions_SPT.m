function conds_mat = conditions_SPT(out_dir)

ep = readtable([out_dir '/eprime_summary.csv'],'Delimiter','comma');
ep = readtable([out_dir '/eprime_summary.csv'], ...
	'Format',repmat('%q',1,size(ep,2)));

% Combine "red" and "yellow" trials
names = {'Scene';'Scramble'};

scene_ons1 = eval(ep.OnsetsSec{strcmp(ep.Condition,'Scene_red')});
scene_ons2 = eval(ep.OnsetsSec{strcmp(ep.Condition,'Scene_yellow')});
scene_ons = sort([scene_ons1 scene_ons2]);
scene_block_ons_ind = diff([0 scene_ons])>2;
scene_block_ons = scene_ons(scene_block_ons_ind);
scene_block_offs_ind = find(scene_block_ons_ind) + 15;  % 16 trials per block
scene_block_offs = scene_ons(scene_block_offs_ind) + 1; % 1 sec per trial

scram_ons1 = eval(ep.OnsetsSec{strcmp(ep.Condition,'Scramble_red')});
scram_ons2 = eval(ep.OnsetsSec{strcmp(ep.Condition,'Scramble_yellow')});
scram_ons = sort([scram_ons1 scram_ons2]);
scram_block_ons_ind = diff([0 scram_ons])>2;
scram_block_ons = scram_ons(scram_block_ons_ind);
scram_block_offs_ind = find(scram_block_ons_ind) + 15;  % 16 trials per block
scram_block_offs = scram_ons(scram_block_offs_ind) + 1; % 1 sec per trial

onsets = {scene_block_ons;scram_block_ons};

durations = {scene_block_offs-scene_block_ons;scram_block_offs-scram_block_ons};

conds_mat = [out_dir '/conds.mat'];
save(conds_mat,'names','onsets','durations');
