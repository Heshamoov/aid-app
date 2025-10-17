#!/bin/bash
# Reset admin password for PocketBase

cd /home/ubuntu/aid-app/backend

# Stop PocketBase if running
pkill -f pocketbase
sleep 2

# Create a new admin using PocketBase CLI
echo "Creating new admin account..."
./pocketbase admin create admin@test.com admin123456 <<EOF
admin123456
EOF

echo ""
echo "Admin account created/updated:"
echo "Email: admin@test.com"
echo "Password: admin123456"
echo ""
echo "Starting PocketBase server..."
./pocketbase serve --http=127.0.0.1:8090 &

sleep 3
echo "PocketBase is running on http://127.0.0.1:8090"

