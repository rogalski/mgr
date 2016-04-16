function [ varargin ] = input_for_dump( red_out )
%CREATE_DUMP_INPUT Creates varargin for dump functions

varargin = cell(3*red_out.conn_components_count, 1);
for k=1:red_out.conn_components_count
    varargin{3*k-2} = red_out.c{k}.G;
    varargin{3*k-1} = red_out.c{k}.is_ext_node;
    varargin{3*k-0} = red_out.c{k}.new_nodes;
end
end

