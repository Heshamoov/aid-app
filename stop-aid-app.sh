#!/bin/bash

# Aid Platform Stop Script
# This script stops both backend and frontend services

echo "========================================="
echo "Stopping Aid Platform..."
echo "========================================="

# Stop PocketBase
if pgrep -f "pocketbase serve" > /dev/null; then
    echo "Stopping Backend (PocketBase)..."
    pkill -f "pocketbase serve"
    echo "✅ Backend stopped"
else
    echo "⚠️  Backend was not running"
fi

# Stop Vite frontend
if pgrep -f "vite.*dev" > /dev/null; then
    echo "Stopping Frontend..."
    pkill -f "vite.*dev"
    echo "✅ Frontend stopped"
else
    echo "⚠️  Frontend was not running"
fi

echo ""
echo "========================================="
echo "✅ Aid Platform stopped successfully"
echo "========================================="
echo ""

