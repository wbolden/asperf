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
    binary(D),
    left_edge(I,I1),
    left_port(D,P),
    val_bit(K,I1,B,V).

input_signal(I,K,P,B,V) :-
    op(I,D),
    binary(D),
    right_edge(I,I2),
    right_port(D,P),
    val_bit(K,I2,B,V).