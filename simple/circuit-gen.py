import sys, subprocess, json, os
try:
    width = int(sys.argv[1])
except:
    print 'usage: python circuit-gen.py port-width'
    exit()
    
"""
module mul13(mul13in, mul13out);
    parameter WIDTH = {0};
    input [WIDTH-1:0] mul13in;
    output [WIDTH-1:0] mul13out;
    
    assign mul13out = mul13in * 13;
endmodule

module mul7(mul7in, mul7out);
    parameter WIDTH = {0};
    input [WIDTH-1:0] mul7in;
    output [WIDTH-1:0] mul7out;
    
    assign mul7out = mul7in * 7;
endmodule

module mul5(mul5in, mul5out);
    parameter WIDTH = {0};
    input [WIDTH-1:0] mul5in;
    output [WIDTH-1:0] mul5out;
    
    assign mul5out = mul5in * 5;
endmodule
"""
verilog_src = \
"""
module shr4(shr4in, shr4out);
    parameter WIDTH = {0};
    input [WIDTH-1:0] shr4in;
    output [WIDTH-1:0] shr4out;
    
    assign shr4out = shr4in >> 4;
endmodule


module mod53(modin1,modout);
    parameter WIDTH = {0};
    input [WIDTH-1:0] modin1;
    output [WIDTH-1:0] modout;
    assign modout = modin1 % 53;
endmodule


module mod(modin1,modin2,modout);
    parameter WIDTH = {0};
    input [WIDTH-1:0] modin1;
    input [WIDTH-1:0] modin2;
    output [WIDTH-1:0] modout;
    assign modout = modin1 % modin2;
endmodule

module shr(shrin1,shrin2,shrout);
    parameter WIDTH = {0};
    input [WIDTH-1:0] shrin1;
    input [WIDTH-1:0] shrin2;
    output [WIDTH-1:0] shrout;
    assign shrout = shrin1 >> shrin2;
endmodule

module mul(mulin1,mulin2,mulout);
    parameter WIDTH = {0};
    input [WIDTH-1:0] mulin1;
    input [WIDTH-1:0] mulin2;
    output [WIDTH-1:0] mulout;
    assign mulout = mulin1 % mulin2;
endmodule

module sub(subin1,subin2,subout);
    parameter WIDTH = {0};
    input [WIDTH-1:0] subin1;
    input [WIDTH-1:0] subin2;
    output [WIDTH-1:0] subout;
    assign subout = subin1 % subin2;
endmodule

""".format(width)

yosys_cmd = \
"""
yosys \
-p "synth; abc -liberty mycells.lib; clean; write_json tmp.json" \
-QT -f verilog tmp.v
"""

outfile = open('tmp.v','w')
outfile.write(verilog_src)
outfile.close()



FNULL = open(os.devnull, 'w')
subprocess.call(yosys_cmd,shell=True,stdout=FNULL)

modules = json.load(open('tmp.json'))['modules']
outfile = open('circuit_lib.lp','w')
for m in modules:
    outfile.write('device({}).\n'.format(m))
    dev = modules[m]
    count = 0
    for p in dev['ports']:
        port = dev['ports'][p]
        outfile.write('device_port_direction({},{},{},{}).\n'.format(m,p,port['direction'],count))
        count += 1
        outfile.write('device_port_width({},{},{}).\n'.format(m,p,len(port['bits'])))
        for i,b in enumerate(port['bits']):
            
            if(type(b) != int):
                outfile.write('device_port_bit_literal({},{},{},{}).\n'.format(m,p,i,b))
            else:
                outfile.write('device_port_bit_wire({},{},{},{}).\n'.format(m,p,i,b))
    for c in dev['cells'].values():
        con = c['connections']
        if c['type'] == 'AND':
            outfile.write('device_gate({},and_gate,({}, {}, {})).\n'.format(m,con['A'][0],con['B'][0],con['Y'][0]))
        if c['type'] == 'OR':
            outfile.write('device_gate({},or_gate,({}, {}, {})).\n'.format(m,con['A'][0],con['B'][0],con['Y'][0]))
        if c['type'] == 'NOT':
            outfile.write('device_gate({},not_gate,({}, {})).\n'.format(m,con['A'][0],con['Y'][0])) 
outfile.close()
#%os.remove('tmp.v')
#os.remove('tmp.json')