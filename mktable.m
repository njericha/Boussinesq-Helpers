% A rough idea I had to creates a table of data that other functions or 
% scripts can reference. This would be used to record things like breaking
% time, max turbulence, and viscosity used for each run.
% For example, you could load the file and use T{'n512N1','tmax'} to obtain
% how long the n512N1 was run for


% Row names
rnames = {'n512N1';'n384N1';'n360N1'};%,...
         % 'n256N1';'n240'};

% List of variables
n = [512; 384; 360];
N = [1; 1; 1];
tmax = [300; 300; 300];

% Create table
T = table(n,N,tmax,...
        'RowNames',rnames);

% Save the table in a .mat file
save('data','T');

