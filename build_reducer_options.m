function options = build_reducer_options(options)
%BUILD_REDUCER_OPTIONS Fills options structure with default data if some
%options are missing.
%
% See also REDUCER.

if ~isfield(options, 'verbose')
    options.verbose = 0;
end

if ~isfield(options, 'auto_save')
    options.auto_save = 0;
end

if options.auto_save && ~isfield(options, 'output_file')
    options.output_file = ['reducer_' datestr(datetime, 30) '.mat'];
end

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
    case 'amd_dummy'
        options.nodewise_algorithm = @nodewise_amd_dummy;
    case 'amd_recursive'
        options.nodewise_algorithm = @nodewise_amd_recursive;
    case 'camd'
        options.nodewise_algorithm = @nodewise_camd;
    case 'nesdis_dummy'
        options.nodewise_algorithm = @nodeelim_nesdis_dummy;
    case 'nesdis_camd'
        options.nodewise_algorithm = @nodeelim_nesdis_camd;
    otherwise
        options.nodewise_algorithm = @nodewise_camd;
end

if ~isfield(options, 'cost_function')
    options.cost_function = @count_resistors;
end

if ~isfield(options, 'early_exit')
    options.early_exit = 0;
end

end
