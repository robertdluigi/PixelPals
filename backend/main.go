// main.go
package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	// Example response when a request is made to the backend
	fmt.Fprintf(w, "Hello, from the backend!")
}

func main() {
	// Set up a simple HTTP server
	http.HandleFunc("/", handler)
	fmt.Println("Backend server running on port 8080...")
	err := http.ListenAndServe(":8080", nil) // Listen on port 8080
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
