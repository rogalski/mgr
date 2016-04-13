function dump_terminals( handle, is_ext_node, node_ids )
fprintf(handle,'{ node [shape=rect] ');
for t=find(is_ext_node)
    fprintf(handle,'%i ', node_ids(t));
end
fprintf(handle, '}\n');
end
