#include <fstream>
#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <utility>

#define $(...) make_tuple(__VA_ARGS__)
using namespace std;

int main() {
    map<tuple<int, int>, int> grid;
    string regex;
    ifstream("in.txt") >> regex;
    int fx = 0;
    int fy = 0;
    grid[$(fx, fy)] = 0;
    vector<tuple<int, int>> stk;
    for (auto it = regex.begin(); it < regex.end(); it++) {
        if (*it == '(') {
            stk.emplace_back(fx, fy);
        } else if (*it == ')') {
            auto [x, y] = stk.back();
            fx = x;
            fy = y;
            stk.pop_back();
        } else if (*it == '|') {
            auto [x, y] = stk.back();
            fx = x;
            fy = y;
        } else {
            int px = fx;
            int py = fy;
            if (*it == 'N') {
                fy++;
            } else if (*it == 'E') {
                fx++;
            } else if (*it == 'W') {
                fx--;
            } else if (*it == 'S') {
                fy--;
            }
            if (grid[$(fx, fy)]) {
                grid[$(fx, fy)] = min(grid[$(fx, fy)], grid[$(px, py)]);
            } else {
                grid[$(fx, fy)] = grid[$(px, py)] + 1;
            }
        }
    }
    int mx = 0;
    for (auto it = grid.begin(); it != grid.end(); it++) {
        mx = max(it->second, mx);
    }
    cout << mx - 1 << "\n";
}
