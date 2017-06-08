
key(0..1).
key(56).
%key(342).
key(33).
key(124).
key(209..251).

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


%1 { worst_key(K):key(K)} 1.
%:- worst_key(K), ... there is some other K2 with a hash that is higher than this one.



key_bit(I,B,V) :- key(I), (B,V)=@bit_values(I,bits).