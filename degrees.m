function result = degrees( A )
%DEGREES Returns degrees for each node of adjacency graph
result = sum(A~=0, 2);
end
