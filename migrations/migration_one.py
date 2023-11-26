import json

import firebase_admin
from firebase_admin import credentials, auth, firestore

cred = credentials.Certificate("./service-account.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

for user in auth.list_users().iterate_all():
    print('User: ' + user.uid)

doc_ref = db.collection("users").stream()

for doc in doc_ref:
    print(f"{doc.id} => {doc.to_dict()}")

    user_info = doc.to_dict()
    email = user_info['email']

    try:
        user = auth.get_user_by_email(email)
        print(json.dumps(user.__dict__))
        db.collection("users").document(doc.id).update({"uuid": user.uid})
    except:
        print("User not found")
