function [xs, yprime] = deriv(xs,ys,method)
%yprime = deriv(ys,xs)
%   Aproximates the derivative dy/dx given discrete data. This assumes x
%   data is evenly spaced. If method is not given, 'discrete' is assumed.
if ~exist('method','var')
    method = 'discrete';
end

if strcmp(method,'discrete')
    yprime = diff(ys)./diff(xs); %makes yprime smaller by 1
elseif strcmp(method,'fourier')
    N = length(ys);
    if mod(N,2) == 1
        xs = xs(1:end-1);
        ys = ys(1:end-1);
        N = N-1;
    end
    ln = xs(end)-xs(1);
    k = 2*pi/ln*[0:(N/2),(-(N/2)+1):-1];
    %filter = k <= (2*pi/ln * N/10);k = filter.*k;
    k(end)=0;
    yhat = fft(ys);
    yhatprime=1i*k.*yhat;
    yprime = real(ifft(yhatprime)); %makes yprime even (possibly smaller)
    %smooth out neighbouring points by averaging them twice.
    yprime = (yprime + [yprime(2:end) yprime(1)])/2;
    yprime = (yprime + [yprime(2:end) yprime(1)])/2;
else
    error('Invalid method')
end

%since yprime values are given inbetween the original x points
xs = xs(1:length(yprime))+(xs(2)-xs(1))/2;

end

