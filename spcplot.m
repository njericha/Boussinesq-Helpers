function h = spcplot(n,t,wavetype,newfn)
% h = spcplot(n,t,wavetype,newfn)
%
% Plots the energy spectrum of the data for gridsize n at time t. wavetype
% determines which summing method is used for the partial sums of energy.
% '','s' = spherical (defult), 'h' = cylindrical, 'z' = rectangular
% If newfn is given, the function will also export the figure to the
% location given.

    export = exist('newfn','var');
    
    % Set up a new figure if exporting is desired
    if export
        f = figure;
        set(f,'Position',[800, 100, 800, 800])
    end
    
    % Open and plot data
    [ks,Ek] = spcopen(n,t,wavetype);
    h = loglog(ks,Ek);
    
    % Add title and axis
    xlabel('Wavenumber');ylabel('Partial Sum of Energy');
    if export
        title(['Energy Spectrum for n = ' int2str(n) ' at time ' int2str(t)])
    end
    
    % Export to newfn if desired
    if export
        imwrite(frame2im(getframe(f)),newfn);
    end
end
