function  [x xsort sd nsd] = preprocess(params)
% Import .plx file, denoise & band-pass filter, detect-spike
% for MUA
[B,A] = butter(2,[300/params.Fs,3000/params.Fs]);
for i = 1:params.nch
    disp(sprintf('Processing Ch %d',i))
    [fs, n, ts, fn, x(:,i)] = plx_ad_v(sprintf('%s-01.plx',params.fname),i);
    x(:,i) = x(:,i) - mean(x(:,i));
    x(:,i) = filtfilt(B,A,x(:,i));
%     X{1} = x(params.new_zero:end,i);
%     y(i).spikes = ss_detect(X,pm);
end
% x = x(params.new_zero:end,:);
% if params.ts*params.Fs ~= 0
%     x = x(params.ts*params.Fs:end,:);
    x = x(params.new_zero:end,:);
% end
sd = std(x);
nsd = median(abs(x),1)/0.6745;

xfs = zeros((params.win * params.Fs * 2 + (params.offset * params.Fs)),params.nch,size(params.info,1));
% params.info(:,15) = ceil(params.info(:,13) * params.Fs);
for j = 1:size(params.info,1)
    xfs(:,:,j) = x(params.info(j,15) - (params.win * params.Fs) + 1:params.info(j,15) + (params.win * params.Fs) + (params.offset * params.Fs),:);
end


% Extract Signals for each condition 
xsort = [];
for i = 1:size(params.comb.comb,2)
    a = params.comb.comb(i).idx;
    for j = 1:size(a,1)
        xsort(i).xfs(:,:,j) = x(params.info(a(j),15) - (params.win * params.Fs) + 1:params.info(a(j),15) + (params.win * params.Fs) + (params.offset * params.Fs),:);
    end
end

figure;
for i = 1:params.nch
    subplot(ceil(sqrt(params.nch)),ceil(sqrt(params.nch)),i)
    plot(x(:,i),'k'); hold on
    yline(sd(i)*4,'r','LineWidth',2)
    yline(nsd(i)*4,'g','LineWidth',2)
end

% figure;
% for i = 1:params.nch
%     a = y(i).spikes.spiketimes;
%     b = ones(1,size(a,2))*i;
%     plot(a,b,'k.')
%     hold on
% end

end