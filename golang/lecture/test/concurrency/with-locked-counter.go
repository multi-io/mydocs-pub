package main

import (
    "fmt"
    "flag"
    "time"
    "sync"
    "sync/atomic"
)

var wg sync.WaitGroup

func main() {
    pn := flag.Int("n", 100000, "number of parallel invocations")
    flag.Parse()

    fmt.Println("main start")
    wg.Add(*pn)
    for i := 0; i < *pn; i++ {
        go wait()
        //go busywait()
    }
    wg.Wait()
    fmt.Println("main done")
}



func wait() {
    iRun := getNextNum()

    fmt.Println("wait ", iRun, " start")
    time.Sleep(5*time.Second)
    fmt.Println("wait ", iRun, " done")
    defer wg.Done()
}

func busywait() {
    iRun := getNextNum()

    fmt.Println("busywait ", iRun, " start")
    for i := 0; i < 1e10; i++ {
    }
    fmt.Println("busywait ", iRun, " done")
    defer wg.Done()
}


var iRun uint64 = 0

func getNextNum() uint64 {
    atomic.AddUint64(&iRun, 1)
    return atomic.LoadUint64(&iRun)
}
