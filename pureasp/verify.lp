
binary(I) :- node(I), 2{edge(I,C)}2.
unary(I) :- node(I), 1{edge(I,C)}1.
leaf(I) :- node(I), 0{edge(I,C)}0.
      
        
%bin_op(xor;and;mod;mul;sub).
%bin_op(xor;and;mod;mul;sub).
bin_op(xor;and;shrmod).
%un_op(mul13;mul7;mul5;neg).
un_op(neg). %shr4
null_op(const;key).

type(T) :- bin_op(T).
type(T) :- un_op(T).
type(T) :- null_op(T).
    


%%%Evaluate the dag, (Key, Id, Bit, Value)

%%% Basic operations (and,xor,neg,const,key)

val_bit(K,I,B,V1?V2) :- 
    op(I,or),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    val_bit(K,I1,B,V1), 
    val_bit(K,I2,B,V2).


val_bit(K,I,B,V1&V2) :- 
    op(I,and),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    val_bit(K,I1,B,V1), 
    val_bit(K,I2,B,V2).
    
val_bit(K,I,B,V1^V2) :- 
    op(I,xor),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    val_bit(K,I1,B,V1), 
    val_bit(K,I2,B,V2).

val_bit(K,I,B,1-V1) :- 
    op(I,neg),
    edge(I,I1),
    val_bit(K,I1,B,V1).

val_bit(K,I,B,V) :-
    op(I, rot8),
    bit_index(B),
    edge(I,I1),
    val_bit(K,I1,(B+8)\bits,V).


val_bit(K,I,B,V) :-
    op(I, rot),
    bit_index(B),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    S = #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2)},
    val_bit(K,I1,(B+S)\bits,V).


val_bit(K,I,B,0) :-
    op(I, shrmod),
    bit_index(B),
    key(K),
    right_edge(I,I2),
    bits #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2); B,n: #true }.

val_bit(K,I,B,V) :-
    op(I, shrmod),
    bit_index(B),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    S = #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2)},
        #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2); B,n: #true} bits-1,
    val_bit(K,I1,B+S,V).


%*
/*
val_bit(K,I,B,0) :-
    op(I, shr),
    bit_index(B),
    key(K),
    right_edge(I,I2),
    1 #sum{ V2*2**B2:val_bit(K,I2,B2,V2); -B,a: #true }.
    %B+1 #sum{ V2*2**B2:val_bit(K,I2,B2,V2) }. 
%    1 #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2); -B: #true }.

val_bit(K,I,B,V) :-
    op(I, shr),
    bit_index(B),
    edge(I,I1),
    edge(I,I2),
    I1 < I2, 
    S = #sum{ V2*2**B2:val_bit(K,I2,B2,V2), shift_range(B2)},
    %#sum{ V2*2**B2:val_bit(K,I2,B2,V2) } B, 
    #sum{ V2*2**B2:val_bit(K,I2,B2,V2); -B,a: #true } 0 , 
    val_bit(K,I1,B-S,V).
*/
*%
   
    
val_bit(K,I,B,1-V1) :- 
    op(I,neg),
    edge(I,I1),
    val_bit(K,I1,B,V1).
    
val_bit(K,I,B,V) :- 
    key(K), 
    op(I,const), 
    const_bit(I,B,V).
    
val_bit(K,I,B,V) :- 
    key_bit(K,B,V), 
    op(I,key).

left_edge(I,I1) :- edge(I,I1), edge(I,I2), I1 < I2.    
right_edge(I,I2) :- edge(I,I1), edge(I,I2), I1 < I2.
    
% get hash bit from node 0
hash_bit(K,B,V) :- val_bit(K,0,B,V).

hash_bit_agree(K1,K2,B) :- K1 < K2, hash_bit(K1,B,V), hash_bit(K2,B,V).
    
%%% Maybe we can use a custom theory progagator to ignore quagratic cost here
collision(K1,K2) :- 
    key(K1);
    key(K2); 
    hash_bit_agree(K1,K2,B):B=0..bits-1.
    %K1 < K2;
    %0 = #sum {V*2**B,v1:hash_bit(K1,B,V); -V*2**B,v2:hash_bit(K2,B,V)}.
    
:- collision(K1,K2).
    
%
    
%%% Visualization rules

%#show children(I,N) : node(I), N = #count{C:edge(I,C)}.
%#show op_count(I, X) : node(I), X = #count{T:op(I,T),type(T)}.
    
%#show hash_bit/3.
%#show key/1.
#show edge/2.
#show op/2.
%#show hash_val/2.

%:- key(K), 114 #sum{ V*2**B:hash_bit(K,B,V)}.

%*
1 { worst_key(K):key(K)} 1.
:- worst_key(K1), key(K2), 1 #sum{ -V*2**B,k1:hash_bit(K1,B,V);  V*2**B,k2:hash_bit(K2,B,V)}.
#minimize{ V*2**B@2,K:hash_bit(K,B,V),worst_key(K)}.
*%

#minimize{ V*2**B@2,K:hash_bit(K,B,V)}.

#minimize{1@1,V:node(V)}.

#script (python)
def main(prg):
    prg.ground([("base",[])])
    prg.solve(on_model=on_model)
    
import re
from collections import defaultdict
import networkx as nx 
import math

def on_model(model):
    hashes = defaultdict(int)
    constants = defaultdict(int)
    ops = {}
    bits = 0
    D = nx.DiGraph()

    for s in model.symbols(atoms=True):
        if s.name == "hash_bit":
            hashes[s.arguments[0].number] += s.arguments[2].number*2**s.arguments[1].number
        if s.name == "const_bit":
            constants[s.arguments[0].number] += s.arguments[2].number*2**s.arguments[1].number
        if s.name == "edge":
            D.add_edge(s.arguments[0].number, s.arguments[1].number)
        if s.name == "op":
            ops[s.arguments[0].number] = s.arguments[1].name
        if s.name == "bits":
            bits = s.arguments[0].number

    print("int phash(int key) {")
    for node in nx.topological_sort(D, reverse = True):
        op = str(ops[node])
        if op == "key":
            print("    int i%s = key;" % (node))
        if op == "const":
            print("    int i%s = %d;" % (node, constants[node]))
        if op == "neg":
            innode = D.successors(node)[0]
            mask = 2**bits-1
            print("    int i%s = %d & ~i%s;" % (node, mask, innode))
        if op == "and":
            succ = D.successors(node)
            print("    int i%s = i%s & i%s;" % (node, succ[0], succ[1]))
        if op == "xor":
            succ = D.successors(node)
            print("    int i%s = i%s ^ i%s;" % (node, succ[0], succ[1]))
        if op == "shrmod":
            succ = D.successors(node)
            succ.sort()
            mask = 2**math.floor(math.log(bits,2))-1;
            print("    int i%s = i%s >> (i%s & %s);" % (node, succ[0], succ[1], mask))

        if node == 0:
            print("    return i0;")



    print("}")
    for pair in hashes.items():
        print("hash(%d) = %d" % pair)
    #for pair in constants.items():
    #    print("constant(%d) = %d" % pair)

#end.