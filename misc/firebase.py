#!/usr/bin/env python

# Usage: python firebase.py
 
import pyrebase 

config = { 
    "apiKey": "FIREBASE_API_KEY", 
    "authDomain": "FIREBASE_AUTH_DOMAIN_ID.firebaseapp.com", 
    "databaseURL": "https://FIREBASE_AUTH_DOMAIN_ID.firebaseio.com", 
    "storageBucket": "FIREBASE_AUTH_DOMAIN_ID.appspot.com"
}

firebase = pyrebase.initialize_app(config)
db = firebase.database()

print(db.get())