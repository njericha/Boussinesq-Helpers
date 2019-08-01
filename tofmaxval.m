function tmax = tofmaxval(ts,vals)
% tmax = tofmaxval(vals,ts)
% This function finds the time that the max value of vals occurs.
% Specifically, it finds the index such that the value of the array equals
% the max value of the array, and then returns the value of t at that
% index. Note this can return multiple tmax's if there are multiple global
% maximums.
tmax = ts(vals == max(vals));
end