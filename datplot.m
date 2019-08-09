function h = datplot(n,var,depvar,N,newfn)
% h = datplot(n,var,depvar,newfn)
%
% plotme takes n, the gridsize, var, the filename string, and depvar,
% the dependent variable column number in the .dat file of interest. It
% returns h, the handle for the plot. plotme optionaly takes a string
% newfn. It will then save the figure to that location. N can be optionaly
% given to open data that uses an N other than 1.

    export = exist('newfn','var'); %create flag to see if a new filename is given
    
    % Set up a new figure if exporting is desired
    if export
        f = figure;
        set(f,'Position',[800, 100, 800, 800])
    end
    
    % Open and plot data
    if ~exist('N','var')
        N=1; % Set defult N to 1 if N is not given
    end
    [ts,ys] = datopen(n,var,depvar,N);
    h = plot(ts,ys);
    
    % Add title and axis
    var(1) = upper(var(1)); % Capitalize the first letter of var
    ylab = [var '(' int2str(depvar) ')'];
    xlabel('Time');ylabel(ylab);
    if export
        title([ylab ' vs Time for (n,N) = (' int2str(n) ',' num2str(N) ')'])
    end
    
    % Export to newfn if desired
    if export
        imwrite(frame2im(getframe(f)),newfn);
    end
end
