package routes

import (
	"context"
	"net/http"

	"friendly-winner/go_winner/main.go/firebase"

	"github.com/gin-gonic/gin"
)

type User struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

func RegisterUserRoutes(router *gin.RouterGroup) {

	router.POST("/", func(c *gin.Context) {
		var newUser User

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&newUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		if newUser.ID == "" {
			c.JSON(http.StatusBadRequest, gin.H{"message": "User ID is required"})
			return
		}

		ctx := context.Background()

		// Convert User struct to Firestore-compatible map
		userData := map[string]interface{}{
			"name":  newUser.Name,
			"email": newUser.Email,
		}

		// Save to Firestore
		if err := firebase.AddUser(ctx, newUser.ID, userData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to create user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully", "user": newUser})
	})

	router.GET("/users/:id", func(c *gin.Context) {
		ctx := c.Request.Context()
		userID := c.Param("id")

		user, err := firebase.GetUserById(ctx, userID)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"message": "User not found", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, user)
	})

	router.GET("/users", func(c *gin.Context) {
		ctx := c.Request.Context()

		users, err := firebase.GetAllUsers(ctx)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve users", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, users)
	})

	router.PUT("/users/:id", func(c *gin.Context) {
		ctx := c.Request.Context()
		userID := c.Param("id")

		var updateData map[string]interface{}
		if err := c.ShouldBindJSON(&updateData); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		if err := firebase.UpdateUser(ctx, userID, updateData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to update user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "User updated successfully"})
	})

	router.DELETE("/users/:id", func(c *gin.Context) {
		ctx := c.Request.Context()
		userID := c.Param("id")

		if err := firebase.DeleteUser(ctx, userID); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to delete user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
	})

}
