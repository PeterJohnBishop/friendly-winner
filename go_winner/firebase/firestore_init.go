package firebase

import (
	"context"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
)

var (
	FirestoreClient *firestore.Client
	// initOnce        sync.Once // Ensures initialization happens only once
)

// InitFirebase initializes Firebase and Firestore
func InitFirestore() {
	// Ensures this runs only once
	fmt.Println("Initializing Firebase...")
	opt := option.WithCredentialsFile("firebase/friendly-winner-firebase-adminsdk-fbsvc-4c5d6990e6.json")

	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Fatalf("Error initializing Firebase app: %v", err)
	}

	// Initialize Firestore
	FirestoreClient, err = app.Firestore(context.Background())
	if err != nil {
		log.Fatalf("Error initializing Firestore: %v", err)
	}

	fmt.Println("Firebase Firestore initialized successfully!")

}

// CloseFirestore should be called when the server is shutting down
func CloseFirestore() {
	if FirestoreClient != nil {
		FirestoreClient.Close()
	}
}
