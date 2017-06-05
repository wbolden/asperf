
%%% Minimize the range of hashed values
maxhash(X) :- coef(A), mod(M), exp(E), X = #max{ @axbmodc(A,I,E,M):item(I) }.
minhash(X) :- coef(A), mod(M), exp(E), X = #min{ @axbmodc(A,I,E,M):item(I) }.
diff(X) :- maxhash(A), minhash(B), X = A-B.
#minimize{ X:diff(X) }.