#!/usr/bin/env python3
"""
Script to create test users in PocketBase with known passwords
"""
import requests
import json

# PocketBase configuration
POCKETBASE_URL = "http://127.0.0.1:8090"

def create_admin_session():
    """Login as admin to get auth token"""
    try:
        response = requests.post(
            f"{POCKETBASE_URL}/api/admins/auth-with-password",
            json={
                "identity": "admin@test.com",
                "password": "admin123456"
            }
        )
        if response.status_code == 200:
            data = response.json()
            return data.get('token')
        else:
            print(f"Admin login failed: {response.status_code}")
            print(response.text)
            return None
    except Exception as e:
        print(f"Error logging in as admin: {e}")
        return None

def get_users_collection_id(token):
    """Get the users collection ID"""
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{POCKETBASE_URL}/api/collections", headers=headers)
        if response.status_code == 200:
            collections = response.json()
            for collection in collections:
                if collection.get('name') == 'users':
                    return collection.get('id')
        return None
    except Exception as e:
        print(f"Error getting collections: {e}")
        return None

def delete_existing_users(token):
    """Delete all existing users"""
    try:
        headers = {"Authorization": f"Bearer {token}"}
        # Get all users
        response = requests.get(
            f"{POCKETBASE_URL}/api/collections/users/records",
            headers=headers
        )
        if response.status_code == 200:
            users = response.json().get('items', [])
            for user in users:
                user_id = user.get('id')
                delete_response = requests.delete(
                    f"{POCKETBASE_URL}/api/collections/users/records/{user_id}",
                    headers=headers
                )
                if delete_response.status_code == 204:
                    print(f"Deleted user: {user.get('email')}")
                else:
                    print(f"Failed to delete user {user.get('email')}: {delete_response.status_code}")
    except Exception as e:
        print(f"Error deleting users: {e}")

def create_user(token, email, password, name, role):
    """Create a new user with specified details"""
    try:
        headers = {"Authorization": f"Bearer {token}"}
        
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
            headers=headers,
            json=user_data
        )
        
        if response.status_code == 200:
            print(f"✓ Created {role} user: {email} (password: {password})")
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
            print(f"✓ Login test successful for {email}")
            return True
        else:
            print(f"✗ Login test failed for {email}: {response.status_code}")
            print(f"  Response: {response.text}")
            return False
    except Exception as e:
        print(f"✗ Error testing login for {email}: {e}")
        return False

def main():
    print("=" * 60)
    print("PocketBase Test Users Setup")
    print("=" * 60)
    
    # Login as admin
    print("\n1. Logging in as admin...")
    admin_token = create_admin_session()
    if not admin_token:
        print("Failed to login as admin. Please ensure:")
        print("  - PocketBase is running")
        print("  - Admin account exists with email: admin@test.com")
        print("  - Admin password is: admin123456")
        return
    
    print("✓ Admin login successful")
    
    # Delete existing users
    print("\n2. Cleaning up existing users...")
    delete_existing_users(admin_token)
    
    # Create test users
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
        if create_user(admin_token, user['email'], user['password'], user['name'], user['role']):
            created_users.append(user)
    
    # Test logins
    print("\n4. Testing user logins...")
    for user in created_users:
        test_user_login(user['email'], user['password'])
    
    # Print summary
    print("\n" + "=" * 60)
    print("Setup Complete!")
    print("=" * 60)
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

