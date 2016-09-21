package main

import (
    "fmt"
	"io"
	"net/http"
    "log"
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

	http.HandleFunc("/squares", func(w http.ResponseWriter, req *http.Request) {
        w.Header().Set("Content-Type", "text/plain")
        io.WriteString(w, fmt.Sprintf("%v\n", <-c))
    })
    fmt.Println("starting server...")
	err := http.ListenAndServe(":6080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
