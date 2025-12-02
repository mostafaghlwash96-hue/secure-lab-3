#!/bin/bash
# Bash script to test the HTTPS server (for Linux/macOS/WSL)
# This script demonstrates testing the HTTPS server with curl

echo "Testing HTTPS Server on https://localhost:3443"
echo ""

# Test 1: curl with -k flag (insecure, bypasses certificate verification)
echo "Test 1: curl with -k flag (bypasses certificate check)"
curl -k https://localhost:3443
echo ""
echo ""

# Test 2: curl without -k flag (should show certificate error)
echo "Test 2: curl without -k flag (should show certificate error)"
curl https://localhost:3443 2>&1
echo ""
echo ""

echo "Note: The error in Test 2 is expected behavior for self-signed certificates!"
echo "The -k flag tells curl to ignore certificate verification errors."

