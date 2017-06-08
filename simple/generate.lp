
%%% Each node has 0-2 children and is connected to the root
%%% Childen have greater ids than their parents
0 {edge(A,B):id(B),B>A} 2 :- rooted(A).
    
%%%Choose one operation for each node

1{op(I, T):bin_op(T)}1 :- binary(I).
1{op(I, T):un_op(T)}1 :- unary(I).
1{op(I, T):null_op(T)}1 :- leaf(I).
    

%%%Create constants
1 {const_bit(I,B,0..1)} 1 :- op(I,const),bit_index(B).

%%% Children cant have multiple parents
%%% It might actually be useful to allow this, so not really an AST anymore
%%% :- id(I), not 0 #sum{1,P:edge(P,I)} 1.
          
%%% TODO:
% All subdags contain at least one key item if the head of the tree is an operation
% This is just an optimization and shouldnt affect the final answer (assuming we tell it to find optimal)
%%%
