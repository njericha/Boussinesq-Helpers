function [ks,Ek] = spcopen(n,t,wavetype,N)
% [ks,Ek] = spcopen(n,t,wavetype)
%
% scpopen takes n, the gridsize, and t, the time. It returns the integer
% wavenumbers ks and the sum of energy of these ks, Eks.
% The optional argument wavetype can be '','h', or 'z'.
% '','s' = spherical (defult), 'h' = cylindrical, 'z' = rectangular
% Can optionaly provide N. Defult is N=1.
    
    % Defult N=1
    if ~exist('N','var')
        N=1;
    end

    % Wavetype variable checking
    if ~exist('wavetype','var')
        wavetype = '';
    end
    
    if ~ismember(wavetype,['' 's' 'h' 'z'])
        error("wavetype must be '','s','h', or 'z'")
    end
    
    if strcmp(wavetype,'s')
        wavetype = '';
    end
    

    % Derived Values
    idx = 10*t+1; % the "10" comes from the value tstop*nstop/nout = 3000/300 = 10 in param.F90
    var = ['spc' wavetype];
    filename = mkfilepath(n,var,t,N);

    % Open file
    data = fileread(filename);
    
    % Extract the correct block of data
    delim = '            \n            \n';
    blocks = strsplit(data,delim);
    block = blocks{idx};

    % Convert block to a 2D array
    A = str2num(block);

    % Extract the correct columns
    ks = A(:,1);
    Ek = A(:,2);

end