import sys, subprocess, json
try:
    width = int(sys.argv[1])
except:
    print 'usage: python circuit-gen.py port-width'
    exit()
    
verilog_src = \
"""
module good_adder(a, b, out);
    parameter WIDTH = {};
    input [WIDTH-1:0] a;
    input [WIDTH-1:0] b; 
    output [WIDTH-1:0] out;
    
    assign out = a + b;
endmodule
""".format(width)

yosys_cmd = \
"""
sudo yosys \
-p "synth; abc -liberty mycells.lib; clean; write_json tmp.json" \
-QT -f verilog tmp.v
"""

outfile = open('tmp.v','w')
outfile.write(verilog_src)
outfile.close()

subprocess.call(yosys_cmd,shell=True)