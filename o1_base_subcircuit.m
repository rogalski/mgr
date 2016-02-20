% Remove empty nodes
subC = O1(O1Components==O1_C_ID, O1Components==O1_C_ID);

% Re-map terminals
subCTerminalsMask = zeros(1, length(O1Terminals));
subCTerminalsMask(O1Terminals) = 1;
subCTerminalsMask(O1Components~=O1_C_ID) = [];
subCTerminals = find(subCTerminalsMask);
