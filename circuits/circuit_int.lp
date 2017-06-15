input_port(Port) :- device_port_direction(Device,Port,input,C).

output_port(Port) :- device_port_direction(Device,Port,output,C).

port_width(Port,Size) :-
    device_port_width(Device,Port,Size).

% Define all the gate rules
signal(I,K,Device,Out,1-(1-V1)*(1-V2)) :-
    op(I,Device),
    device_gate(Device,or_gate,(In1,In2,Out)),
    signal(I,K,Device,In1,V1); signal(I,K,Device,In2,V2).

signal(I,K,Device,Out,V1*V2) :-
    op(I,Device),
    device_gate(Device,and_gate,(In1,In2,Out)),
    signal(I,K,Device,In1,V1), signal(I,K,Device,In2,V2).

signal(I,K,Device,Out,1-V1) :-
    op(I,Device),
    device_gate(Device,not_gate,(In,Out)),
    signal(I,K,Device,In,V1).

% get input signal
signal(I,K,Device,Wire,Value) :-
    op(I,Device),
    input_signal(I,K,Port,Bit,Value),
    device_port_bit_wire(Device,Port,Bit,Wire).
%*
signal(I,K,Device,Wire,Value) :-
    op(I,Device),
    node(I),
    key(K),
    device_port_bit_literal(Device,Port,Bit,Value).
    
    *%

% get output signal
output_signal(I,K,Bit,Value) :-
    signal(I,K,Device,Wire,Value),
    output_port(Port),
    device_port_bit_wire(Device,Port,Bit,Wire).

output_signal(I,K,Bit,Value) :-
    op(I,Device),
    node(I),
    key(K),
    output_port(Port),
    device_port_bit_literal(Device,Port,Bit,Value).   
    