% This script computes the potential vorticity and potential enstrophy from
% the set of temperature and vorticity values created by boussinesq.F90

% Inputs
n = 512; %gridsize
beta = 1; %
bigtime = 5; %big time step, spacing of .ncf saved files
tmax = 300;
ts = 0:bigtime:tmax;

% Wave numbers
k = [0:(n/2),(-(n/2)+1):-1];
[KZ,KX,KY] = meshgrid(k,k,k);

% prealocate
PEs = zeros(1,tmax/bigtime+1);
PV  = zeros(n,n,n);
thx = zeros(n,n,n);thy = zeros(n,n,n);thz = zeros(n,n,n);
zx  = zeros(n,n,n);zy  = zeros(n,n,n);zz  = zeros(n,n,n);

tic
% main loop
for t = ts
disp(['Calculating PE for t = ' int2str(t)])

% open temperature
THfilename = mkfilepath(n,'TH',t);
th = ncread(THfilename,'TH');

% calculate derivatives
thx = real(ifftn(i*KX.*fftn(th))) ; % x derivative
thy = real(ifftn(i*KY.*fftn(th))) ; % y derivative
thz = real(ifftn(i*KZ.*fftn(th))) ; % z derivative

% open vorticity
ZXfilename = mkfilepath(n,'ZX',t);
ZYfilename = mkfilepath(n,'ZY',t);
ZZfilename = mkfilepath(n,'ZZ',t);
zx = ncread(ZXfilename,'ZX');
zy = ncread(ZYfilename,'ZY');
zz = ncread(ZZfilename,'ZZ');

% potential vorticity
PV = zx.*thx + zy.*thy + zz.*(beta+thz);

% potential enstrophy
idx = t/bigtime + 1;
PEs(idx) = 0.5/n^3 * sum(sum(sum(PV.^2)));
end
toc

% find the time of max potential enstrophy, ignoring initial data point
tmaxPE = tofmaxval(ts(2:end),PEs(2:end));

% save potential enstrophy, times, and max time to a .mat file
save(['results/toexport/PEn' int2str(n)],'PEs','ts','tmaxPE','n','beta')

% plotting colours
red =[1 0 0];
blue = [0 0 1];

% set up figure and plot PE
f = figure;
set(f,'Position',[800, 100, 800, 800])
h = plot(ts,PEs,'Color',blue);
set(h,'DisplayName','Potential Enstrophy')

% plot vertical line at max time and label it
hold on
ax = f.CurrentAxes;
h = line([tmaxPE tmaxPE],ax.YLim,'Color',red,'LineStyle','--');
set(h,'DisplayName',['t = ' int2str(tmaxPE)])
hold off

% Add title, legend, and axis labels
title(['Potential Enstrophy' ' vs Time for n = ' int2str(n)])
leg = legend;leg.Location = 'northwest';
xlabel('Time');ylabel('Potential Enstrophy');

% Save the figure
newfn =['results/toexport/Potential_Enstrophy_n' int2str(n) '.png'];
imwrite(frame2im(getframe(f)),newfn);