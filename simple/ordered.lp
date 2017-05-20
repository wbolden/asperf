
%%% Reject if items are out of order when hashed
:- item(I1), item(I2), I1 < I2, coef(A), mod(M),  A*I1\M > A*I2\M.