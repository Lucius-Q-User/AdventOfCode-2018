package main

import (
    "fmt"
    "bufio"
    "os"
    "log"
    "strings"
)

const Span = 200

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
    for i := 0; i < 20; i++ {
        var new [Span * 2] bool
        for j := 2; j < Span * 2 - 2; j++ {
            var k [5]bool
            copy(k[:], grid[j-2:])
            new[j] = rules[k]
        }
        grid = new
    }
    var accm = 0
    for j := 0; j < Span * 2; j++ {
        if grid[j] {
            accm += j - Span
        }
    }
    fmt.Println(accm)
}
