#!/bin/bash
#
# Script to build and run the acmeair application and do a test load of the app
# 

ROOT_DIR=".."
source ./acmeair-common.sh
cd ${ROOT_DIR}

# Check if docker and docker-compose are installed
echo -n "Checking prereqs..."
check_prereq
echo "done"

# Get the IP of the current box
get_ip

# Build the acmeair application sources and create the docker image
echo -n "Building acmeair application..."
build_acmeair
echo "done"

# Build the acmeair driver sources
echo -n "Building acmeair driver..."
build_acmeair_driver
echo "done"

# Build the jmeter docker image with the acmeair driver
echo -n "Building jmeter with acmeair driver..."
build_jmeter
echo "done"

# Run the application and mongo db
echo -n "Running acmeair and mongo db..."
run_acmeair
echo "done"

# Wait for the app to come up
#sleep 10

# Start the jmeter load
#echo "Starting jmeter load..."
#start_jmeter_load
