#!/bin/bash

echo "Setting up common configurations..."

# Checking the operating system type
if command -v yum &> /dev/null; then
  # CentOS/RHEL
  sudo yum update -y
  sudo yum install -y unzip curl jq zip
elif command -v apt-get &> /dev/null; then
  # Ubuntu/Debian
  sudo apt-get update -y
  sudo apt-get install -y unzip curl jq zip
else
  echo "Unsupported operating system."
  exit 1
fi

# Set environment variables if needed
export COMMON_VARIABLE="some_value"

echo "Common setup complete."
