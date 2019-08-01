function interp = fourierinterp(original,scaleup)

% interp = myinterp(original,scaleup)
%
% fourierinterp interpolates a real valued array (original) by padding the array
% with zeros in the fourier domain. The desired final size is given by scaleup.
% This has similar functionality to the defult matlab function 'interpft'.

    numberofdims = ndims(original);
    kmax         = scaleup/2; %since wavenumbers go from -n/2+1 to n/2
    ns           = size(original);
    n            = ns(1);
    paddingsize  = repmat(kmax-n/2,1,numberofdims);
    
    interp = real(ifftn(fftshift(padarray(fftshift(fftn(original)),...
                                  paddingsize,'both'))));
end

