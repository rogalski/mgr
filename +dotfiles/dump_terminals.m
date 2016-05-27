function dump_terminals( handle, is_ext_node, node_ids )
if any(is_ext_node)
    fprintf(handle, '{ node [shape=doublecircle] ');
    for t=find(is_ext_node)
        fprintf(handle,'%i ', node_ids(t));
    end
    fprintf(handle, '}\n');
end
end
