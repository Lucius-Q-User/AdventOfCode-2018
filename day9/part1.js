const fs = require("fs");
let input = fs.readFileSync("in.txt", "utf8").split(" ");
let nplayers = Number(input[0]);
let lastMarble = Number(input[6]);

let ring = [0];
let scores = new Array(nplayers).fill(0);
let focus = 0;
for (let i = 1; i <= lastMarble; i++) {
    if (i % 23 != 0) {
        focus += 2;
        if (focus > ring.length) {
            focus -= ring.length;
        }
        ring.splice(focus, 0, i);
    } else {
        focus -= 7;
        if (focus < 0) {
            focus += ring.length;
        }
        let cplayer = (i - 1) % nplayers;
        scores[cplayer] += i + ring[focus];
        ring.splice(focus, 1);
    }
}

console.log(Math.max(...scores))
