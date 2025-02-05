package firebase

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/firestore"
)

func AddUser(ctx context.Context, uid string, userData map[string]interface{}) error {

	// Since interface{} is the empty interface, it can store values of any type (strings, integers, booleans, structs, etc.).

	// Create a new context with a 60-second timeout
	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel() // Ensure the context is canceled when the function exits

	_, err := FirestoreClient.Collection("users").Doc(uid).Set(ctx, userData)
	if err != nil {
		return fmt.Errorf("failed to add user: %v", err)
	}
	fmt.Println("User added successfully!")
	return nil
}

func GetAllUsers(ctx context.Context) ([]map[string]interface{}, error) {
	var users []map[string]interface{}

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	iter := FirestoreClient.Collection("users").Documents(ctx)
	defer iter.Stop()

	for {
		doc, err := iter.Next()
		if err != nil {
			if err.Error() == "iterator done" {
				break
			}
			return nil, fmt.Errorf("failed to retrieve users: %v", err)
		}

		userData := doc.Data()
		userData["uid"] = doc.Ref.ID // Include document ID in response
		users = append(users, userData)
	}

	return users, nil
}

func GetUserById(ctx context.Context, uid string) (map[string]interface{}, error) {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	doc, err := FirestoreClient.Collection("users").Doc(uid).Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %v", err)
	}

	data := doc.Data()
	fmt.Println("User retrieved:", data)
	return data, nil
}

func UpdateUser(ctx context.Context, uid string, updates map[string]interface{}) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("users").Doc(uid).Set(ctx, updates, firestore.MergeAll)
	if err != nil {
		return fmt.Errorf("failed to update user: %v", err)
	}
	fmt.Println("User updated successfully!")
	return nil
}

func DeleteUser(ctx context.Context, uid string) error {

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	_, err := FirestoreClient.Collection("users").Doc(uid).Delete(ctx)
	if err != nil {
		return fmt.Errorf("failed to delete user: %v", err)
	}
	fmt.Println("User deleted successfully!")
	return nil
}
