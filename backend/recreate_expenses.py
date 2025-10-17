#!/usr/bin/env python3
import requests
import json
import csv

# PocketBase admin credentials
ADMIN_EMAIL = "admin@test.com"
ADMIN_PASSWORD = "admin1234"
PB_URL = "http://127.0.0.1:8090"

# Login as admin
print("Logging in as admin...")
auth_response = requests.post(f"{PB_URL}/api/admins/auth-with-password", json={
    "identity": ADMIN_EMAIL,
    "password": ADMIN_PASSWORD
})

if auth_response.status_code != 200:
    print(f"Login failed: {auth_response.text}")
    exit(1)

token = auth_response.json()["token"]
headers = {"Authorization": token}

print("✅ Logged in successfully")

# Get the expenses collection ID
print("\nFetching expenses collection...")
collections_response = requests.get(f"{PB_URL}/api/collections", headers=headers)
collections = collections_response.json()

expenses_collection = None
for col in collections:
    if col["name"] == "expenses":
        expenses_collection = col
        break

if not expenses_collection:
    print("❌ Expenses collection not found!")
    exit(1)

collection_id = expenses_collection["id"]
print(f"✅ Found expenses collection: {collection_id}")

# Delete the collection
print("\nDeleting old expenses collection...")
delete_response = requests.delete(f"{PB_URL}/api/collections/{collection_id}", headers=headers)
if delete_response.status_code in [200, 204]:
    print("✅ Old collection deleted")
else:
    print(f"⚠️  Delete response: {delete_response.status_code} - {delete_response.text}")

# Create new expenses collection with proper schema
print("\nCreating new expenses collection...")
new_collection = {
    "name": "expenses",
    "type": "base",
    "schema": [
        {
            "name": "category",
            "type": "text",
            "required": True
        },
        {
            "name": "amount",
            "type": "number",
            "required": True
        },
        {
            "name": "currency",
            "type": "text",
            "required": True
        },
        {
            "name": "description",
            "type": "text",
            "required": True
        },
        {
            "name": "status",
            "type": "select",
            "required": True,
            "options": {
                "maxSelect": 1,
                "values": ["Pending", "Approved", "Rejected"]
            }
        },
        {
            "name": "transaction_date",
            "type": "date",
            "required": False
        },
        {
            "name": "vendor_supplier",
            "type": "text",
            "required": False
        },
        {
            "name": "project_campaign",
            "type": "text",
            "required": False
        },
        {
            "name": "receipt_invoice_number",
            "type": "text",
            "required": False
        },
        {
            "name": "notes",
            "type": "text",
            "required": False
        }
    ]
}

create_response = requests.post(f"{PB_URL}/api/collections", json=new_collection, headers=headers)
if create_response.status_code in [200, 201]:
    print("✅ New expenses collection created")
    new_collection_data = create_response.json()
    print(f"   Collection ID: {new_collection_data['id']}")
else:
    print(f"❌ Failed to create collection: {create_response.status_code}")
    print(create_response.text)
    exit(1)

# Restore the data
print("\nRestoring expense data...")
with open('expenses_backup.csv', 'r') as f:
    reader = csv.DictReader(f)
    count = 0
    for row in reader:
        expense_data = {
            "category": row["category"],
            "amount": float(row["amount"]),
            "currency": row["currency"],
            "description": row["description"],
            "status": row["status"],
            "transaction_date": row["transaction_date"] if row["transaction_date"] else None
        }
        
        response = requests.post(f"{PB_URL}/api/collections/expenses/records", json=expense_data, headers=headers)
        if response.status_code in [200, 201]:
            count += 1
            print(f"   ✅ Restored: {row['description']}")
        else:
            print(f"   ❌ Failed to restore {row['description']}: {response.text}")

print(f"\n✅ Restored {count} expenses")
print("\n🎉 Done! Expenses collection recreated successfully")

