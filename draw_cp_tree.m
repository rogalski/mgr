function draw_cp_tree( cp, cmember )
treeplot(cp, 'o black', '- black');
hold on;
[x, y, h] = treelayout(cp);
for i=1:length(x)
    members = find(cmember==i);
    if length(members) > 10
        string = sprintf('%d nodes', length(members));
    else
        string = sprintf('%d, ', members);
        string = ['\{', string(1:end-2), '\}'];
    end
    text(x(i), y(i) - 0.02/h, string, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'FontSize', 12)
end
ylim([min(y) - 0.05, max(y) + 0.05]);
xlim([min(x) - 0.05, max(x) + 0.05]);
pbaspect([length(unique(x)), h, 1])
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
axis off
