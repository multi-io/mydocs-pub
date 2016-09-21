package main

import "fmt"

type TI interface {
    foo() int
}

type TS struct {
    x int
}

func (self TS) foo() int {
    fmt.Printf("foo called, x=%v\n", self.x)
    return self.x
}


func callfoo(ti TI) int {
    return ti.foo();
}

func main() {
	var ts *TS
    //ts = new(TS)
    ts = &TS{x:25}
	fmt.Printf("Hello, playground %v foo\n", ts)

    callfoo(ts)
    ts.x = 42
    callfoo(ts)

}
