package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type User struct {
	ID       string `json:"id"`
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

var users []User // mock database

func RegisterUserRoutes(router *gin.RouterGroup) {

	router.POST("/", func(c *gin.Context) {

		var newUser User
		if err := c.ShouldBindJSON(&newUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}
		// newUser.ID = c.MustGet("uuid").(string)
		users = append(users, newUser) // placeholder for Firebase functionality
		c.JSON(http.StatusCreated, newUser)
	})

	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, users)
	})

	router.GET("/:id", func(c *gin.Context) {
		id := c.Param("id")
		for _, user := range users {
			if user.ID == id {
				c.JSON(http.StatusOK, user)
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"message": "User not found"})
	})

	router.PUT("/:id", func(c *gin.Context) {
		id := c.Param("id")
		var updatedUser User
		if err := c.ShouldBindJSON(&updatedUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		for i, user := range users {
			if user.ID == id {
				updatedUser.ID = id
				users[i] = updatedUser
				c.JSON(http.StatusOK, updatedUser)
				return
			}
		}

		c.JSON(http.StatusNotFound, gin.H{"message": "User not found"})
	})

	router.DELETE("/:id", func(c *gin.Context) {
		id := c.Param("id")
		for i, user := range users {
			if user.ID == id {
				users = append(users[:i], users[i+1:]...)
				c.JSON(http.StatusOK, gin.H{"message": "User deleted"})
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"message": "User not found"})
	})
}
