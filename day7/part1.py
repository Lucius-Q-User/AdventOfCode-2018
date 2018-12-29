from copy import copy
v = {}
for line in open("in.txt").readlines():
    first = line[5]
    second = line[36]
    if first not in v:
        v[first] = set()
    if second not in v:
        v[second] = set()
    v[second].add(first)

for key in v:
    while 1:
        lt = len(v[key])
        for it in copy(v[key]):
            for ll in v[it]:
                v[key].add(ll)
        if len(v[key]) == lt:
            break

visited = set()

st = ""
print(v)
while 1:
    didSomething = False
    for ky in sorted(v.keys()):
        if ky not in visited and visited.issuperset(v[ky]):
            st += ky
            visited.add(ky)
            didSomething = True
            break
    if not didSomething:
        print(st)
        exit(0)
