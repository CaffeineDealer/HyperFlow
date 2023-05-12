clear all; clc
%% Set Parameters
params.fname = 'ytu197c';
params.nch = 32;
params.Fs = 10000;
params.win = .25; %msec
params.offset = .75; %msec
params.sdUser = 5;
%% PreProcess Experiment
[taskTrials,ts,goodtrials,flg,params] = importEss(params);
[params.comb] = trialIdx(params.info);
params.ncond = size(params.comb.allcomb,1);
%% PreProcess Raw Signal - Broadband
[params.x params.xsort params.sd params.nsd] = preprocess(params);
%% Find Spike & Generate Spike Trains
[params.spkt] = findspkt(params);
%% Creating a 6D matrix ch * npoints * dir * motion * position * repetition
for i = 1:params.ncond
    params.nr(i,1) = size(params.spkt(i).spkt,3);
end
params.dur = size(params.xsort(1).xfs,1)/2;
params.ndir = size(unique(params.comb.allcomb(:,1)),1);
params.nmot = size(unique(params.comb.allcomb(:,2)),1);
params.npos = size(unique(params.comb.allcomb(:,3)),1);
params.nrep = max(params.nr);
for i = 1:params.ncond
    if size(params.spkt(i).spkt,3) ~= params.nrep
        params.spkt(i).spkt(:,:,params.nrep) = nan;
    end
end

params.X = nan(params.dur*2,params.nch,params.ndir,params.nmot,params.npos,params.nrep);
w = 1;
for i = 1:params.ndir
    for j = 1:params.nmot
        for z = 1:params.npos
            params.X(:,:,i,j,z,:) = params.spkt(w).spkt;
            w = w + 1;
        end
    end
end
params.X = permute(params.X,[2,1,3,4,5,6]);
%% Firing Rate
[params.firingrate.bl params.firingrate.st] = firingrate(params);
return
%% Plot Tuning Curves
numMotion = 3;
rows = 3;
columns = 3;
close all
for i = 1:params.nch
    tcplot(params,i,1)
    tcplot(params,i,2)
    tcplot(params,i,3)
    baseline = squeeze(params.firingrate.bl(i,:,:,:));
    baseline = mean(baseline(:));
    r = squeeze(params.firingrate.st(i,:,:,:));
    ShowSuperTuneAlt4(r,rows,columns,baseline,numMotion);
end
%% PSTH