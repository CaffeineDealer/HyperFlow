function [params,DATAPATH] = initialize

params.fname = 'ytu197a';
params.nch = 1;
params.Fs = 10000;
params.win = .25; %msec
params.offset = .75; %msec
params.sdUserMin = 4;
params.sdUserMax = 8;

DATAPATH = {'/Users/yavar/Library/CloudStorage/OneDrive-McGillUniversity/HyperFlow/Plexon/',...
    '/Users/yavar/Library/CloudStorage/OneDrive-McGillUniversity/HyperFlow/TrialStructure/'};