% Remove empty nodes
comp_nodes = O1Components==O1_C_ID;
n = length(nonzeros(comp_nodes));
subC = spalloc(n, n, n*200);
subC(:,:) = O1(comp_nodes, comp_nodes);
% Re-map terminals
subCTerminalsMask = zeros(1, length(O1Terminals));
subCTerminalsMask(O1Terminals) = 1;
subCTerminalsMask(O1Components~=O1_C_ID) = [];
subCTerminals = find(subCTerminalsMask);
