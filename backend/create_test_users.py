#!/usr/bin/env python3
"""
Script to create test users directly in PocketBase database
Since admin API is not accessible, we'll work directly with the users collection
"""
import requests
import json
import hashlib
import secrets
import base64

# PocketBase configuration
POCKETBASE_URL = "http://127.0.0.1:8090"

def generate_password_hash(password):
    """Generate a bcrypt-compatible password hash"""
    # Note: PocketBase uses bcrypt, but for simplicity we'll create users via API
    return password

def create_user_via_api(email, password, name, role):
    """Create a new user using the public API endpoint"""
    try:
        user_data = {
            "email": email,
            "password": password,
            "passwordConfirm": password,
            "name": name,
            "role": role,
            "emailVisibility": True
        }
        
        response = requests.post(
            f"{POCKETBASE_URL}/api/collections/users/records",
            json=user_data
        )
        
        if response.status_code == 200:
            print(f"✓ Created {role} user: {email}")
            return True
        else:
            print(f"✗ Failed to create user {email}: {response.status_code}")
            print(f"  Response: {response.text}")
            return False
    except Exception as e:
        print(f"✗ Error creating user {email}: {e}")
        return False

def test_user_login(email, password):
    """Test if a user can login"""
    try:
        response = requests.post(
            f"{POCKETBASE_URL}/api/collections/users/auth-with-password",
            json={
                "identity": email,
                "password": password
            }
        )
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Login successful for {email}")
            print(f"  User ID: {data.get('record', {}).get('id')}")
            print(f"  Role: {data.get('record', {}).get('role')}")
            return True
        else:
            print(f"✗ Login failed for {email}: {response.status_code}")
            print(f"  Response: {response.text}")
            return False
    except Exception as e:
        print(f"✗ Error testing login for {email}: {e}")
        return False

def check_existing_users():
    """Check what users already exist"""
    try:
        # Try to get users without auth (if collection allows it)
        response = requests.get(
            f"{POCKETBASE_URL}/api/collections/users/records"
        )
        if response.status_code == 200:
            users = response.json().get('items', [])
            print(f"Found {len(users)} existing users:")
            for user in users:
                print(f"  - {user.get('email')} (role: {user.get('role')})")
            return users
        else:
            print(f"Cannot list users: {response.status_code}")
            return []
    except Exception as e:
        print(f"Error checking users: {e}")
        return []

def main():
    print("=" * 60)
    print("PocketBase Test Users Setup")
    print("=" * 60)
    
    # Check existing users
    print("\n1. Checking existing users...")
    existing_users = check_existing_users()
    
    # Test login with existing user
    if existing_users:
        print("\n2. Testing login with existing user...")
        # Try the user we know exists
        test_user_login("test@example.com", "password123")
    
    # Create new test users
    print("\n3. Creating test users...")
    test_users = [
        {
            "email": "admin@example.com",
            "password": "admin123",
            "name": "Admin User",
            "role": "admin"
        },
        {
            "email": "monitor@example.com",
            "password": "monitor123",
            "name": "Monitor User",
            "role": "monitor"
        },
        {
            "email": "volunteer@example.com",
            "password": "volunteer123",
            "name": "Volunteer User",
            "role": "volunteer"
        }
    ]
    
    created_users = []
    for user in test_users:
        if create_user_via_api(user['email'], user['password'], user['name'], user['role']):
            created_users.append(user)
    
    # Test logins
    if created_users:
        print("\n4. Testing new user logins...")
        for user in created_users:
            test_user_login(user['email'], user['password'])
    
    # Print summary
    print("\n" + "=" * 60)
    print("Setup Complete!")
    print("=" * 60)
    if created_users:
        print("\nTest Users Created:")
        print("-" * 60)
        for user in created_users:
            print(f"Role: {user['role']:10} | Email: {user['email']:25} | Password: {user['password']}")
        print("-" * 60)
    print("\nYou can now login to the application using any of these accounts.")
    print("Frontend URL: http://localhost:5173/login")
    print("=" * 60)

if __name__ == "__main__":
    main()

