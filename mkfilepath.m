function filepath = mkfilepath(n,var,t,N)
% filepath = mkfilepath(n,var,t,N)
%
% mkfilepath takes a gridsize n and a variable name var to return the
% file path string. If var is accociated with a .ncf file, a time must also
% be supplied. N can be optionaly given to find the path with a specific N.
% N=1 is assumed if N is not given.
    
    datvars  = {'eng','eps','epsij','spc','spch','spcz','trn','trnh','trnz'};
    ncfvars  = {'TH','U','V','W','ZX','ZY','ZZ'};
    morecode = '/home/njericha/morecode/';
    Nnot1 = exist('N','var') && N ~= 1;
	tbig = 5;
    
    if Nnot1
        if N==2 && n==1024, tbig=10;end
        if N==4, tbig=10;end
        if N==6, tbig=20;end
        if N==16,tbig=40;end
    end
    
    if ismember(var,datvars)
        fname = var;
        ext   = '.dat';    
    elseif ismember(var,ncfvars)
        % Check to make sure a time is supplied
        if ~exist('t','var')
            error('Must supply a time for .ncf files')
        end
        
        % .ncf files were not exported at every time. Find the file closest
        % to the desired time.
        bigtime = t/tbig;
        if rem(bigtime,1)~=0
            disp(['Note: ' var ' at time ' int2str(round(bigtime)*tbig) ...
                ' was used in place of ' num2str(t,'%.1f') ' for n=' int2str(n)])
        end
        
        % Find the associated file number
        bigtime = 1 + round(bigtime);
        
        % One digit numbers have a preceding zero in the file name
        if bigtime < 10
            zero = '0';
        else
            zero = '';
        end
        
        fname = [var '.' zero int2str(bigtime)];
        ext   = '.ncf';
    else
        error(['"' var '"is not a valid variable'])
    end
    
    % check if N is given and is different than 1 
    if Nnot1
        Nstr  = ['N' num2str(N)];
        extra = morecode;
    else      
        Nstr  = '';
        extra = '';
    end
    
    % Since the 1024 case is in a different folder, appened other folder
    % name
    if n==1024
        extra = morecode;
    end
    
    % main file path
    filepath = [extra 'n' int2str(n) Nstr '/' fname ext];
end

