load(['circuits/rommes/' CIRCUIT_NAME '.mat'], 'G', 'A', 'isextnode')
ExtNodes = find(isextnode);
IsExtNode = isextnode;
clear isextnode;
