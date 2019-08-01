function ysmooth = fftsmooth(ys,method)
%smooth = fftsmth(ys)
%   Take a list ys and smooths out the data using a Gaussian Filter.
%   Use method = 'periodic' to assume periodic data, otherwise use
%   method = 'regular' or ommit the variable to not assume this.

if ~exist('method','var')
    method = 'regular';
end

noriginal = length(ys);
dims    = size(ys);
vrtlist = dims(2) == 1;
if vrtlist,ys=ys';end %perform all prossesing of ys horizontaly

oddlist = mod(length(ys),2);
if oddlist,ys=[ys ys(end)];end %repeat last value to make list even
n = length(ys);

if strcmp(method,'periodic')
        
    ks= [0:(n/2),(-(n/2)+1):-1]; %create wavenumbers in MATLAB format

    filt = exp(-ks.^2 ./ (n/2)); %gaussian filter
    yhat = fft(ys) .* filt; %fft list and apply filter
    ysmooth = real(ifft( yhat )); %ifft back
    
    if oddlist,ysmooth=ysmooth(1:end-1);end

elseif strcmp(method,'regular')
    
    ybig = [repmat(ys(1),[1 n]) ys repmat(ys(end),[1 n])]; %triple length of ys

    nbig = 3*n;
    ks= [0:(nbig/2),(-(nbig/2)+1):-1]; %create wavenumbers in MATLAB format

    filt = exp(-ks.^2 ./ (nbig/2)); %gaussian filter
    yhat = fft(ybig) .* filt; %fft list and apply filter
    ybig = real(ifft( yhat )); %ifft back

    ysmooth = ybig( n+1 : n+noriginal );
    
else
    error("Invalid variable 'method'")
end

if vrtlist,ysmooth=ysmooth';end %flip ysmooth back to match dims of ys

end