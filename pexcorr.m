% This script uses the cross-corrilation to show how corrilated PE is with
% other data such at eps. Plots all the normalized data for comparison.

% Inputs
n      = 256;
var    = 'eps';
depvar = 2;
N      = 1;

% Create filename for PE, N only needs to be stated when it is different than 1.
if N==1
    fnameN = '';
else
    fnameN = ['N' num2str(N)];
end
filename = ['results/toexport/PEn' int2str(n) fnameN];

% Load PV data if it exists, if not then compute it
if exist([filename '.mat'],'file')
    S = load([filename '.mat'],'PEs','ts','tmaxPE');
    PEs=S.PEs; ts=S.ts; tmaxPE=S.tmaxPE;
else
    error('Deisred PE data is not found')
end

% Open comparison data
[~,ys] = datopen(n,var,depvar,N);
% Extract every 'step' number of points so length(epsdat)==length(PEs)
step = (length(ys)-1)/(length(PEs)-1);
vardat = ys(1:step:end)';

% Find the cross-corrilation
[r, lags] = xcorr(PEs,vardat,'normalized');

% Plot
f = figure;
set(f,'Position',[800, 100, 800, 800])
plot(lags,r,'DisplayName','Cross-Corrilation');
hold on
plot(ts,PEs./max(PEs),'DisplayName','Potential Enstrophy');
plot(ts,vardat./max(vardat),'DisplayName', [var '(' int2str(depvar) ')' ]);
hold off

% Add title, legend, and axis labels
title(['Corillation between PE and ' var ' for n' int2str(n) 'N' num2str(N)]);
leg = legend;leg.Location = 'southwest';
xlabel('Time');
ylabel('Normalized Magnitute');
