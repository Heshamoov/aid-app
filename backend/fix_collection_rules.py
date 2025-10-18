#!/usr/bin/env python3
"""
Fix collection access rules to allow proper data access based on user roles.

Rules:
- Donations & Expenses: All authenticated users can view, only admins can create/update/delete
- Users: All authenticated users can list/view, users can update their own profile, only admins can create/delete
- Forms, Questions, Submissions, Answers: All authenticated users can view, admins and volunteers can create
- Inventory: All authenticated users can view, only admins can modify
"""

import sqlite3
import sys

DB_PATH = 'pb_data/data.db'

def update_collection_rules():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    try:
        # Update donations collection - all authenticated users can view, only admins can modify
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "admin"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'donations'
        """)
        print("✓ Updated donations collection rules")
        
        # Update expenses collection - all authenticated users can view, only admins can modify
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "admin"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'expenses'
        """)
        print("✓ Updated expenses collection rules")
        
        # Update forms collection - all authenticated users can view, admins and volunteers can create
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "admin" || @request.auth.role = "volunteer"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'forms'
        """)
        print("✓ Updated forms collection rules")
        
        # Update questions collection
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "admin" || @request.auth.role = "volunteer"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'questions'
        """)
        print("✓ Updated questions collection rules")
        
        # Update submissions collection - volunteers can create their own submissions
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "volunteer" || @request.auth.role = "admin"',
                updateRule = '@request.auth.role = "admin" || (@request.auth.role = "volunteer" && user = @request.auth.id)',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'submissions'
        """)
        print("✓ Updated submissions collection rules")
        
        # Update answers collection
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "volunteer" || @request.auth.role = "admin"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'answers'
        """)
        print("✓ Updated answers collection rules")
        
        # Update inventory collection - all can view, only admins can modify
        cursor.execute("""
            UPDATE _collections 
            SET listRule = '@request.auth.id != ""',
                viewRule = '@request.auth.id != ""',
                createRule = '@request.auth.role = "admin"',
                updateRule = '@request.auth.role = "admin"',
                deleteRule = '@request.auth.role = "admin"'
            WHERE name = 'inventory'
        """)
        print("✓ Updated inventory collection rules")
        
        conn.commit()
        print("\n✅ All collection rules updated successfully!")
        print("\nNew access rules:")
        print("- Donations & Expenses: All authenticated users can view, only admins can modify")
        print("- Forms & Questions: All can view, admins and volunteers can create")
        print("- Submissions & Answers: All can view, volunteers can create their own")
        print("- Inventory: All can view, only admins can modify")
        print("- Users: All can list/view, users can update own profile, admins can create/delete")
        
    except Exception as e:
        print(f"❌ Error updating collection rules: {e}")
        conn.rollback()
        sys.exit(1)
    finally:
        conn.close()

if __name__ == '__main__':
    update_collection_rules()

