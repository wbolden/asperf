python circuit-gen.py 16 200
python random-instance.py 20 5000 10000 > keys.lp
clingo verify.lp keys.lp generate.lp globals.lp circuit_int.lp circuit_lib.lp \
--const bits=16 --const num_ops=5 --parallel-mode 4