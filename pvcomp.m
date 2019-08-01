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

% Find average
nts = length(ts);
PVkAVG = total/nts;

% Loglog plot the average
h=loglog(kr,PVkAVG);