%% Schur Complement reduction vs number of non-zero elements in matrix

%% Input data preparation
load('third_party/SuiteSparse/UFget/mat/HB/494_bus.mat')
A = Problem.A;

%% Vector of eliminated rows
reductions = (0:0.1:0.9) * length(A);
steps = [reductions(1) diff(reductions)];
nnz_vec = zeros(1,length(reductions));

%% Iteratively reduce more nodes

for k = 1:length(reductions)
    nodes_to_reduce = steps(k);
    if nodes_to_reduce > length(A)
        disp('Early exit')
        break 
    end
    for n = 1:nodes_to_reduce
        % May be vectorized? 
        % Schur complement is defined for arbitrary ports / internal nodes
        % Need a function to get ports for more than one internal one.
        a11 = find(A(:,n) ~= 0);
        A11 = A(a11,a11);
        A12 = A(a11,n);
        A21 = A(n,a11);
        A22 = A(n,n);
        A(a11,a11) = A11-(A12*inv(A22)*A21);
        A( n, : ) = [];
        A( :, n ) = [];
    end
    nnz_vec(k) = nnz(A)/numel(A);
    spy(A);
    snapnow;
end

%% Summary
% nnz/numel in fuction of reduction agressiveness
bar(reductions / length(Problem.A), nnz_vec);
title('Number of non-zero elements in function of count of reduced nodes')
ylabel('Percentaze of non-zero elements in matrix')
xlabel('Percentage of rows reduced from original matrix')
grid on;
