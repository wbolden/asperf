import random

seen = {}
i = 0
while i < 5:
    x = random.randint(10,100)
    if x not in seen:
        print "item(%d)." % (x)
        seen[x] = 1
        i+=1