import random

seen = {}
for i in range(5):
    x = random.randint(0,1000)
    if x not in seen:
        print "item(%d)." % (x)
        seen[x] = 1
    