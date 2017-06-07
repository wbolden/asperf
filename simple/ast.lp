
bit(0;1).

#const bits=8.
#const max_index = 30.

bit_index(0..bits-1).

id(0..10).

rooted(0).
rooted(B) :- rooted(A), edge(A,B).
:- node(B), not rooted(B).

%%% Each node has 0-2 children and is connected to the root
%%% Childen have greater ids than their parents
0 {edge(A,B):id(B),B>A} 2 :- rooted(A).

%%% Children cant have multiple parents
%%% It might actually be useful to allow this, so not really an AST anymore
%%% :- id(I), not 0 #sum{1,P:edge(P,I)} 1.
          
%%% TODO:
% All subdags contain at least one key item if the head of the tree is an operation
% This is just an optimization and shouldnt affect the final answer (assuming we tell it to find optimal)
%%%

node(I) :- rooted(I).
binary(I) :- node(I), 2{edge(I,C)}2.
unary(I) :- node(I), 1{edge(I,C)}1.
leaf(I) :- node(I), 0{edge(I,C)}0.
      
multiplier(mul13;mul7;mul5).
        
bin_op(xor;and;mod;mul;sub).
% bin_op(xor;and).
un_op(mul13;mul7;mul5;neg).
null_op(const;key).

type(T) :- bin_op(T).
type(T) :- un_op(T).
type(T) :- null_op(T).
    
%%%Choose one operation for each node

1{op(I, T):bin_op(T)}1 :- binary(I).
1{op(I, T):un_op(T)}1 :- unary(I).
1{op(I, T):null_op(T)}1 :- leaf(I).
    

%%%Create constants
1 {const_bit(I,B,0..1)} 1 :- op(I,const),bit_index(B).

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

2{input_signal(I,K,P1,B,V1);input_signal(I,K,P2,B,V2)}2 :-
    op(I,D),
    edge(I,I1),
    edge(I,I2),
    I1 < I2,
    %left_input(P1),
    %right_input(P2),
    device_port_direction(D,P1,input,C1),
    device_port_direction(D,P2,input,C2),
    C1 < C2,
    val_bit(K,I1,B,V1),
    val_bit(K,I2,B,V2).
    
val_bit(K,I,B,V) :- output_signal(I,K,B,V).

% get hash bit from node 0
hash_bit(K,B,V) :- val_bit(K,0,B,V).

% add up the hash bits for each key
hash_val(K,H) :- key(K), H = #sum{V*2**B:hash_bit(K,B,V)}.
    
:- hash_val(K,H), H > max_index.
    
%occupied(B,V) :- hash(K,B,V).
%collision :- occupied(V), 2 {hash(K,V)}.
    
%%%collision :- key(K1), key(K2), K1!=K2, hash(K1,V), hash(K2,V).
    
%%% Maybe we can use a custom theory progagator to ignore quagratic cost here
collision(K1,K2) :- 
    key(K1), 
    key(K2), 
    K1 < K2, 
    0 = #sum {V*2**B,v1:hash_bit(K1,B,V); -V*2**B,v2:hash_bit(K2,B,V)}.
    
:- collision(K1,K2).
    
%#minimize{V:node(V)}.
    
%%% Visualization rules

%#show children(I,N) : node(I), N = #count{C:edge(I,C)}.
%#show op_count(I, X) : node(I), X = #count{T:op(I,T),type(T)}.
    
%#show hash_bit/3.
%#show key/1.
#show edge/2.
#show op/2.
#show hash_val/2.