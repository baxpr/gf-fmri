function conds_mat = conditions_Oddball(out_dir)

names = {}; onsets = {}; durations = {};
ep = readtable([out_dir '/eprime_summary.csv'],'Delimiter','comma');
ep = readtable([out_dir '/eprime_summary.csv'], ...
	'Format',repmat('%q',1,size(ep,2)));
for c = 1:height(ep)
	if strcmp(ep.Condition{c},'Tone')
		% Skip this condition for Oddball
	else
		names{end+1,1} = ep.Condition{c};
		onsets{end+1,1} = eval(ep.OnsetsSec{c});
		durations{end+1,1} = eval(ep.DurationsSec{c});
	end
end
conds_mat = [out_dir '/conds.mat'];
save(conds_mat,'names','onsets','durations');
