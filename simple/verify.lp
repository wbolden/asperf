
binary(I) :- node(I), 2{edge(I,C)}2.
unary(I) :- node(I), 1{edge(I,C)}1.
leaf(I) :- node(I), 0{edge(I,C)}0.
      
        
%bin_op(xor;and;mod;mul;sub).
%bin_op(xor;and;mod;mul;sub).
bin_op(xor;and).
%un_op(mul13;mul7;mul5;neg).
un_op(neg;shr4).
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
    
% if there is a node multiplying by 13, set the appropriate bit as input
input_signal(I,K,P,B,V1) :- 
    op(I,D),
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

% get hash bit from node 0
hash_bit(K,B,V) :- val_bit(K,0,B,V).

% add up the hash bits for each key
%hash_val(K,H) :- key(K), H = #sum{V*2**B:hash_bit(K,B,V)}.
    
%%:- hash_val(K,H), H > max_index.
    
%occupied(B,V) :- hash(K,B,V).
%collision :- occupied(V), 2 {hash(K,V)}.
    
%%%collision :- key(K1), key(K2), K1!=K2, hash(K1,V), hash(K2,V).

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

    
1 { worst_key(K):key(K)} 1.
:- worst_key(K1), key(K2), 1 #sum{ -V*2**B,k1:hash_bit(K1,B,V);  V*2**B,k2:hash_bit(K2,B,V)}.
   
% ... there is some other K2 with a hash that is higher than this one.

    
#minimize{ V*2**B@2,K:hash_bit(K,B,V),worst_key(K)}.


%#minimize{ V*2**B@2,K:hash_bit(K,B,V)}.

#minimize{1@1,V:node(V)}.

#script (python)
def main(prg):
    prg.ground([("base",[])])
    prg.solve(on_model=on_model)
    
import re
from collections import defaultdict

def on_model(model):
    hashes = defaultdict(int)
    for s in model.symbols(atoms=True):
        if s.name == "hash_bit":
            hashes[s.arguments[0].number] += s.arguments[2].number*2**s.arguments[1].number
            

    for pair in hashes.items():
        print("hash(%d) = %d" % pair)
#end.