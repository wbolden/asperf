
binary(I) :- node(I), 2{edge(I,C)}2.
unary(I) :- node(I), 1{edge(I,C)}1.
leaf(I) :- node(I), 0{edge(I,C)}0.
      
bin_op(xor;and;mod;mul).
un_op(neg). %shr4
null_op(const;key).

type(T) :- bin_op(T).
type(T) :- un_op(T).
type(T) :- null_op(T).
    


%%%Evaluate the dag, (Key, Id, Bit, Value)

%%% Basic operations (and,xor,neg,const,key)

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
    key(K), 
    op(I,const), 
    const_bit(I,B,V).
    
val_bit(K,I,B,V) :- 
    key_bit(K,B,V), 
    op(I,key).
    
%%% Advanced operations (mul,shl,shr,mod,div,add,sub), need yosys circuits
input_signal(I,K,P,B,V1) :- 
    op(I,D),
    unary(D),
    edge(I,I1),
    val_bit(K,I1,B,V1),
    device_port_direction(D,P,input,C).

left_edge(I,I1) :- edge(I,I1), edge(I,I2), I1 < I2.
    
right_edge(I,I2) :- edge(I,I1), edge(I,I2), I1 < I2.
    
left_port(D,P1) :-
    device_port_direction(D,P1,input,C1),
    device_port_direction(D,P2,input,C2),
    C1 < C2.

right_port(D,P2) :-
    device_port_direction(D,P1,input,C1),
    device_port_direction(D,P2,input,C2),
    C1 < C2.
    
input_signal(I,K,P,B,V) :-
    op(I,D),
    left_edge(I,I1),
    left_port(D,P),
    val_bit(K,I1,B,V).

input_signal(I,K,P,B,V) :-
    op(I,D),
    right_edge(I,I2),
    right_port(D,P),
    val_bit(K,I2,B,V).
    
    
val_bit(K,I,B,V) :- output_signal(I,K,B,V).
    
%%Cant mod 0
:- right_edge(I,I1), op(I,mod), key(K), 0 #sum{V*2**B:val_bit(K,I1,B,V)} 0.

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
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%% Visualization rules
#show edge/2.
#show op/2.
    
1 { worst_key(K):key(K)} 1.
:- worst_key(K1), key(K2), 1 #sum{ -V*2**B,k1:hash_bit(K1,B,V);  V*2**B,k2:hash_bit(K2,B,V)}.
   
    
#minimize{ V*2**B@2,K:hash_bit(K,B,V),worst_key(K)}.
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
        if op == "mod":
            succ = D.successors(node)
            succ.sort()
            print("    int i%s = i%s %s i%s;" % (node, succ[0], "%", succ[1]))
        if op == "mul":
            succ = D.successors(node)
            succ.sort()
            mask = 2**bits-1
            print("    int i%s = %s & (i%s * i%s);" % (node, mask, succ[0], succ[1]))
        if op == "sub":
            succ = D.successors(node)
            succ.sort()
            mask = 2**bits-1
            print("    int i%s = %s & (i%s - i%s);" % (node, mask, succ[0], succ[1]))

        if node == 0:
            print("    return i0;")



    print("}")
    for pair in hashes.items():
        print("hash(%d) = %d" % pair)
    #for pair in constants.items():
    #    print("constant(%d) = %d" % pair)

#end.