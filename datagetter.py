import firebase_admin
from firebase_admin import credentials, firestore

# Initialize the app with a service account, granting admin privileges
cred = credentials.Certificate("path/to/serviceAccount.json")
firebase_admin.initialize_app(cred)

# Get a reference to the Firestore service
db = firestore.client()

# Get a reference to the "users" collection
users_ref = db.collection("users")

# Retrieve all documents in the "users" collection
docs = users_ref.stream()

for doc in docs:
    print(doc.id, "=>", doc.to_dict())
