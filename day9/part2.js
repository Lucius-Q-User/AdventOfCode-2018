const fs = require("fs");
let input = fs.readFileSync("in.txt", "utf8").split(" ");
let nplayers = Number(input[0]);
let lastMarble = Number(input[6]) * 100;

function LLItem(val) {
    this.v = val;
    this.prev = null;
    this.next = null;
    this.ownerList = null;
}

LLItem.prototype.detach = function() {
    if (this.ownerList.head == this) {
        this.ownerList.head = this.ownerList.head.next;
    }
    if (this.ownerList.tail == this) {
        this.ownerList.tail = this.ownerList.tail.prev;
    }
    if (this.prev != null) {
        this.prev.next = this.next
    }
    if (this.next != null) {
        this.next.prev = this.prev
    }
    this.prev = null;
    this.next = null;
    this.ownerList = null;
}

LLItem.prototype.append = function(nd) {
    if (this.ownerList.tail == this) {
        this.ownerList.tail = nd;
    }
    if (this.next != null) {
        nd.next = this.next;
        this.next.prev = nd;
    }
    nd.prev = this;
    this.next = nd;
    nd.ownerList = this.ownerList;
}

function LinkedList(start) {
    this.head = start;
    this.tail = start;
    start.ownerList = this;
}

let startNode = new LLItem(0);
let ring = new LinkedList(startNode);
let scores = new Array(nplayers).fill(0);
let focus = startNode;

function shift(n) {
    for (let i = 0; i < n; i++) {
        if (focus.prev == null) {
            focus = ring.tail;
        } else {
            focus = focus.prev;
        }
    }
}

for (let i = 1; i <= lastMarble; i++) {
    if (i % 23 != 0) {
        if (focus.next == null) {
            focus = ring.head;
        } else {
            focus = focus.next;
        }
        let newNode = new LLItem(i);
        focus.append(newNode);
        focus = newNode;
    } else {
        shift(7);
        let cplayer = (i - 1) % nplayers;
        scores[cplayer] += i + focus.v;
        let nfocus;
        if (focus.next == null) {
            nfocus = ring.head;
        } else {
            nfocus = focus.next;
        }
        focus.detach();
        focus = nfocus;
    }
}

console.log(Math.max(...scores))
