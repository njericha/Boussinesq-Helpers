% A mini script to compare and plot a variable between 256, 512, and 1024.
% It plots them in separate windows.

var = 'ZY';
t=220;
zslice = 0;
xyaxis = 'xz';
N = 1;
cmax = 2;
clims = [-1 1]*cmax;
ns = [256 512 1024];
pstns = {[126 520 560 420],[731 520 560 420],[1345 513 560 420]};

for idx = 1:length(ns)
n = ns(idx);
f = figure(n);
f.Position = pstns{idx};
h = ncfplot(var,t,n,xyaxis,zslice,'N',N);
caxis(clims)
end