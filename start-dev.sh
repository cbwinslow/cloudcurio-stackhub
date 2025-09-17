#!/bin/bash

# CloudCurio StackHub Development Server Script
# This script starts the development server

echo "CloudCurio StackHub Development Server"
echo "====================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

# Check if node_modules exists in apps/web
if [ ! -d "apps/web/node_modules" ]; then
    echo "Installing dependencies..."
    cd apps/web
    npm install
    cd ../..
fi

# Start the development server
echo "Starting development server..."
echo "Open http://localhost:3000 in your browser"
cd apps/web
npm run dev