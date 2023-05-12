function [] = ShowSuperTuneAlt4(responses,rows,columns,baseline,numMotion)

figure
%showtuning(responses,themax)
set(gcf,'Color',[1,1,1]);
themax = max(responses(:));
%nana=min(responses(:));



if themax > baseline-(themax-baseline)
    rg = [baseline-(themax-baseline),themax];
else
    rg = [min(responses(:)),baseline];
end
norms = sum(responses,[1,3]);
norms = max(norms(:));

mc = margecolor;
colormap(mc);
for ii = 1:numMotion
    for jj = 1:columns
        for kk = 1:rows
            xs = (1 + (jj-1)*4 + (rows*columns*3/2)*(ii-1))/40;% (rows*columns*numMotion/2)*(ii-1))/40;
            ys = ((kk)*4)/13;
            subplot('position',[xs,1-ys,3/40,3/13]);
            % axis square;
            resp = responses(ii,kk,jj);
            polarmosaic(resp,rg,.35,1);
            axis off;

        end
    end

end
colormap(margecolor);
end
