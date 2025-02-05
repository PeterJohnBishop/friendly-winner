package routes

import (
	"context"
	"net/http"

	firebase "friendly-winner/go_winner/main.go/firebase"

	"github.com/gin-gonic/gin"
)

type Item struct {
	Images      []string               `json:"images"` // Array of image URLs
	Name        string                 `json:"name"`
	Description string                 `json:"description"`
	Category    string                 `json:"category"`
	Price       float64                `json:"price"` // Price in USD
	Featured    bool                   `json:"featured"`
	Quantity    int                    `json:"quantity"` // Number of items in stock
	Tags        []string               `json:"tags"`
	Metadata    map[string]interface{} `json:"metadata"` // product UPC, SKU, etc.
}

func RegisterItemRoutes(router *gin.RouterGroup) {

	router.POST("/item/new", func(c *gin.Context) {
		var newItem Item

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&newItem); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		ctx := context.Background()

		// Convert Item struct to Firestore-compatible map
		itemData := map[string]interface{}{
			"images":      newItem.Images,
			"name":        newItem.Name,
			"description": newItem.Description,
			"category":    newItem.Category,
			"price":       newItem.Price,
			"featured":    newItem.Featured,
			"quantity":    newItem.Quantity,
			"tags":        newItem.Tags,
			"metadata":    newItem.Metadata,
		}

		// Save to Firestore
		if err := firebase.AddItem(ctx, itemData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to create item", "error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "Item created successfully", "item": newItem})
	})

	router.GET("/", func(c *gin.Context) {
		ctx := context.Background()

		items, err := firebase.GetAllItems(ctx)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve items", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"items": items})
	})

	router.GET("/item/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		item, err := firebase.GetItemById(ctx, id)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve item", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"item": item})
	})

	router.PUT("/item/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		var updates map[string]interface{}

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&updates); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		// Update item in Firestore
		if err := firebase.UpdateItem(ctx, id, updates); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to update item", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Item updated successfully"})
	})

	router.DELETE("/item/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		// Delete item from Firestore
		if err := firebase.DeleteItem(ctx, id); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to delete item", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Item deleted successfully"})
	})
}
