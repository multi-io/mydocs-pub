package main

import (
    "fmt"
    "flag"
    "time"
    "sync"
)


var wg sync.WaitGroup

func wait(text string) {
    fmt.Printf("%v start\n", text)
    time.Sleep(5*time.Second)
    fmt.Printf("%v done\n", text)
    defer wg.Done()
}


func busywait(text string) {
    fmt.Printf("%v start\n", text)
    for i := 0; i < 1e10; i++ {
    }
    fmt.Printf("%v done\n", text)
    defer wg.Done()
}


func main() {
    pn := flag.Int("n", 100, "number of parallel invocations")
    flag.Parse()

    fmt.Println("main start")
    wg.Add(*pn)
    for i := 0; i < *pn; i++ {
        go wait(fmt.Sprintf("wait %v", i))
        //go busywait(fmt.Sprintf("busywait %v", i))
    }
    wg.Wait()
    fmt.Println("main done")
}
