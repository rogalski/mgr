function [ mask ] = to_mask( positions, length)
%TO_MASK Converts [1, 4, 5], 6 to [1, 0, 0, 1, 1, 0]
mask = zeros(1, length);
mask(positions) = 1;
end
