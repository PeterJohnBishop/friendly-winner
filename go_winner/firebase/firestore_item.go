package firebase

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/firestore"
)

func AddItem(ctx context.Context, itemData map[string]interface{}) error {

	// Create a new context with a 60-second timeout
	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel() // Ensure the context is canceled when the function exits

	_, _, err := FirestoreClient.Collection("items").Add(ctx, itemData)
	if err != nil {
		return fmt.Errorf("failed to add item: %v", err)
	}
	fmt.Println("Item added successfully!")
	return nil
}

func GetAllItems(ctx context.Context) ([]map[string]interface{}, error) {
	var items []map[string]interface{}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	iter := FirestoreClient.Collection("items").Documents(ctx)
	defer iter.Stop()

	for {
		doc, err := iter.Next()
		if err != nil {
			if err.Error() == "iterator done" {
				break
			}
			return nil, fmt.Errorf("failed to retrieve items: %v", err)
		}

		itemData := doc.Data()
		items = append(items, itemData)
	}

	return items, nil
}

func GetItemById(ctx context.Context, documentID string) (map[string]interface{}, error) {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	doc, err := FirestoreClient.Collection("items").Doc(documentID).Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get item: %v", err)
	}

	data := doc.Data()
	fmt.Println("Item retrieved:", data)
	return data, nil
}

func UpdateItem(ctx context.Context, documentID string, updates map[string]interface{}) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("items").Doc(documentID).Set(ctx, updates, firestore.MergeAll)
	if err != nil {
		return fmt.Errorf("failed to update item: %v", err)
	}
	fmt.Println("Item updated successfully!")
	return nil
}

func DeleteItem(ctx context.Context, documentID string) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("items").Doc(documentID).Delete(ctx)
	if err != nil {
		return fmt.Errorf("failed to delete item: %v", err)
	}
	fmt.Println("Item deleted successfully!")
	return nil
}
