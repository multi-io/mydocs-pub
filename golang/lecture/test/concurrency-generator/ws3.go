package main

import (
    "fmt"
	"io"
	"net/http"
    "log"
    "time"
)


func run_squares_generator() (<-chan uint64, chan<- bool) {
    squares_output := make(chan uint64)
    resetter := make(chan bool)
    go func() {
        var i uint64 = 0
        for {
            select {
            case squares_output <- i*i:
                i ++
            case <-resetter:
                i = 0
            }
        }
    }()
    return squares_output, resetter
}


func ticker(interval time.Duration) (<-chan bool) {
    tick_output := make(chan bool)
    go func() {
        for {
            time.Sleep(interval)
            tick_output <- true
        }
    }()
    return tick_output
}


func main() {
    squares_input, resetter := run_squares_generator()

	http.HandleFunc("/squares", func(w http.ResponseWriter, req *http.Request) {
        w.Header().Set("Content-Type", "text/plain")
        io.WriteString(w, fmt.Sprintf("%v\n", <-squares_input))
    })
	http.HandleFunc("/reset", func(w http.ResponseWriter, req *http.Request) {
        w.Header().Set("Content-Type", "text/plain")
        resetter <- true
        io.WriteString(w, "Reset successful.")
    })

    go func() {
        tick := ticker(10 * time.Second)
        for {
            resetter <- <- tick
        }
    }()

    fmt.Println("starting server...")
	err := http.ListenAndServe(":6080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
