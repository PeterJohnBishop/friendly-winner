package server

import (
	"friendly-winner/go_winner/main.go/routes"

	"github.com/gin-gonic/gin"
)

func SetupServer() *gin.Engine {
	r := gin.Default() // Create a new gin router

	// Register routes
	userRoutes := r.Group("/users")
	routes.RegisterUserRoutes(userRoutes)

	return r
}
