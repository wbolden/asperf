
key(0..1).
key(56).
%key(342).
key(33).
key(124).
key(209..230).

%%%Create constants
%*
1 {const_bit(I,B,0..1)} 1 :- op(I,const),bit_index(B).
  


op(0, mod).

edge(0,1).
edge(0,2).

op(2, const).
op(1,mul).

edge(1,3).
edge(1,4).

op(3, key).
op(4, const).
*%

%*
op(0, mul).

edge(0,1).
edge(0,2).

op(1,key).
op(2,const).

key(5).

const_bit(2,2..7,0).
const_bit(2,1,1).
const_bit(2,0,0).
*%
%#show hash_bit/3.





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