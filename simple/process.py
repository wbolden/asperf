
import json
import sys
import re


result = json.load(sys.stdin)
atoms = result['Call'][0]['Witnesses'][0]['Value']

items = []
modulus = 0
coef = 0

for a in atoms:
    match = re.match('item\(([0-9]*)\)', a)
    if match:
        items += [int(match.group(1))]
    
    match = re.match('mod\(([0-9]*)\)', a)
    if match:
        modulus = int(match.group(1))
        
    match = re.match('coef\(([0-9]*)\)', a)
    if match:
        coef = int(match.group(1))

        
table = [(item*coef%modulus, item) for item in items]
table.sort()

print "Hash function: %dx mod %d" %(coef,modulus)

print "%7s %7s" % ("hash", "item")
for item in table:
    print "%7d %7d" % item