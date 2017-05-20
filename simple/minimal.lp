
%%% Minimize the range of hashed values
maxhash(X) :- coef(A), mod(M), X = #max{ A*I\M:item(I) }.
minhash(X) :- coef(A), mod(M), X = #min{ A*I\M:item(I) }.
diff(X) :- maxhash(A), minhash(B), X = A-B.
#minimize{ X:diff(X) }.