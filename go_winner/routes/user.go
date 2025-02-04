package routes

import (
	"context"
	"net/http"

	"friendly-winner/go_winner/main.go/firebase"

	"github.com/gin-gonic/gin"
)

type User struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
	Address1 string `json:"address1"`
	Address2 string `json:"address2"`
	City     string `json:"city"`
	State    string `json:"state"`
	Zip      string `json:"zip"`
}

func RegisterUserRoutes(router *gin.RouterGroup) {

	router.POST("/user/new/:uid", func(c *gin.Context) {
		var newUser User
		uid := c.Param("uid")

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&newUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		if uid == "" {
			c.JSON(http.StatusBadRequest, gin.H{"message": "User ID is required"})
			return
		}

		ctx := context.Background()

		// Convert User struct to Firestore-compatible map
		userData := map[string]interface{}{
			"name":     newUser.Name,
			"email":    newUser.Email,
			"phone":    newUser.Phone,
			"address1": newUser.Address1,
			"address2": newUser.Address2,
			"city":     newUser.City,
			"state":    newUser.State,
			"zip":      newUser.Zip,
		}

		// Save to Firestore
		if err := firebase.AddUser(ctx, uid, userData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to create user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully", "user": newUser})
	})

	router.GET("/user/:uid", func(c *gin.Context) {
		ctx := c.Request.Context()
		uid := c.Param("uid")

		user, err := firebase.GetUserById(ctx, uid)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"message": "User not found", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, user)
	})

	router.GET("/", func(c *gin.Context) {
		ctx := c.Request.Context()

		users, err := firebase.GetAllUsers(ctx)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve users", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, users)
	})

	router.PUT("/user/:uid", func(c *gin.Context) {
		ctx := c.Request.Context()
		uid := c.Param("uid")

		var updateData map[string]interface{}
		if err := c.ShouldBindJSON(&updateData); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		if err := firebase.UpdateUser(ctx, uid, updateData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to update user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "User updated successfully"})
	})

	router.DELETE("/user/:uid", func(c *gin.Context) {
		ctx := c.Request.Context()
		uid := c.Param("id")

		if err := firebase.DeleteUser(ctx, uid); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to delete user", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
	})

}
