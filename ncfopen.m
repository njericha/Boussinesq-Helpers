function data = ncfopen(var,t,n,N)
% data = ncfopen(var,t,n)
%
% Takes a variable name, a time, and a grid size, and extracts the data
% from the NetCDF file accociated with the three inputs. It returns a 3D
% array data corisponding to the variable at every (x,y,z) point.
% Example,
% temp = ncfopen('TH',126.1,256);
% temp(1,2,3) gives the temperture at (x,y,z,t)=(1,2,3,125) from the n=256
% simulation. Note the time is rounded to the nearest .ncf data point
% var can be 'TH','U','V','W','ZX','ZY','ZZ'
% t   can be any number between 0 to 300
% n   can be 168,180,192,200,240,256,320,360,384,480*,512
% *time must be less than 210 when n=480 since that run timed out
    
    % Make the file name
    if exist('N','var')
        fn = mkfilepath(n,var,t,N);
    else
        fn = mkfilepath(n,var,t);
    end    
    
    % Open file as a 3D array
    data = ncread(fn,var);
    
    % Swap coordinate axis since the Fortran code uses a different 
    % convention than matlab
    data = permute(data,[1 3 2]);
end
