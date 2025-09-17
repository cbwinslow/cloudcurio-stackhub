#!/bin/bash

# CloudCurio StackHub Local Test Script
# This script starts the development server locally

echo "CloudCurio StackHub Local Test Script"
echo "==================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
if ! command_exists node; then
    echo "Error: Node.js is not installed. Please install Node.js and try again."
    exit 1
fi

if ! command_exists npm; then
    echo "Error: npm is not installed. Please install npm and try again."
    exit 1
fi

echo "Installing dependencies..."
cd apps/web
npm install

if [ $? -ne 0 ]; then
    echo "Failed to install dependencies. Please check your network connection and try again."
    exit 1
fi

echo "Starting development server..."
echo "The application will be available at http://localhost:3000"
echo "Press Ctrl+C to stop the server"
echo ""

npm run dev