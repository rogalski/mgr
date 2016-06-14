function reducer_warmup( options )
    N = 8;
    G = gallery('tridiag', N, -1, 2, -1);
    G(1,1) = 1;
    G(N,N) = 1;
    is_ext_node = [1 zeros(1, N-2) 1]';
    reducer(G, is_ext_node, options);
end
