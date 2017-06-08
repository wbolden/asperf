
#const corange = 10.
constant(1..corange).
input(1..5).


idrange(0..10).



%%% piece(id,child_id_1,child_id_2).
2 {piece(A,B,C):idrange(A),idrange(B),idrange(C)}.

%%% At most one piece per id
:- idrange(A), not 0 #sum{1,B,C:piece(A,B,C)} 1.
        
%%% Piece appears at most once as a child
:- idrange(P), not 0 #sum{1,A,C,left:piece(A,P,C); 1,A,B,right:piece(A,B,P)} 1.
    
%%% Piece can not be its own child
:- idrange(P), piece(P,P,_).
:- idrange(P), piece(P,_,P).
    
%%% If a piece appears as a child, it exists
%TODO
    

    
%:- idrange(B), not 0 #sum{1,A,C:piece(A,B,C)} 1.
%:- idrange(C), not 0 #sum{1,A,B:piece(A,B,C)} 1.

%cnt(X, A) :- idrange(A), X = #sum{1,B,C:piece(A,B,C)}.
    
    