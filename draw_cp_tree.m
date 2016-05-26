function draw_cp_tree( cp, cmember )
treeplot(cp);
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
axis off
