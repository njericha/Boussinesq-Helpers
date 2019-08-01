% This script computes the potential vorticity and its spectrum at a given
% time from the set of temperature and vorticity values created by
% boussinesq.F90

% Inputs
n = 1024; %gridsize
t = 155;
N = 1; % Brunt-Vaisala Frequency
beta = N^2; % since aj*beta=N^2, but aj=1 is fixed
bigtime = 5; %big time step, spacing of .ncf saved files

% Wave numbers
k = [0:(n/2),(-(n/2)+1):-1];
[KZ,KX,KY] = meshgrid(k,k,k);

% Neatly list all the desired inputs as a string
vars = [n t N];
varsstr = strjoin(strsplit(num2str(vars)),', ');
titlestr = ['Potential Vorticity Spectrum for (n,t,N) = (' varsstr ')'];

disp(titlestr)

% Create filename, N only needs to be stated when it is different than 1.
if N==1
    fnameN = '';
else
    fnameN = ['_N' num2str(N)];
end
filename = ['results/toexport/PVn' int2str(n) '_t' int2str(t) fnameN];

% Load PV data if it exists, if not then compute it
if exist([filename],'file')
    disp(['Data loaded from' filename '.mat'])
    S = load([filename '.mat'],'t','n','PVk','kr');
    t=S.t; n=S.n; PVk=S.PVk; kr=S.kr;
else
    disp([filename '.mat' ' not found, calculating data'])
    
    % open temperature
    THfilename = mkfilepath(n,'TH',t,N);
    th = ncread(THfilename,'TH');

    % calculate derivatives
    thx = real(ifftn(i*KX.*fftn(th))) ; % x derivative
    thy = real(ifftn(i*KY.*fftn(th))) ; % y derivative
    thz = real(ifftn(i*KZ.*fftn(th))) ; % z derivative

    % open vorticity
    ZXfilename = mkfilepath(n,'ZX',t,N);
    ZYfilename = mkfilepath(n,'ZY',t,N);
    ZZfilename = mkfilepath(n,'ZZ',t,N);
    zx = ncread(ZXfilename,'ZX');
    zy = ncread(ZYfilename,'ZY');
    zz = ncread(ZZfilename,'ZZ');

    % potential vorticity parts
    PI1 = beta*zz;
    PI2 = zx.*thx + zy.*thy + zz.*thz;

    % potential vorticity
    PV = PI1 + PI2;

    [kr, PVk]=rsum(PV);

    % save partial and total potential vorticity and its spectrum to a .mat file
    save(filename,'PV','t','n','PI1','PI2','PVk','kr','N')
end

% custom plotting colours, given in RGB
blue  = [0 0 .9];
gold  = [1 .8 0];
green = [.5 .8 .5];

% set up figure and plot the partial and total portential enstrophy
f = figure;
set(f,'Position',[800, 100, 800, 800])
loglog(kr,PVk,'Color',blue,'DisplayName','Potential Enstrophy','LineWidth',1);
legend
hold on

% plot dissipation wavenumbers
[kdis, odis] = kolwavenum(n,t,'s',N);
kstr = num2str(kdis,'%.1f');
ostr = num2str(odis,'%.1f');
ax = f.CurrentAxes;
line([kdis kdis],ax.YLim,'Color',gold ,'LineStyle','--','DisplayName',['k_{dis} = ' kstr])
line([odis odis],ax.YLim,'Color',green,'LineStyle','-.','DisplayName',['o_{dis} = ' ostr])
hold off

% Add title, legend, and axis labels
title(titlestr);
leg = legend;leg.Location = 'northwest';
xlabel('$|\vec{k}|$','Interpreter','latex');
ylabel('Potential Vorticity Partial Sum');

% Save the figure
newfn =['results/toexport/PVspectrum_n' int2str(n) '_t' int2str(t) fnameN '.png'];
imwrite(frame2im(getframe(f)),newfn);