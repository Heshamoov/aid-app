#!/bin/bash

# Aid Platform Startup Script
# This script starts both backend and frontend services

APP_DIR="$HOME/aid-app"
LOG_DIR="$APP_DIR/logs"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

echo "========================================="
echo "Starting Aid Platform..."
echo "========================================="

# Check if services are already running
if pgrep -f "pocketbase serve" > /dev/null; then
    echo "⚠️  Backend is already running"
else
    echo "Starting Backend (PocketBase)..."
    cd "$APP_DIR/backend"
    nohup ./pocketbase serve --http=127.0.0.1:8090 > "$LOG_DIR/backend.log" 2>&1 &
    echo "✅ Backend started on http://127.0.0.1:8090"
fi

# Wait for backend to be ready
sleep 3

if pgrep -f "vite.*dev" > /dev/null; then
    echo "⚠️  Frontend is already running"
else
    echo "Starting Frontend (Web Interface)..."
    cd "$APP_DIR/frontend"
    nohup pnpm run dev > "$LOG_DIR/frontend.log" 2>&1 &
    echo "✅ Frontend started on http://localhost:5173"
fi

# Wait for frontend to be ready
sleep 5

echo ""
echo "========================================="
echo "✅ Aid Platform is ready!"
echo "========================================="
echo ""
echo "Opening application in browser..."
echo ""

# Open browser (works on most Linux systems)
if command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:5173" 2>/dev/null &
elif command -v gnome-open > /dev/null; then
    gnome-open "http://localhost:5173" 2>/dev/null &
elif command -v open > /dev/null; then
    open "http://localhost:5173" 2>/dev/null &
else
    echo "Please open your browser and go to: http://localhost:5173"
fi

echo ""
echo "📝 Logs are saved in: $LOG_DIR"
echo "🛑 To stop the app, run: $APP_DIR/stop-aid-app.sh"
echo ""

