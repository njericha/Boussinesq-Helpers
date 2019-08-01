function [idx, kr] = getridx(n)
% idx = getridx(n)
% getridx returns a cell array idx where idx{r+1} is a list of indexes
% where the magintude of the wavenumber is r. The function checks if it has
% already computed idx for a given n and loads that if it so. Otherwise, it
% will compute and save idx. Note the formatting for idx is KZ,KX,KY which
% is the same format at fftn(ncfread('var.ncf')).
% The second argument kr is the list of possible wavenumber magnitudes
% which are the integers from 0 to floor(n/3).

filename = ['getridx/n' int2str(n)];
if exist([filename '.mat'],'file')
    S   = load([filename '.mat'],'idx','kr');
    idx = S.idx;
    kr  = S.kr;
else
    kmax = n/3; % maxwave number
    k = [0:(n/2),(-(n/2)+1):-1]; % all values of k in MATLAB ordering

    [KZ,KX,KY] = meshgrid(k,k,k);
    KR = round( (KX.^2 + KY.^2 + KZ.^2).^0.5 ); % radial wavenumber, rounded
    kr = 0:kmax;                    % range of radial wavenumbers needed
    idx = cell(floor(kmax) + 1, 1); % create a cell array
    tic
    for r = kr %store the indexes of each radial wavenumber in the cell array
        idx{r+1} = find(KR == r);
    end
    toc
    
    save(filename,'idx','kr')
end
    
end

