clear all; clc
%% Set Parameters
params.fname = 'ytu197a';
params.nch = 1;
params.Fs = 10000;
params.win = .25; %msec
params.offset = .75; %msec
params.sdUserMin = 4;
params.sdUserMax = 8;

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
numTrials = 1;
for i=1:length(evts4)-1
    for j=1:length(evts9)
        if evts9(j)>evts4(i) & evts9(j)<evts4(i+1)
            numTrials = numTrials + 1;
            break;
        end
    end
end
%% Stim Condition
params.stim.sizeDeg = taskTrials.trialTaskValues.sizeDeg;
params.stim.sizeDegCond = taskTrials.trialTaskValues.sizeDegCond;
params.stim.contrast = taskTrials.trialTaskValues.contrast;
params.stim.contrastCond = taskTrials.trialTaskValues.contrastCond;
%% Stim Frame 
StimOn = (evts6 - ts) * params.Fs; % Stimulus on
StimOff = (evts7 - ts) * params.Fs; % Stimulus off
fixOn = (evts4 - ts) * params.Fs; % Fixation dot drawn
StimFrameTimeML = (cell2mat({taskTrials.frame.time})' - taskTrials.fixationOnState) * params.Fs;
FrameRate = size(StimFrameTimeML,1)/(taskTrials.frame(end).time - taskTrials.frame(1).time); % Screen Refresh Rate
%% Eye Position
eyetime = cell2mat({taskTrials.eyeSamples.time})' - taskTrials.fixationOnState;
eyepos = cell2mat({taskTrials.eyeSamples.rawEyeUnits})';
x = eyepos(1:2:end,:);
y = eyepos(2:2:end,:);
% h0 = figure;
% plot(x,y,'.') 
% xlim([min(x)-1 max(x)+1])
% ylim([min(y)-1 max(y)+1])
h1 = figure;
plot3(eyetime,x,y,'.','Color','k')
h1.Color = 'w';
title 'Eye Coordinates over Time'
xlabel 'Time(sec)'
ylabel 'X-Position'
zlabel 'Y-Position'
%% Import PLX file & Extract Raw Signal
x = [];
[B,A] = butter(2,[300/params.Fs,3000/params.Fs]);
for i = 1:params.nch
    disp(sprintf('Processing Ch %d',i))
    [fs, n, ts, fn, x(:,i)] = plx_ad_v(sprintf('%s-01.plx',params.fname),i);
    x(:,i) = x(:,i) - mean(x(:,i));
    x(:,i) = filtfilt(B,A,x(:,i));
end
x = x(evts4*params.Fs:end);
t = linspace(0,size(x,1)/params.Fs,size(x,1));
h2 = figure;
plot(t,x,'k','LineWidth',1.5); hold on
xline((evts6-evts4),'g','LineWidth',3)
xline((evts7-evts4),'r','LineWidth',3)
xline((evts5-evts4),'b','LineWidth',.1)
h2.Color = 'w';
xlabel 'Time(sec)'
ylabel 'Amplitude'
params.sd = std(x);
params.nsd = median(abs(x),1)/0.6745;

yline(params.sd*params.sdUserMin,'g','LineWidth',3)
yline(params.sd*params.sdUserMax,'r','LineWidth',3)
%% Find Spikes

params.spkt = zeros(size(x,1),params.nch);
for i = 1:params.nch
    [spkvalmin spklocmin] = findpeaks(abs(x(:,params.nch)),'MinPeakHeight',params.sd(i)*params.sdUserMin);
    [spkvalmax spklocmax] = findpeaks(abs(x(:,params.nch)),'MinPeakHeight',params.sd(i)*params.sdUserMax);
    [loc idx] = setdiff(spklocmin,spklocmax,'Stable');
    params.spkt(loc,i) = 1;  
end
plot(t,params.spkt,'g','LineWidth',.1)
%%
x = rand(100,1); % x-pos
y = rand(100,1); % y-pos
theta = deg2rad(45); % angle
ux = cos(2*pi*theta) * x; % horizontal velocity
uy = cos(2*pi*theta) * y;
vx = sin(2*pi*theta) * x; % vertical velocity
vy = sin(2*pi*theta) * y;
%%
n = 20;
r = [1 1]';
m = length(r);
theta = (0:n)/n*2*pi;
x = r * cos(theta);
y = r * sin(theta);
z = (0:m-1)'/(m-1) * ones(1,n+1);
figure
mesh(x,y,z)
%%
center = [3, 4];
radius = 2;
num_points = 100;  % Default number of points
% Generate a set of angles evenly spaced between 0 and 2*pi
angles = linspace(0, 2*pi, num_points);
% Compute the (x,y) coordinates of each point on the circle using sin and cos
x = center(1) + radius * cos(angles);
y = center(2) + radius * sin(angles);
plot(x,y)
%%
center = [0,0,0];
radius = 2;
num_points = 50;
theta = linspace(0,2*pi,num_points);
phi = linspace(0,pi,num_points);

[theat,phi] = meshgrid(theta,phi);

x = center(1) + radius * sin(phi) .* cos(theta);
y = center(2) + radius * sin(phi) .* sin(theta);
z = center(3) + radius * cos(phi);



surf(x,y,z)
%%
a = 1; % initial radius of the spiral in meters
b = 0.5; % rate of expansion of the spiral in meters/radian
t = 0:0.1:10; % time intervals to animate the spiral
theta = linspace(0,100*pi,1000); % incrementing the angle over time
x = (a+b*theta).*cos(theta);
y = (a+b*theta).*sin(theta);
h0 = figure;
for i = 1:length(theta)
    plot(x(1:i),y(1:i),'k.')
    axis equal
    axis off
    box off
    h0.Color = 'w'
    pause(.001)
end
%%
a = 1; % initial radius of the spiral in meters
b = 0.5; % rate of expansion of the spiral in meters/radian
t = 0:0.01:10; % time intervals to animate the spiral
t(end) = [];
theta = linspace(0,100*pi,1000); % incrementing the angle over time
x = (a+b*t).*cos(theta);
y = (a+b*t).*sin(theta);
h0 = figure;
for i = 1:length(theta)
    plot(x(1:i),y(1:i),'k.')
    axis equal
    axis off
    box off
    h0.Color = 'w'
    pause(.001)
end
%%
% Define the parameters for the spiral motion
a = 0.5; % initial radius of the spiral in meters
b = 0.1; % rate of expansion of the spiral in meters/radian
t = 0:0.01:10; % time intervals to animate the spiral
theta = t; % incrementing the angle over time

% Calculate the x and y coordinates of the spiral using the formulas
x = (a + b*theta).*cos(theta);
y = (a + b*theta).*sin(theta);

% Plot the spiral motion as an animation
figure;
for i = 1:length(t)
    plot(x(1:i), y(1:i), '-b', 'LineWidth', 2);
    axis equal;
    axis([-10 10 -10 10]);
    xlabel('x (m)');
    ylabel('y (m)');
    title('Spiral Motion Animation');
    drawnow;
end
%%
clear all
clc
[out.params,out.DATAPATH] = initialize;
hf = HFpreprocess(out.params);
hf = hf.configpath(out.DATAPATH);
out.plx = hf.readPLX;
out.mlogic = hf.readMonkey;
out.StimInfo = hf.getFrameRate;







