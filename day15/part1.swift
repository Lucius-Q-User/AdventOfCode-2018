import Foundation;


struct Unit {
    var kind: Character;
    var hp: Int = 200;
    var last_move = 0;
    init(_ kind: Character) {
        self.kind = kind;
        
    }
    func enemy() -> Character {
        return self.kind == "E" ? "G" : "E";
    }
}

var grid: [[Unit]] = [];

let st = try! String(contentsOfFile: "in.txt").split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: true);

for line in st {
    var gridline: [Unit] = [];
    for char in line {
        gridline.append(Unit(char));
    }
    grid.append(gridline);
}

func enemyInRange(x: Int, y: Int, enemy: Character) -> (Int, Int)? {
    var least_hp = Int.max;
    var found: (Int, Int)? = nil;
    if x > 0 && grid[x - 1][y].kind == enemy && grid[x - 1][y].hp < least_hp {
        found = (x - 1, y);
        least_hp = grid[x - 1][y].hp;
    }
    if y > 0 && grid[x][y - 1].kind == enemy && grid[x][y - 1].hp < least_hp {
        found = (x, y - 1);
        least_hp = grid[x][y - 1].hp;
    }
    if y < grid[0].count - 1 && grid[x][y + 1].kind == enemy && grid[x][y + 1].hp < least_hp {
        found = (x, y + 1);
        least_hp = grid[x][y + 1].hp;
    }
    if x < grid.count - 1 && grid[x + 1][y].kind == enemy && grid[x + 1][y].hp < least_hp {
        found = (x + 1, y);
        least_hp = grid[x + 1][y].hp;
    }
    return found;
}

struct NodeMetadata {
    var cameFrom: (Int, Int)?;
    var distance: Int;
}

func findNearestEnemy(x: Int, y: Int) -> (Int, Int) {
    var queue = [(x, y)];
    let enemy = grid[x][y].enemy();
    var meta = Array(repeating: Array(repeating: NodeMetadata(cameFrom: nil, distance: Int.max), count: grid[0].count), count: grid.count);
    meta[x][y] = NodeMetadata(cameFrom: (x, y), distance: 0);
    
    while !queue.isEmpty {
        let (fx, fy) = queue.removeFirst();
        let fdist = meta[fx][fy].distance + 1;
        if fx > 0 && grid[fx - 1][fy].kind == "." && meta[fx - 1][fy].cameFrom == nil {
            meta[fx - 1][fy] = NodeMetadata(cameFrom: (fx, fy), distance: fdist);
            queue.append((fx - 1, fy));
        }
        if fy > 0 && grid[fx][fy - 1].kind == "." && meta[fx][fy - 1].cameFrom == nil {
            meta[fx][fy - 1] = NodeMetadata(cameFrom: (fx, fy), distance: fdist);
            queue.append((fx, fy - 1));
        }
        if fy < grid[0].count - 1 && grid[fx][fy + 1].kind == "." && meta[fx][fy + 1].cameFrom == nil {
            meta[fx][fy + 1] = NodeMetadata(cameFrom: (fx, fy), distance: fdist);
            queue.append((fx, fy + 1));
        }
        if fx < grid.count - 1 && grid[fx + 1][fy].kind == "." && meta[fx + 1][fy].cameFrom == nil {
            meta[fx + 1][fy] = NodeMetadata(cameFrom: (fx, fy), distance: fdist);
            queue.append((fx + 1, fy));
        }
    }
    var foundEnemy = false;
    var minPath = Int.max;
    var target: (Int, Int)? = nil;
    for fx in 0..<grid.count {
        for fy in 0..<grid[0].count {
            if grid[fx][fy].kind == enemy {
                foundEnemy = true;
                if fx > 0 && meta[fx - 1][fy].distance < minPath {
                    target = (fx - 1, fy);
                    minPath = meta[fx - 1][fy].distance;
                }
                if fy > 0 && meta[fx][fy - 1].distance < minPath {
                    target = (fx, fy - 1);
                    minPath = meta[fx][fy - 1].distance;
                }
                if fy < grid[0].count - 1 && meta[fx][fy + 1].distance < minPath {
                    target = (fx, fy + 1);
                    minPath = meta[fx][fy + 1].distance;
                }
                if fx < grid.count - 1 && meta[fx + 1][fy].distance < minPath {
                    target = (fx + 1, fy);
                    minPath = meta[fx + 1][fy].distance;
                }
            }
        }
    }
    if !foundEnemy {
        return (Int.max, 0);
    }
    if minPath == Int.max {
        return (0, Int.max);
    }
    while true {
        let (fx, fy) = target!;
        if meta[fx][fy].cameFrom! == (x, y) {
            return target!
        }
        target = meta[fx][fy].cameFrom;
    }
}
var turn = 0;
outer: while true {
    turn += 1;
    for x in 0..<grid.count {
        for y in 0..<grid[0].count {
            if (grid[x][y].kind == "E" || grid[x][y].kind == "G") && grid[x][y].last_move < turn {
                grid[x][y].last_move = turn;
                var nx = x;
                var ny = y;
                if enemyInRange(x: x, y: y, enemy: grid[x][y].enemy()) == nil {
                    (nx, ny) = findNearestEnemy(x: x, y: y);
                    if nx == Int.max {
                        break outer;
                    }
                    if ny != Int.max {
                        let tm = grid[x][y];
                        grid[x][y].kind = ".";
                        grid[nx][ny] = tm;
                    } else {
                        nx = x;
                        ny = y;
                    }
                }
                if let (ex, ey) = enemyInRange(x: nx, y: ny, enemy: grid[nx][ny].enemy()) {
                    grid[ex][ey].hp -= 3;
                    if grid[ex][ey].hp <= 0 {
                        grid[ex][ey].kind = ".";
                    }
                }
            }
        }
    }
}
turn -= 1;
var hpsum = 0;
for line in grid {
    for unit in line {
        if unit.kind == "E" || unit.kind == "G" {
            hpsum += unit.hp;
        }
    }
}
print(turn * hpsum);

