% spccomp compares the energy spectrum for multiple gridsizes at a given
% time. It graphs multiple loglog plots on the same axis and labels them.
% The average Kolmogorov Dissipation Wave Number is also plotted for
% reference.

% Inputs
%ns = [160 180 192 200 240 256];
ns = [256 512 1024];%[320 360 384         512];
t  = 220; %Must be between 0 and 300, can be given to one decimal place
wavetype = 's'; %'s' = spherical, 'h' = cylindrical, 'z' = rectangular
ylimits = [1e-10 1e-2];

% Set up figure
fig = figure;
set(fig,'Position',[800, 100, 800, 800])

% Prealocate room for dissipation wave numbers
Ks = zeros(size(ns));

% find the max index needed to loop over
[~, imax] = size(ns);

% Use spcplot to graph the spectrum for each n
for i = 1:imax
    n = ns(i);
    
    h = spcplot(n,t,'s');
    ylim(ylimits)
    
    % Add a name to each graph
    nstr = ['n' int2str(n)];
    set(h,'DisplayName',nstr)
    
    % Find the dissipation wave number for this spectrum
    Ks(i) = kolwavenum(n,t,wavetype);
    
    hold on
end

% Plot settings
legend
title(['Energy Spectrum at t = ' int2str(t)]);

% Plot a vertical line for the average disipation wavenumber 
kdis = mean(Ks);
h=plot([kdis kdis],ylimits);
set(h,'DisplayName','kdis')

hold off