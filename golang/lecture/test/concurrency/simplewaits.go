package main

import (
    "fmt"
    "time"
)



func wait(text string) {
    fmt.Printf("%v start\n", text)
    time.Sleep(5*time.Second)
    fmt.Printf("%v done\n", text)
}


func main() {
    fmt.Println("main start")
    for i := 0; i < 8; i++ {
        go wait(fmt.Sprintf("wait %v", i))
    }
    time.Sleep(6*time.Second)
}
