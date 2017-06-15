# asperf
Generate perfect hash functions with ASP.

This system uses clingo to construct perfect hash functions without buckets and with near-minimal memory overhead.

## How to use this
Install the `Potassco`: The Potsdam Answer Set Solving Collection. Make sure that you get `clingo` version 5+ and build with python scripting support.

The input file should be a list of newline delineated keys. You will get C-code as output.

`ASPerf` only works with python2.x

## Options:
usage: asperf.py [-h] [--template TEMPLATE] [--yosys] [-b B] [-n N] keyfile

positional arguments:

  keyfile              a newline delimited array of keys to be hashed

optional arguments:

  -h, --help           show this help message and exit
  
  --template TEMPLATE  a function template lp file for asperf to fill in
  
  --yosys              generate a yosys circuit for additional operations
  
  -b B                 number of bits per key
  
  -n N                 number of operations

  -p P                 parallel mode
