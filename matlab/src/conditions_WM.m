function conds_mat = conditions_WM(out_dir)

names = {}; onsets = {}; durations = {};
ep = readtable([out_dir '/eprime_summary.csv'],'Delimiter','comma');
ep = readtable([out_dir '/eprime_summary.csv'], ...
	'Format',repmat('%q',1,size(ep,2)));
for c = 1:height(ep)
	names{end+1,1} = ep.Condition{c};
	onsets{end+1,1} = eval(ep.OnsetsSec{c});
	durations{end+1,1} = eval(ep.DurationsSec{c});
end
conds_mat = [out_dir '/conds.mat'];
save(conds_mat,'names','onsets','durations');
