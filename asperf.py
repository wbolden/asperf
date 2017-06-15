#!/usr/bin/python2.7
import os
import argparse
import math
import subprocess

parser = argparse.ArgumentParser(description='Generate a perfect hash function.')

parser.add_argument("keyfile", help="a newline delimited array of keys to be hashed",type=str)

parser.add_argument("--template", help="a function template lp file for asperf to fill in",type=str)

parser.add_argument("--yosys", help="generate a yosys circuit for additional operations",action="store_true")
parser.add_argument("-b", help="number of bits per key",type=int)
parser.add_argument("-n", help="number of operations",type=int, default=6)
parser.add_argument("-p", help="parallel mode",type=int)


args = parser.parse_args()



    
#Read keyfile
keys = open(args.keyfile).read().splitlines()
keys = map(int, keys)


#bits = ceilmax(bits in largest key, bits in number of keys)
bits = int(math.ceil(math.log(max(len(keys), max(keys)),2)))

#assign from command line arguments
if args.b:
    bits = args.b

nodes = args.n


if args.template:
    templatepath = os.path.abspath(args.template)


if args.yosys:
    aspdir = "circuits"
else:
    aspdir = "pureasp"

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)+"/"+aspdir
os.chdir(dname)

if args.yosys:
    print "Generating yosys circuits..."
    os.system("python2 circuit-gen.py %d" % (bits))
    #subprocess.run(["python2", "circuit-gen.py", bits])


#write out file for keys
with open('__input.lp', 'w') as file:
    for key in keys:
        file.write("key(%d).\n" % (key))

cmd = ["clingo", "globals.lp", "verify.lp", "keys.lp", "__input.lp"]

if args.template:
    cmd += [templatepath]
else:
    cmd += ["generate.lp"]


if args.yosys:
    cmd += ["circuit_int.lp", "circuit_lib.lp"]

cmd += ["--const bits=%s --const nodes=%s" % (bits,nodes)]

if args.p:
    cmd += ["--parallel-mode %d" % (args.p)]


os.system(" ".join(cmd))
#subprocess.run(cmd)
