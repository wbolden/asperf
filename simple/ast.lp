
#const corange = 10.
constant(1..corange).
%input(1..5).


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


%%%{op(I,xor,V1^V2)} :- edge(I,C1), edge(I,C2), C1!=C2, op(C1,T1,V1), op(C2,T2,V2).
%%%{op(I,and,V1&V2)} :- edge(I,C1), edge(I,C2), C1!=C2, op(C1,T1,V1), op(C2,T2,V2). 
%%%{op(I,neg,~V1)}    :- edge(I,C1), unary(I), op(C1,T,V1).
%%%{op(I,input,V1)}  :- leaf(I), input(V1).
    
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
    


%side(left;right).
    
%eval(and,)
  
val(K,I,V1&V2) :- op(I,and),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,V1), val(K,I1,V2).
val(K,I,V1^V2) :- op(I,xor),edge(I,I1),edge(I,I2),I1 < I2, val(K,I1,V1), val(K,I1,V2).
val(K,I,~V1) :- op(I,neg),edge(I,I1), val(K,I1,V1).
val(K,I,V) :- key(K), op(I,const), constant(V).
val(K,I,K) :- key(K), op(I,key).

hash(K,V) :- val(K,0,V).

occupied(V) :- hash(K,V).
collision :- occupied(V), 2 {hash(K,V)}.

:- collision.
    
%%%collision :- key(K1), key(K2), K1!=K2, hash(K1,V), hash(K2,V).
%%%collision :- key(K1), key(K2), 0 = #sum {2**B,v}
    
%%% Visualization rules

#show children(I,N) : node(I), N = #count{C:edge(I,C)}.
#show op_count(I, X) : node(I), X = #count{T:op(I,T),type(T)}.
    
#show edge/2.
#show op/2.
#show node/2.
%#show edge/1.
%#show op/3.
%#show cnt/2.
%#show children/2.