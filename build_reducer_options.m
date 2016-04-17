function options = build_reducer_options(options)
%BUILD_REDUCER_OPTIONS Fills options structure with default data if some
%options are missing.
%
% See also REDUCER.

if ~isfield(options, 'graph_algorithm')
    options.graph_algorithm = '';
end
switch options.graph_algorithm
    case 'none'
        options.graph_algorithm = @graph_reduce_empty;
    otherwise
        options.graph_algorithm = @graph_reduce;
end

if ~isfield(options, 'nodewise_algorithm')
    options.nodewise_algorithm = '';
end
switch options.nodewise_algorithm
    case 'none'
        options.nodewise_algorithm = @nodewise_empty;
    case 'dummy'
        options.nodewise_algorithm = @nodewise_dummy;
    case 'nesdis'
        options.nodewise_algorithm = @nodewise_nesdis_dummy;
    case 'metis'
        options.nodewise_algorithm = @nodewise_metis_dummy;
    case 'amd_dummy'
        options.nodewise_algorithm = @nodewise_amd_dummy;
    case 'amd_recursive'
        options.nodewise_algorithm = @nodewise_amd_recursive;
    otherwise
        options.nodewise_algorithm = @nodewise_camd;
end
end