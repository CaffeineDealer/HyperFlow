clear all; clc
tic
Fs = 10000; % Sampling Frequency
[B,A] = butter(2,[300/Fs,3000/Fs]); % Filter
pm = ss_default_params(Fs); % Parameters

for i = 1:32
    disp(sprintf('Processing Ch %d',i))
    [fs, n, ts, fn, x(:,i)] = plx_ad_v('ytu197c-01.plx',i);
    x(:,i) = x(:,i) - mean(x(:,i));
    x(:,i) = filtfilt(B,A,x(:,i));
    X{1} = x(:,i);
    y(i).spikes = ss_detect(X,pm);
end

sd = std(x);
toc
figure;
for i = 1:32
    subplot(6,6,i)
    plot(x(:,i),'k'); hold on
    yline(sd(i)*4,'r','LineWidth',2)
end

figure;
for i = 1:32
    a = y(i).spikes.spiketimes;
    b = ones(1,size(a,2))*i;
    plot(a,b,'k.')
    hold on
end
