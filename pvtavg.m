% Takes a time average of the PV spectrum for a given n and loglog plots
% it. It requires all the desired times to have been pre-calculated.

% Inputs
ts = 230:5:240;
n = 512;

% Initialize total sum of PVk
total = zeros(1,171);

% main loop
for t = ts
filename = ['results/toexport/PVn' int2str(n) '_t' int2str(t)];
S = load([filename '.mat'],'PVk');
total = total + S.PVk;
end

% Load the list of wavenumbers once
S = load([filename '.mat'],'kr');

% Find average
nts = length(ts);
PVkAVG = total/nts;

% Loglog plot the average
f = figure;
set(f,'Position',[800, 100, 800, 800])
h=loglog(S.kr,PVkAVG);

% Title, legend, axis labels
title(['PV Spectrum for n = ' int2str(n) ' Time Averaged around t = ' num2str(mean(ts))])
xlabel('Wavenumber Magnitude');ylabel('Potential Vorticity Partial Sum');