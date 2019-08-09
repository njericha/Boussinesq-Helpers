function h = showmtx(A)
% h = showmtx(A)
%
% Takes a matrix A and plots the min valued entries as gray, and the max
% value entries as green. Labels the width of the non zero entries and the
% entire matrix.

n = length(A);
k = [-n/2 n/2];

h = imagesc(k,k,A);
ax=gca;
pos = get(ax, 'Position');
ax.YDir = 'normal';
cmp = [0 0   0 %black
       0 0.5 0 %dark green for middle values
       0 1   0]; %green
colormap(cmp)
h.AlphaData = .6; %softens colours


Start = [-n/3 , n/3]; % x, y
End   = [n/3  , n/3]; % x, y
annotation('doublearrow',...
    [(Start(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1),...
     (End(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1) ],... 
    [(Start(2) - min(ylim))/diff(ylim) * pos(4) + pos(2),...
     (End(2) - min(ylim))/diff(ylim) * pos(4) + pos(2)]);
text(0,n/3-20,['n_{old} = ' num2str(n/3*2,'%.0f')])

Start = [-n/2 , n/3-50]; % x, y
End   = [n/2  , n/3-50]; % x, y
annotation('doublearrow',...
    [(Start(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1),...
     (End(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1) ],... 
    [(Start(2) - min(ylim))/diff(ylim) * pos(4) + pos(2),...
     (End(2) - min(ylim))/diff(ylim) * pos(4) + pos(2)]);
text(0,n/3-70,['n_{new} = ' num2str(n,'%.0f')])

Start = [0 , 0]; % x, y
End   = [2^(-1/2)  , 2^(-1/2)] *n/6; % x, y
ant = annotation('textarrow',...
    [(Start(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1),...
     (End(1) + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1) ],... 
    [(Start(2) - min(ylim))/diff(ylim) * pos(4) + pos(2),...
     (End(2) - min(ylim))/diff(ylim) * pos(4) + pos(2)],'String',num2str(n/6,'%.1f'));
 
viscircles([0,0],n/6,'color',[0 0.5 0])


p = [170 170];
q = [160 -1];

hold on
plot([p(1) q(1)],[p(2) q(2)], 'o','MarkerSize',8,'MarkerFaceColor','w');


r = p + q;
r = mod(r+n/2,n)-n/2;
plot(r(1),r(2), '*','MarkerSize',8,'MarkerFaceColor','w');
hold off

end

