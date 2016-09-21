package main

import (
    "fmt"
)


func squares_generator(out chan<- uint64) {
    var i uint64 = 0
    for {
        out <- i*i
        i += 1
    }
}


func main() {
    c := make(chan uint64)
    go squares_generator(c)
    fmt.Println(<-c, <-c, <-c, <-c)
}
