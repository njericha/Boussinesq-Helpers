function [kdis, varargout] = kolwavenum(n,t,wavetype,N)
% kdis = kolwavenum(n,t,wavetype)
%
% Calculates the Kolmogorov Dissipation Wave Number for a given data set.
% n is the gridsize and t is the time.
% The optional argument wavetype can be '','h', or 'z'.
% '','s' = spherical (defult), 'h' = cylindrical, 'z' = rectangular
%
% ------------------------------- OR ------------------------------------
%
% [kdis,odis] = kolwavenum(n,t,wavetype,N)
% 
% Returns kdis as described above, and returns the "other dissipation"
% wave number odis which is calculated by creating a 1/Length unit from N,
% the boyency frequency, and epsilon which is calculated. If N is not
% supplied, N=1 is assumed.


    % Automaticly sets initial condition based on the simulations ran in
    % the 2019 summer research term for convinence.
    if n <= 128
        error('n <= 128 runs have not been calculated')
    elseif n <= 256
        ilap = 2; %hyperviscosity order. 1 is regular, 2 is bilaplacian
        mu   = 2e-7;
    elseif n <= 512
        ilap = 1;
        mu   = 1.5e-4;
    elseif n <= 1024
        ilap = 1;
        mu   = 5.95e-5;
    else
        error('n >=1024 runs have not been calculated')
    end
    
    root = 1/(6*ilap-2); %root that must be taken to ensure the right units
    
    % Open spectrum
    if exist('wavetype','var')
        [ks,Ek] = spcopen(n,t,wavetype);
    else
        [ks,Ek] = spcopen(n,t);
    end
    
    % Calculate Kenetic Energy dissipation rate
    eps = 2*mu*sum(ks.^(2*ilap).*Ek);
    
    % Calculate Kolmogorov Dissipation Wave Number
    kdis = (eps/mu^3)^root;
    
    % Checking if a second output is required
    if nargout == 1
        return
    elseif nargout == 2
        if ~exist('N','var')
            N=1;
        end
        % Calculate Other Dissipation Waver Number
        odis = (N^3/eps)^0.5;
        varargout{1} = odis;
    else
        error('Number of outputs must be 1 or 2')
    end
    
end