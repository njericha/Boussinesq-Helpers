% Mini script to plot the total energy as a function of time for various N.
% Can also be used to plot epsilon.

%inputs
%n = 512;
%Ns = 2:-1:1;%2:-0.5:0.5;
var = 'eps'; % 'eng' or 'eps'
method = 'oscillation';
export = 0;
time = 'max'; %'break' or 'max'
smoothdata = 0;

if strcmp(var,'eng')
    depvar=4; titlestr = 'Total Energy';
elseif strcmp(var,'eps')
    depvar=2; titlestr = 'Epsilon';
else
    error('not a valid var')
end

f = figure;
set(f,'Position',[100, 100, 1900, 850])
hold on
for n = [256 512 1024]
    if     n==256
        Ns=[6 4 2 1.5 1 0.5 0.1];
    elseif n==512
        Ns=[2 1.5 1 0.5];
    elseif n==1024
        Ns=[2 1];
    else, error('');
    end
    
    for N=Ns
        [ts,ys] = datopen(n,var,depvar,N);
        
        if smoothdata, ys=fftsmooth(ys); end       
        
        h = plot(ts,ys);

        % Add title and axis
        varttl = var;
        varttl(1) = upper(var(1)); % Capitalize the first letter of var
        ylab = [varttl '(' int2str(depvar) ')'];
        xlabel('Time');ylabel(ylab);
        h.DisplayName=['n' int2str(n) 'N' num2str(N)];
        

        
        if strcmp(time,'break')
            tb = tofbreak(ts,ys,method);
        elseif strcmp(time,'max')
            tb = tofmaxval(ts,ys);
        else
            error('not a valid time')
        end
        
        tstr = num2str(tb,'%.1f');
        xline(tb,'--',tstr,'DisplayName',...
            ['t_{' int2str(n) ',' num2str(N) '} = ' tstr],...
            'Color',h.Color);
    end
end
hold off
grid on
grid minor


%title('Epsilon vs Time for n=256 and various N');
th = title([titlestr ' vs Time For Various n & N using method = ' method]);
th.FontSize = 14;
leg = legend;leg.Position = [0.7 0.4 0.2 0.4];
leg.NumColumns = 2;leg.FontSize = 12;
xlim([0 600])

if export
newfn =['results/toexport/' var '_variousnN_' method '.png'];
imwrite(frame2im(getframe(f)),newfn);
end