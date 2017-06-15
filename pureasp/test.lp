edge(0,1).
edge(0,2).

op(0, shr).
op(1, key).
op(2, const).

const_bit(2,0,1).
const_bit(2,1,1).
const_bit(2,2,1).

key(5). %101
key(4). %100

%should produce 0 for both and unsat

#script (python)
def bit_values(k,n):
    k = k.number
    n = n.number
    results = []
    for i in range(n):
        b = i
        v = 1 if (1<<i)&k else 0
        results.append((b,v))
    return results
#end.
key_bit(I,B,V) :- key(I), (B,V)=@bit_values(I,bits).

#show hash_bit/3.