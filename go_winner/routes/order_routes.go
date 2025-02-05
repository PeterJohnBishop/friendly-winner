package routes

import (
	"context"
	"net/http"

	firebase "friendly-winner/go_winner/main.go/firebase"

	"github.com/gin-gonic/gin"
)

type Order struct {
	OrderID       string                 `json:"order_id"`
	UserID        string                 `json:"user_id"`
	TotalPrice    int                    `json:"total_price"`
	Items         []Item                 `json:"items"`
	DateOrdered   string                 `json:"date_ordered"`
	OrderStatus   string                 `json:"order_status"`
	DateCompelted string                 `json:"date_completed"`
	Metadata      map[string]interface{} `json:"metadata"` // tracking number, special notes, etc.
}

func RegisterOrderRoutes(router *gin.RouterGroup) {

	router.POST("/order/new", func(c *gin.Context) {
		var newOrder Order

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&newOrder); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		ctx := context.Background()

		// Convert Order struct to Firestore-compatible map
		orderData := map[string]interface{}{
			"order_id":       newOrder.OrderID,
			"user_id":        newOrder.UserID,
			"total_price":    newOrder.TotalPrice,
			"items":          newOrder.Items,
			"date_ordered":   newOrder.DateOrdered,
			"order_status":   newOrder.OrderStatus,
			"date_completed": newOrder.DateCompelted,
			"metadata":       newOrder.Metadata,
		}

		// Save to Firestore
		if err := firebase.AddOrder(ctx, orderData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to create order", "error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "Order created successfully", "order": newOrder})
	})

	router.GET("/", func(c *gin.Context) {
		ctx := context.Background()

		orders, err := firebase.GetAllOrders(ctx)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve orders", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"orders": orders})
	})

	router.GET("/order/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		order, err := firebase.GetOrderById(ctx, id)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve order", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"order": order})
	})

	router.GET("/order/user/:userId", func(c *gin.Context) {
		ctx := context.Background()
		uid := c.Param("userId")

		orders, err := firebase.GetOrdersByUserId(ctx, uid)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to retrieve orders", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"orders": orders})
	})

	router.PUT("/order/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		var updates map[string]interface{}

		// Bind JSON to struct
		if err := c.ShouldBindJSON(&updates); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Invalid input"})
			return
		}

		// Update order in Firestore
		if err := firebase.UpdateOrder(ctx, id, updates); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to update order", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Order updated successfully"})
	})

	router.DELETE("/order/:documentId", func(c *gin.Context) {
		ctx := context.Background()
		id := c.Param("documentId")

		// Delete order from Firestore
		if err := firebase.DeleteOrder(ctx, id); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Failed to delete order", "error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Order deleted successfully"})
	})
}
