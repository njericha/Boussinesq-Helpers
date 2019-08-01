function [kr, psum] = rsum(fullarray)
% psum = rsum(fullarray)
% Performs the radial partial sum of fullarray in Fourier space and returns
% kr, the wavenumbers, and psum, the partial sum at each wavenumber in kr. 

dims = size(fullarray); %find array dimentions
n = 2^ceil(log2(dims(1))); %find nearest power of 2 above the sizeof fullarray
[idx, kr] = getridx(n); %gets the indexes for KR==r.

psum = zeros(1, kr(end)+1); %initialize energy as a function of radial wavenumber matrix

arrayhat = abs(fftn(fullarray)); %calculate array values in fourier space
for r = kr
    psum(1,r+1) = sum(arrayhat(idx{r+1})); %sum over values of a given radial wavenumber
end

end
