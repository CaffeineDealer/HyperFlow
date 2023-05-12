function [bl st] = firingrate(params)


i = 1;
for j = 1:params.ndir
    for z = 1:params.nmot
        for w = 1:params.npos
            params.N(1:params.nch,j,z,w) = params.nr(i);
            i = i + 1;
        end
    end
end

bl = squeeze(nansum(nansum(params.X(:,1:params.win*params.Fs,:,:,:,:),[2]),[6]))./(params.N*(params.dur/params.Fs));
st = squeeze(nansum(nansum(params.X(:,params.win*params.Fs+1:end,:,:,:,:),[2]),[6]))./(params.N*(params.dur/params.Fs));





