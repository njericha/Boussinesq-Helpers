function [ts,ys] = datopen(n,var,depvar,N)
% [ts,ys] = datopen(n,var,depvar)
%
% datopen takes n, the gridsize, var, the filename string, and depvar,
% the dependent variable column number in the .dat file of interest. It
% returns ts, the times, and ys, the dependent variable values. N can be
% optionaly given to open data that uses an N other than 1.
%
% Example,
% [ts,ys] = datopen(256,'eng',2,1);
% returns ts = 1:0.1:300, and ys = the kinetic energy values at each time.
    if ~exist('N','var')
        N=1;
    end
    filename = mkfilepath(n,var,0,N);
    A = readmatrix(filename);
    ts = A(:,1);
    ys = A(:,depvar);
end