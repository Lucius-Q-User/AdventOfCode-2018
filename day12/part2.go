package main

import (
    "fmt"
    "bufio"
    "os"
    "log"
    "strings"
)

const Span = 20000

func main() {
    var grid [Span * 2]bool
    var rules map[[5]bool]bool = make(map[[5]bool]bool)
    file, err := os.Open("in.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    reader := bufio.NewScanner(file)
    reader.Scan()
    initstate := reader.Text()
    reader.Scan()
    initstate = initstate[15:]
    for reader.Scan() {
        x := strings.Split(reader.Text(), " => ")
        key := [...]bool{false, false, false, false, false}
        for i := 0; i < 5; i++ {
            key[i] = x[0][i] == '#'
        }
        rules[key] = x[1][0] == '#'
    }
    for i := 0; i < len(initstate); i++ {
        grid[Span + i] = initstate[i] == '#'
    }
    var paccm = 0
    lastx := [...]int{1, 2, 3, 4, 5}
    for i := 0; i < 2000; i++ {
        var new [Span * 2] bool
        for j := 2; j < Span * 2 - 2; j++ {
            var k [5]bool
            copy(k[:], grid[j-2:])
            new[j] = rules[k]
        }
        grid = new
        var accm = 0
        for j := 0; j < Span * 2; j++ {
            if grid[j] {
                accm += j - Span
            }
        }
        for j := 0; j < 4; j++ {
            lastx[j] = lastx[j + 1]
        }
        lastx[4] = accm - paccm
        var yes = true
        for j := 0; j < 4; j++ {
            yes = yes && (lastx[0] == lastx[j + 1])
        }
        if yes {
            fmt.Println((5000000000 - i - 1) * lastx[0] + accm)
            return
        }
        paccm = accm
    }

}
