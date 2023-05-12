function [xsort] = findspkt(params)


for i = 1:params.ncond
    xsort(i).spkt = zeros(size(params.xsort(i).xfs));
    for j = 1:params.nch
        for z = 1:size(params.xsort(i).xfs,3)
            [spkval spkloc] = findpeaks(abs(params.xsort(i).xfs(:,j,z)),'MinPeakHeight',params.sd(j)*params.sdUser);
            xsort(i).spkt(spkloc,j,z) = 1;
        end
    end
end

    
