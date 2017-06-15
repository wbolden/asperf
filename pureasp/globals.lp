
bit(0;1).

#const bits=16.
%#const max_index = 30.

bit_index(0..bits-1).

shift_bit_index(-bits..bits-1).

bits(bits).

shift_range(0..@logceil(bits)-1).


#script (python)
import math
def logceil(k):
    k = k.number
    return math.ceil(math.log(k,2))
#end.

id(0..6).

rooted(0).
rooted(B) :- rooted(A), edge(A,B).
node(I) :- rooted(I).