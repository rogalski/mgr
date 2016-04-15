function [ varargin ] = input_for_circuit_composite_info( red_out )
%CREATE_DUMP_INPUT Creates varargin for dump functions

varargin = cell(2*red_out.conn_components_count, 1);
for k=1:red_out.conn_components_count
    varargin{2*k-1} = red_out.subdata{k}.G;
    varargin{2*k-0} = red_out.subdata{k}.is_ext_node;
end
end

