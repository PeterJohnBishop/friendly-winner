package main

import (
	"friendly-winner/go_winner/main.go/server"
)

func main() {
	r := server.SetupServer() // Setup the server
	r.Run(":8080")            // Run the server on http://localhost:8080 by default
}
