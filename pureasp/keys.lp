
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