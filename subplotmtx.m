% Create a 'subplot matrix' of a given variable at a given time for
% multiple gridsizes.

% Inputs
%ns = [160 180 192 200 256];
ns = [512 320]; %currently only handles length(ns)<=5. See subplot(2,3,i)
varname='ZY';
t=235;
xyaxis='xz';
zslice=0;
fourier = 0;
cmax = 5; %max value that the colorbar can display
cmin = -5;%-cmax;
export = 0; %export = 1 will save an image of the plot

% Plottsing Settup
if fourier
    f = 'Fourier Transform of ';
else
    f = '';
end
fig = figure;
figname = [varname ' at time ' int2str(t)];
sgtitle([f figname ' for various n' ' at y = ' int2str(zslice)])
set(fig,'Position',[700, 100, 1200, 800])

mtxpos = {[3 5 7],[4 6 8]};

% Plotting Loop
[~,imax] = size(ns);
for i = 1:imax
    n = ns(i);
    subplot(4,2,mtxpos{i}); %edit if different matrix size is desired
    if fourier
        ncfplot(varname,t,n,xyaxis,zslice,'fourier','interp');
    else
        ncfplot(varname,t,n,xyaxis,zslice);
    end
    title(['n = ' int2str(n)])
    caxis([cmin cmax])
    pbaspect([1 1 1])
end

% Plotting settings and colorbar
h=subplot(4,2,[1 2]);%imax + 1); %edit if different matrix size is desired
%p=h.Position;
caxis([cmin cmax])
c = colorbar;
c.Location = 'southoutside';
p=c.Position;
c.Position = [p(1) p(2) p(3) p(4)*5];%[p(1)+p(3)/3 p(2) p(3)/3 p(4)];
c.Label.String = 'Y Component of Vorticity';
c.Label.FontSize = 12;
set(h,'Visible','off')

% export code
if export
    if fourier
        f = 'fft_';
    else
        f = '';
    end
    maxn = int2str(max(ns));
    newfn = ['results/' 'maxn' maxn '_' f replace(figname,' ','_') ...
             '_y' int2str(zslice) '.png'];
    imwrite(frame2im(getframe(fig)),newfn);close(fig);
end