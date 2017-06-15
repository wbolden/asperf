
bit(0;1).

#const bits=16.
#const nodes=5.
%#const max_index = 4.

bits(bits).

bit_index(0..bits-1).

id(0..nodes-1).

rooted(0).
rooted(B) :- rooted(A), edge(A,B).
node(I) :- rooted(I).