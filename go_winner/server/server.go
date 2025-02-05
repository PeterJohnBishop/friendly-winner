package server

import (
	"friendly-winner/go_winner/main.go/routes"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupServer() *gin.Engine {
	r := gin.Default()

	config := cors.Config{
		AllowOrigins:     []string{"http://localhost:*"}, // development only
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Authorization", "Content-Type"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}

	config.AllowOriginFunc = func(origin string) bool {
		return len(origin) > 0 && (origin == "http://localhost" ||
			(len(origin) > 17 && origin[:17] == "http://localhost:"))
	}

	r.Use(cors.New(config))

	// Register routes
	userRoutes := r.Group("/users")
	routes.RegisterUserRoutes(userRoutes)
	itemRoutes := r.Group("/items")
	routes.RegisterItemRoutes(itemRoutes)
	orderRoutes := r.Group("/orders")
	routes.RegisterOrderRoutes(orderRoutes)

	return r
}
