import std.algorithm;
import std.stdio;
import core.stdc.stdio;
import std.conv;
import std.string;


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
    int mx = 0;
    int mi = -1;
    foreach (guard, pattern; guards) {
        int sm = 0;
        for (int i = 0; i < 60; i++) {
            sm += pattern[i];
        }
        if (sm > mx) {
            mi = guard;
            mx = sm;
        }
    }
    int mx2 = 0;
    int mi2 = 0;
    for (int i = 0; i < 60; i++) {
        int v = guards[mi][i];
        if (v > mx2) {
            mi2 = i;
            mx2 = v;
        }
    }
    writefln("%d", mi * mi2);
}
