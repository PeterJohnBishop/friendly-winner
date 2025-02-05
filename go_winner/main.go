package main

import (
	firebase "friendly-winner/go_winner/main.go/firebase"
	"friendly-winner/go_winner/main.go/server"
)

func main() {
	firebase.InitFirestore()  // Initialize Firebase
	r := server.SetupServer() // Setup the server
	r.Run(":8080")            // Run the server on http://localhost:8080 by default
}
