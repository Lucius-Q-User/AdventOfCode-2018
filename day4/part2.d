import std.algorithm;
import std.stdio;
import core.stdc.stdio;
import std.conv;
import std.string;
import std.typecons;

alias Ipair = Tuple!(int, "f", int, "s");

void main() {
    auto file = File("in.txt");
    int curGuard = 0;
    int lastSleep = -1;
    char[] buf;
    int[60][int] guards;
    int[60] zs;
    for (int i = 0; i < 60; i++) {
        zs[i] = 0;
    }
    while (file.readln(buf)) {
        if (canFind(buf, ['s', 'h', 'i'])) {
            sscanf(toStringz(buf), toStringz("[%*d-%*d-%*d %*d:%*d] Guard #%d"), &curGuard);
            guards.require(curGuard, zs);
            lastSleep = -1;
        }
        int timestamp;
        sscanf(toStringz(buf), toStringz("[%*d-%*d-%*d %*d:%d]"), &timestamp);
        if (canFind(buf, ['a', 's', 'l', 'e'])) {
            lastSleep = timestamp;
        }
        if (canFind(buf, ['w', 'a', 'k', 'e'])) {
            for (int i = lastSleep; i < timestamp; i++) {
                guards[curGuard][i]++;
            }
        }
    }
    Ipair[int] mxg;
    foreach (id, pattern; guards) {
        int mx = 0;
        int xm = -1;
        for (int i = 0; i < 60; i++) {
            if (pattern[i] > mx) {
                xm = i;
                mx = pattern[i];
            }
        }
        Ipair ip;
        ip.f = xm;
        ip.s = mx;
        mxg[id] = ip;
    }
    int mg = -1;
    int mm = -1;
    int mv = 0;
    foreach(guard, ip; mxg) {
        if (ip.s > mv) {
            mv = ip.s;
            mm = ip.f;
            mg = guard;
        }
    }
    writefln("%d", mg * mm);
}
