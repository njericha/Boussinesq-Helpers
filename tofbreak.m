function tb = tofbreak(ts,ys,method)
%tb = tofbreak(ys,ts)
% Finds the time of breaking tb. The following methods are avalible.
% method ==
% 'threshold': when the value of y is above 5% of it's maximum for the first time
% 'thresholdrv': when the value of y is below 99% of it's maximum for the first time
% 'maxdecay': when dy/dt is most negative
% 'thresholddecay': when the normalized dy/dt is below -1, 2 points in a row
% 'oscillation': when the value of y is above the max value of initial oscillation

if strcmp(method,'threshold')
    ymax      = max(ys(2:end)); %ymax, ignoring the initial value
    threshold = 0.20;
    filter    = ys >= (threshold*ymax);
    filter(1) = 0; %ensure the initial time is not selected
    idxs      = find(filter);
    tb        = ts(idxs(1)); %use the first index that ys is above the threshold
elseif strcmp(method,'thresholdrv')
    ymax      = max(ys(2:end)); %ymax, ignoring the initial value
    threshold = 0.99;
    filter    = ys <= (threshold*ymax);
    filter(1) = 0; %ensure the initial time is not selected
    idxs      = find(filter);
    tb        = ts(idxs(1)); %use the first index that ys is above the threshold
elseif strcmp(method,'maxdecay')
    [ts, yprime] = deriv(ts,ys);
    tmaxs        = tofmaxval(ts,-yprime);
    tb = tmaxs(1); %returns only one time in case there are multiple max's
elseif strcmp(method,'thresholddecay')
    tscaled = ts/max(ts);
    yscaled = ys/max(ys);
    [tscaled, yprime] = deriv(tscaled,yscaled);
    ts = tscaled*max(ts);
    thresholdslope = -1;
    tb = ts((yprime(1:end-1) < thresholdslope) & (yprime(2:end) < thresholdslope)); %needs to have the slope 2 data points in a row
    tb = tb(1); %returns only one time in case there are multiple tb's
elseif strcmp(method,'oscillation')
    yosc      = max(ys(3:100)); %ignoring the initial 2 values
    filter    = ys > yosc;
    filter([1 2]) = 0;%ensure the initial and 2nd time are not selected
    idxs      = find(filter);
    tb        = ts(idxs(2)); %use the 2nd index that ys is above the threshold
else
    error('Invalid method')
end

end

