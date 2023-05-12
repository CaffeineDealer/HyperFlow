function STA2D(params)

params.tau = 0.5; % msec
params.tauStep = 0.1; % msec
spikes = params.spkt;
params.spa = 20;

%% STA's computation
tau = params.tau * params.Fs; % arbitrary tau value
tauStep = params.tauStep * params.Fs;
spikes = find(spikes==1); % number of spikes
data = zeros(params.spa,params.spa,(tau/tauStep)+1);
stim = -1 + 2.*rand(params.spa,params.spa,size(params.spkt,1));

ct = size(spikes,1);
for i = 1:length(spikes)
    disp(sprintf("%d out of %d",i,ct))
    counter = tau;
    if spikes(i) > tau 
        for j = 1:(tau/tauStep)+1
            data(:,:,j) = data(:,:,j) + stim(:,:,(spikes(i)-counter));
            counter = counter - tauStep;
        end
    end
end
data = data / length(spikes);

h0 = figure;
counter = tau/10;
for i = 1:(tau/tauStep)+1
    subplot(1,(tau/tauStep)+1,i)
    imagesc(data(:,:,i))
    title(sprintf('Lag = %d ms',counter))
    counter = counter - tauStep/10;
end
h0.Color = 'w';
