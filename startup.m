% add third-party functions to search path
addpath third_party/matlab_bgl
addpath third_party/SuiteSparse/CAMD/MATLAB
addpath third_party/SuiteSparse/CHOLMOD/MATLAB
addpath third_party/triconnected-components

% turn off common (expected) warnings
warning('off', 'MATLAB:MKDIR:DirectoryExists')
