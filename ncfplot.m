function h = ncfplot(var,t,n,xyaxis,zslice,varargin)
% h = ncfplot(var,time,n,xyaxis,zslice,newfn)
%
% This creates a physical space plot of the variable var at time t and
% gridsize n. The plot is fourier interpolated up to the nearest power of
% 2. The plot is a slice along the direction given my xyaxis, at a depth of
% zslice.
%
% Example,
% h = ncfplot('ZY',150,200,'xy',100)
% This will plot the Y component of the vorticity at time 150 for n=200.
% The section plotted is the xy plane through z=100.
% 
% Optional arguments
% ncfplot(__,'interp') will interpolate the data by scaling it up to the
%                      nearest power of 2
% ncfplot(__,'fourier') will show the fourier transform of the data rather
%                       than the physical space
% ncfplot(__,'export','filename.png') will export the plot to filename.png
    
    % Optional arguments parsing    
    interp  = 0;
    fourier = 0;
    export  = 0;
    Nexist  = 0;
    idxs = find(cellfun(@ischar,varargin));    
    for idx = idxs
        interp  = interp  || strcmp(varargin{idx},'interp');
        fourier = fourier || strcmp(varargin{idx},'fourier');
        export  = export  || strcmp(varargin{idx},'export');
        Nexist  = Nexist  || strcmp(varargin{idx},'N');
    end
    
    % defines N if it is given, otherwise it is 1
    if Nexist
        N = varargin{cellfun(@isnumeric,varargin)};
    else
        N = 1;
    end
    
    % Find the filename and set up a new figure if exporting is desired
    if export
        fnstrLoc = find(strcmpi(varargin,'export'));
        filename = varargin{fnstrLoc(1)+1};
        f = figure;
        set(f,'Position',[800, 100, 800, 800])
    end
    
    % Open data as a 3D array
    data = ncfopen(var,t,n,N);
    
    % Create a slice of the 3D array
    plane = slice3d(data,xyaxis,zslice);
    
    % scale up plane to the closest power of 2 above n if interpolating
    if interp
        n = 2^ceil(log2(n));
        plane = fourierinterp(plane,n);
    end
    
    % Setup plotting axis
    xlab = xyaxis(1);ylab = xyaxis(2);
    Xs = 0:2*pi/(n-1):2*pi; Ys = Xs;
    
    % Fourier transform the data, relabel axis
    if fourier
        plane = abs(fftshift(fft2(plane)));
        xlab = ['k' xlab];ylab = ['k' ylab];
        Xs = -n/2+1:n/2; Ys = Xs;
    end

    % Plot. Note the transposition ensures the xaxis (which is stored
    % in the first column of the 2d array) is displayed as the first row
    % horizontally.
    h=pcolor(Xs,Ys,plane');set(h,'EdgeColor','none')
    xlabel(xlab);ylabel(ylab);
    
    % Export to newfn if desired
    if export
        title([var 'for n = ' int2str(n) ' at time ' int2str(t)])
        imwrite(frame2im(getframe(f)),filename);
    end
end
