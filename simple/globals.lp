
bit(0;1).

#const bits=8.
#const max_index = 30.

bit_index(0..bits-1).

id(0..19).

rooted(0).
rooted(B) :- rooted(A), edge(A,B).
node(I) :- rooted(I).