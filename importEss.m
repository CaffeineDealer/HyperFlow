function [taskTrials,ts,goodtrials,flg,params] = importEss(params)
% Function importEss ...
%%%% Inputs %%%%
% fname:    file name
%%%% Outputs %%%%
% new_zero:   offset time between MonkeyLab & Plexon
% Written by Yavar Korkian on May.05.2023
%%
load(['/Users/yavar/Library/CloudStorage/OneDrive-McGillUniversity/HyperFlow/TrialStructure/',sprintf('%s_TrialStructure.mat',params.fname)])
cd /Users/yavar/Library/CloudStorage/OneDrive-McGillUniversity/HyperFlow/Plexon/
[~, evts3, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),3); % Trial start
[~, evts4, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),4); % Fix on
[~, evts5, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),5); % Fixating
[~, evts6, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),6); % Stim on
[~, evts7, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),7); % Stim stop
[~, evts8, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),8); % Data Collection start
[~, evts9, ~] = plx_event_ts(sprintf('%s-01.plx',params.fname),9); % Trial end
[~, ~, ts, ~, ~] = plx_ad_v(sprintf('%s-01.plx',params.fname),1);
%%
[goodtrials params.info] = getTrialML(params,taskTrials,evts4,evts6,evts9,evts7);
% Finding Fixation onset for the first successful trial
[params.new_zero flg] = fixOnset(params,evts3,evts4,goodtrials,ts);
% flg = 2;
% if flg == 2
%     info(:,13) = info(:,13) - ts;
% end
params.info(:,14) = params.info(:,18) * params.Fs;
params.info(:,15) = ceil(params.info(:,14));
end