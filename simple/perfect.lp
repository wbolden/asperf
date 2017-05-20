
%%% Attempts to perfectly hash keys given as item(number)

#const mod_range = 100.
#const coef_range = 100.

%%% Choose a modulus and coefficient
1 {mod(1..mod_range)} 1.
1 {coef(1..coef_range)} 1.

%%% Reject collisions
:- coef(A), mod(M), item(I1), item(I2),  I1 != I2,  A*I1\M = A*I2\M.