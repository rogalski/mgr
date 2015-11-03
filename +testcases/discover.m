function [ tcs ] = discover(directory)
% TODO: pass tuple and invoke spice
% circuits = dir(fullfile(directory, '*.cir'));
matrices = dir(fullfile(directory, '*.m'));
tcs = arrayfun(@(x) fullfile(directory, x.name), matrices, 'UniformOutput', false);
end
