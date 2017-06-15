# random-instance.py : a short script for generating random instances 
# of the perfect hashing problem in ANSprolog form acceptable to ASPerf

import random, sys

# parse the command line arguments
num, min_key, max_key = [int(v) for v in sys.argv[1:]]
assert max_key > min_key > 0
assert num < (max_key - min_key)

# define a list of integers in the specified range
pool = list(range(min_key,max_key))

# sample unique points
chosen = random.sample(pool,num)

# print out some ANSprolog predicates
print('% randomly generated key definitions')
for c in chosen: print('key({}).'.format(c))