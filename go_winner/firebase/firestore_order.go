package firebase

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/firestore"
)

func AddOrder(ctx context.Context, orderData map[string]interface{}) error {

	// Create a new context with a 60-second timeout
	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel() // Ensure the context is canceled when the function exits

	_, _, err := FirestoreClient.Collection("orders").Add(ctx, orderData)
	if err != nil {
		return fmt.Errorf("failed to add order: %v", err)
	}
	fmt.Println("Order added successfully!")
	return nil
}

func GetAllOrders(ctx context.Context) ([]map[string]interface{}, error) {
	var orders []map[string]interface{}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	iter := FirestoreClient.Collection("orders").Documents(ctx)
	defer iter.Stop()

	for {
		doc, err := iter.Next()
		if err != nil {
			if err.Error() == "iterator done" {
				break
			}
			return nil, fmt.Errorf("failed to retrieve orders: %v", err)
		}

		orderData := doc.Data()
		orders = append(orders, orderData)
	}

	return orders, nil
}

func GetOrderByDocumentId(ctx context.Context, documentID string) (map[string]interface{}, error) {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	doc, err := FirestoreClient.Collection("orders").Doc(documentID).Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get order: %v", err)
	}

	data := doc.Data()
	return data, nil
}

func GetOrdersByUserId(ctx context.Context, uid string) ([]map[string]interface{}, error) {
	var orders []map[string]interface{}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	iter := FirestoreClient.Collection("orders").Where("user_id", "==", uid).Documents(ctx)
	defer iter.Stop()

	for {
		doc, err := iter.Next()
		if err != nil {
			if err.Error() == "iterator done" {
				break
			}
			return nil, fmt.Errorf("failed to retrieve orders: %v", err)
		}

		orderData := doc.Data()
		orders = append(orders, orderData)
	}

	return orders, nil
}

func GetOrdersByOrderId(ctx context.Context, orderID string) ([]map[string]interface{}, error) {
	var orders []map[string]interface{}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	iter := FirestoreClient.Collection("orders").Where("order_id", "==", orderID).Documents(ctx)
	defer iter.Stop()

	for {
		doc, err := iter.Next()
		if err != nil {
			if err.Error() == "iterator done" {
				break
			}
			return nil, fmt.Errorf("failed to retrieve orders: %v", err)
		}

		orderData := doc.Data()
		orders = append(orders, orderData)
	}

	return orders, nil
}

func UpdateOrder(ctx context.Context, documentID string, orderData map[string]interface{}) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("orders").Doc(documentID).Set(ctx, orderData, firestore.MergeAll)
	if err != nil {
		return fmt.Errorf("failed to update order: %v", err)
	}
	fmt.Println("Order updated successfully!")
	return nil
}

func DeleteOrder(ctx context.Context, documentID string) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("orders").Doc(documentID).Delete(ctx)
	if err != nil {
		return fmt.Errorf("failed to delete order: %v", err)
	}
	fmt.Println("Order deleted successfully!")
	return nil
}
