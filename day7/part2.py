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

def ff(st):
    for key in st:
        while 1:
            lt = len(st[key])
            for it in copy(st[key]):
                for ll in st[it]:
                    st[key].add(ll)
            if len(st[key]) == lt:
                break
ff(v)

visited = set()

print(v)

def ttc(c):
    return ord(c) - ord('A') + 60

timer = 0
workers = [None for x in range(5)]
finished = set()
tasks = list(sorted(v.keys()))
while 1:
    print("\ntick " + str(timer))
    if len(tasks) == 0 and all(x is None for x in workers):
        print(timer-1)
        exit(0)
    timer += 1
    for i in range(len(workers)):
        if workers[i] is not None:
            if workers[i][0] == 0:
                finished.add(workers[i][1])
                workers[i] = None
            else:
                workers[i][0] -= 1
    while len(tasks) != 0:
        ts = None
        for cand in tasks:
            if v[cand].issubset(finished):
                ts = cand
                break
        if ts is None:
            break
        if not any(x is None for x in workers):
            break
        tasks.remove(ts)
        for i in range(len(workers)):
            if workers[i] is None:
                workers[i] = [ttc(ts), ts]
                break
    print(workers)
    print(finished)
