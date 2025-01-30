package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type Item struct {
	ID          string  `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Quantity    int     `json:"quantity"`
	Value       float64 `json:"value"`
}

var items []Item

func RegisterItemRoutes(router *gin.RouterGroup) {

	// Create an item
	router.POST("/", func(c *gin.Context) {
		var newItem Item
		if err := c.ShouldBindJSON(&newItem); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}
		newItem.ID = uuid.New().String()
		items = append(items, newItem)
		c.JSON(http.StatusCreated, newItem)
	})

	// Get all items
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, items)
	})

	// Get an item by ID
	router.GET("/:id", func(c *gin.Context) {
		id := c.Param("id")
		for _, item := range items {
			if item.ID == id {
				c.JSON(http.StatusOK, item)
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"message": "Item not found"})
	})

	// Update an item
	router.PUT("/:id", func(c *gin.Context) {
		id := c.Param("id")
		var updatedItem Item
		if err := c.ShouldBindJSON(&updatedItem); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		for i, item := range items {
			if item.ID == id {
				updatedItem.ID = id
				items[i] = updatedItem
				c.JSON(http.StatusOK, updatedItem)
				return
			}
		}

		c.JSON(http.StatusNotFound, gin.H{"message": "Item not found"})
	})

	// Delete an item
	router.DELETE("/:id", func(c *gin.Context) {
		id := c.Param("id")
		for i, item := range items {
			if item.ID == id {
				items = append(items[:i], items[i+1:]...)
				c.JSON(http.StatusOK, gin.H{"message": "Item deleted"})
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"message": "Item not found"})
	})
}
