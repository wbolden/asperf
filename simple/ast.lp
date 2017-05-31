
#const corange = 100.
bit(0;1).
%constant(1..corange).
%input(1..5).

#const bits=4.

bit_index(0..bits-1).


input(X) :- key(X).
input(X) :- constant(X).


id(0..10).

 
rooted(0).
rooted(B) :- rooted(A), edge(A,B).
:- node(B), not rooted(B).



%%% Each edge has 0-2 children and is connected to the root
%%% Childen have greater ids than their parents
0 { edge(A,B):id(B),B>A} 2 :- rooted(A).

%%% Children cant have multiple parents
%%% It might actually be useful to allow this, so not really an AST anymore
%%% :- id(I), not 0 #sum{1,P:edge(P,I)} 1.
          
%%% TODO:
% All subdags contain at least one key item if the head of the tree is an operation
%%%

    
node(I) :- rooted(I).
binary(I) :- node(I), 2{edge(I,C)}2.
unary(I) :- node(I), 1{edge(I,C)}1.
leaf(I) :- node(I), 0{edge(I,C)}0.
      
bin_op(xor;and).
un_op(neg).
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

%side(left;right).
    
%eval(and,)

%%%Evaluate the tree, (Key, Id, Bit, Value)


%val(K,I,V1-V2) :- op(I,sub),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,V1), val(K,I1,V2).
%val(K,I,V1\V2) :- V2!=0, op(I,mod),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,V1), val(K,I1,V2).
%val(K,I,0) :- V2=0, op(I,mod),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,V1), val(K,I1,V2).

val_bit(K,I,B,V1&V2) :- op(I,and),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,B,V1), val(K,I1,B,V2).
val_bit(K,I,B,V1^V2) :- op(I,xor),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,B,V1), val(K,I1,B,V2).
val_bit(K,I,B,1-V1) :- op(I,neg),edge(I,I1),val(K,I1,B,V1).
val_bit(K,I,B,V) :- key(K), op(I,const), const_bit(I,B,V).
val_bit(K,I,B,V) :- key_bit(K,B,V), op(I,key).

hash(K,B,V) :- val(K,0,B,V).

%occupied(B,V) :- hash(K,B,V).
%collision :- occupied(V), 2 {hash(K,V)}.

%
    
%%%collision :- key(K1), key(K2), K1!=K2, hash(K1,V), hash(K2,V).
    
%%% Maybe we can use a custom theory progagator for to ignore quagratic cost here
collision(K1,K2) :- 
    key(K1), 
    key(K2), 
    K1 < K2, 
    0 = #sum {V*2**B,v1:hash(K1,B,V); -V*2**B,v2:hash(K2,B,V)}.
:- collision(K1,K2).
    
%:- hash(K,V), V >100.
%:- hash(K,V), V < 0.
    
%#minimize{V:node(V)}.
    
%%% Visualization rules

%#show children(I,N) : node(I), N = #count{C:edge(I,C)}.
%#show op_count(I, X) : node(I), X = #count{T:op(I,T),type(T)}.
    
#show hash/2.
#show key/1.
#show edge/2.
#show op/2.
%#show edge/1.
%#show op/3.
%#show cnt/2.
%#show children/2.