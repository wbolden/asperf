
bit(0;1).

#const bits=20.
%#const max_index = 4.

bit_index(0..bits-1).

id(0..4).

rooted(0).
rooted(B) :- rooted(A), edge(A,B).
node(I) :- rooted(I).