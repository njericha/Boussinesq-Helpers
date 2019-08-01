% This script computes the partial and total potential enstrophies from
% the set of temperature and vorticity values created by boussinesq.F90

% Inputs
n = 1024; %gridsize
N = 1; % Brunt-Vaisala Frequency
beta = N^2;
bigtime = 5; %big time step, spacing of .ncf saved files

U = 0.4;  % characteristic velocity scale
L = 2*pi; % characteristic length scale
PV0 = U*beta/L; % find nondimentionalizing constant

% Auto set tmax based on N
if N==2, tmax = 500; elseif N==1.5, tmax = 400; elseif N==0.5, tmax = 265; else, tmax = 300; end
tmax=260;
ts = 90:bigtime:tmax;

%if n==1024,tmax=255; end %temp condition while 1024 is still running

% Create filename, N only needs to be stated when it is different than 1.
if N==1
    fnameN = '';
else
    fnameN = ['N' num2str(N)];
end
filename = ['results/toexport/PEn' int2str(n) fnameN];

% Load PV data if it exists, if not then compute it
if exist([filename '.mat'],'file')
    S = load([filename '.mat'],'PEs','ts','tmaxPE','V2','V3','V4');
    PEs=S.PEs; ts=S.ts; tmaxPE=S.tmaxPE; V2=S.V2; V3=S.V3; V4=S.V4;
else
    % Wave numbers
    k = [0:(n/2),(-(n/2)+1):-1];
    [KZ,KX,KY] = meshgrid(k,k,k);

    % prealocate
    PEs = zeros(1,length(ts));V2 = PEs;V3 = PEs;V4 = PEs;
    PV  = zeros(n,n,n);
    thx = zeros(n,n,n);thy = zeros(n,n,n);thz = zeros(n,n,n);
    zx  = zeros(n,n,n);zy  = zeros(n,n,n);zz  = zeros(n,n,n);
    PI1 = zeros(n,n,n);PI2 = zeros(n,n,n);

    tic
    % main loop
    for t = ts
        disp(['Calculating PE for t = ' int2str(t)])

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

        % Quadratic, cubic, and quartic potential enstrophy contributions
        idx = t/bigtime + 1;
        V2(idx)  = 0.5*mean(PI1.^2,'all');
        V3(idx)  =     mean(PI1.*PI2,'all');
        V4(idx)  = 0.5*mean(PI2.^2,'all');
    end
    toc

    % Total potential enstrophy
    PEs = V2 + V3 + V4;

    % find the time of max potential enstrophy, ignoring initial data point
    tmaxPE = tofmaxval(ts(2:end),PEs(2:end));

    % save potential enstrophy, times, and max time to a .mat file
    save(filename,...
          'PEs','ts','tmaxPE','n','beta','V2','V3','V4','PV0','N')
end
      
% nondimentionalize partial and total PE for plotting 
PEs = PEs/PV0;V2 = V2/PV0;V3 = V3/PV0;V4 = V4/PV0;

% plotting colours
red   = [1 0 0]*.9;
green = [0 1 0]*.9;
blue  = [0 0 1]*.9;
gray  = [1 1 1]*.6;
gold  = [1 .8 0];

% line width
lw = 2;

% set up figure and plot the partial and total portential enstrophy
f = figure;
set(f,'Position',[800, 100, 800, 800])
plot(ts,PEs,'Color',gray ,'DisplayName','Potential Enstrophy',   'LineWidth',lw);
hold on
plot(ts,V2 ,'Color',red  ,'DisplayName','V_{2}','LineStyle','--','LineWidth',lw);
plot(ts,V3 ,'Color',green,'DisplayName','V_{3}','LineStyle','-.','LineWidth',lw);
plot(ts,V4 ,'Color',blue ,'DisplayName','V_{4}','LineStyle',':' ,'LineWidth',lw);

% plot vertical line at max time and label it
ax = f.CurrentAxes;
h = line([tmaxPE tmaxPE],ax.YLim,'Color',gold,'LineStyle','--');
set(h,'DisplayName',['t = ' int2str(tmaxPE)])
hold off

% Add title, legend, and axis labels
title(['Potential Enstrophy' ' vs Time for (n,N) = (' int2str(n) ',' num2str(N) ')'])
leg = legend;leg.Location = 'northwest';
PElabel = ['Potential Enstrophy (nondimentionalized by PV_{0}=' num2str(PV0,'%.0e') ')'];
xlabel('Time');ylabel(PElabel);

% Save the figure
newfn =['results/toexport/Potential_Enstrophy_n' int2str(n) '_N' num2str(N) '.png'];
imwrite(frame2im(getframe(f)),newfn);