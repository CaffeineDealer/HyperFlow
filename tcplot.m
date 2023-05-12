function tcplotMUA(params,ch,mot)

figure
h = squeeze(params.firingrate.st(ch,:,mot,:));
% hbl = squeeze(params.firingrate.bl(ch,:,mot,:));
hbl = mean(params.firingrate.bl,[2,3,4]);
r = sqrt(params.npos);
c = r;
dir = [0:45:315];

for i = 1:r*c
    plot(subplot(r,c,i),dir,h(:,i),'Color','b','LineWidth',1)
    hold on
%     plot(subplot(r,c,i),dir,hbl(:,i),'Color','r','LineWidth',1)
    yline(subplot(r,c,i),hbl(ch),'Color','r','LineWidth',1)
    xlim([0 max(dir)])
    ylim([0 max(h(:))+2])
end

% switch mot
%     case 1
%         suptitle(sprintf('Translation ch%d',ch))
%     case 2
%         suptitle(sprintf('Spirals ch%d',ch))
% end