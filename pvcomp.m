% Plot multiple PV spectrums for a given n at multiple times.
% It requires all the desired times to have been pre-calculated.

% Inputs
n = 256;
ts = 200:10:240;

% Create figure
f = figure;
set(f,'Position',[800, 100, 800, 800])

% List of line styles to cycle through
linestyles = {'-',':','--','-.'};

% main loop
for idx = 1:length(ts)
    t = ts(idx);
    %Load file data
    filename = ['results/toexport/PVn' int2str(n) '_t' int2str(t)];
    S = load([filename '.mat'],'kr','PVk');
    
    %Loglog plot it
    colorfade = [1 1 1] - ([1 1 0].*(idx / length(ts))).^1.5; %fades from white to blue
    h = loglog(S.kr,S.PVk,'DisplayName',['t = ' num2str(t)],...
        'Color', colorfade,'LineStyle',linestyles{mod(idx-1,4)+1});           
    hold on
end
hold off

% Title, legend, axis labels
title(['Potential Vorticity Spectrum for n = ' int2str(n) ' at Various Times'])
leg = legend;leg.Location = 'northwest';
xlabel('Wavenumber Magnitude');ylabel('Potential Vorticity Partial Sum');