
#const corange = 10.
constant(1..corange).
%input(1..5).


input(X) :- item(X).
input(X) :- constant(X).


id(0..10).

%%% piece(id,child_id).
3 {piece(I,C):id(I),id(C)}.

%%% All pieces have 0-2 children
:- piece(I,_), not 0 #sum{1,C:piece(I,C)} 2.

%%% All pieces appear at most once as a child
:- id(I), not 0 #sum{1,P:piece(P,I)} 1.
      
%%% Piece can not be its own child
:- piece(P,P).  
    
%%% If a piece appears as a child, it exists
%%% I guess I cant really enforce this without breaking things,
%%% need some way to feed in input.
%%% :- piece(_,P), not piece(P,_).

%%% Pieces can not be children of nodes with a higher id
:- piece(I,C), I>C.
    
piece(I) :- piece(I,_).
piece(I) :- piece(_,I).
leaf(I) :- piece(_,I), not piece(I,_).
    
children(I,N) :- piece(I), N = #count{C:piece(I,C)}.

op(I,xor,V1^V2) :- piece(I,C1), piece(I,C2), C1!=C2, op(C1,T1,V1), op(C2,T2,V2).
op(I,and,V1&V2) :- piece(I,C1), piece(I,C2), C1!=C2, op(C1,T1,V1), op(C2,T2,V2). 
op(I,nop,V1)    :- piece(I,C1), children(I,1), op(C1,T,V1). 
op(I,input,V1)  :- leaf(I), input(V1).  
    
type(xor;and;input).


%%% Every piece has exactly one operation
%%% Really shouldnt be constant, actually the range of values that can be propagated
%%% I guess this would become much more efficient with the bitwise method where everything
%%% is in the range [0,1]


%%% this makes it UNSAT, not sure why
:- piece(I), not 1 #count{T,V:op(I,T,V),type(T),constant(V)} 1.

cnt(I, X) :- piece(I), X = #count{T,V:op(I,T,V),type(T),constant(V)}.
    

    
%&|^~ -+ */ 
%op(P,)

    
%:- idrange(B), not 0 #sum{1,A,C:piece(A,B,C)} 1.
%:- idrange(C), not 0 #sum{1,A,B:piece(A,B,C)} 1.

%cnt(X, A) :- idrange(A), X = #sum{1,B,C:piece(A,B,C)}.
    
#show piece/2.
#show op/3.
#show cnt/2.
#show children/2.