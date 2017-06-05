
%%% Attempts to perfectly hash keys given as item(number)

#const corange = 10.
constant(1..corange).
    
%%%operation(type, item, in1, in2, output)
operation(xor, I, A, B, A^B) :- item(I), output(I,A), output(I,B).       
operation(and, I, A, B, A&B) :- item(I), output(I,A), output(I,B). 
operation(or , I, A, B, A?B) :- item(I), output(I,A), output(I,B). 
    

hash(I,X) :- item(I), input(I,V1), input(I,V2), operation(T,I,V1,V2,X).
    
    
output(I,I) :- item(I).
output(I,X) :- item(I), constant(X).
output(I,X) :- item(I), output(I,V1), output(I,V2), operation(T,I,V1,V2,X).
    
    
:- item(A), item(B), A != B, hash(A,X), hash(B,X). 
    
    
    
%%% input constant or item
input(I) :- item(I).
input(I) :- constant(I).
    
    
%:- item(A), item(B), operation(T,ID,) 
    
    
%%output(I,X) :- input(I), operation(T, )
    

