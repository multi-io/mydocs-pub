package main

import "fmt"

type TI interface {
    foo() int
}

type TS struct {
  x int
}

func (self TS) foo() int {
  return self.x
}


func main() {
	var ti TI
	fmt.Printf("Hello, playground %v foo\n", ti)
	
	var ts TS
	fmt.Printf("Hello, playground %v foo\n", ts)
	
	ti = ts
	fmt.Printf("Hello, playground %v foo\n", ti)
	fmt.Printf("Hello, playground %v foo\n", ts)
}
