#!/bin/bash
#
# Script to build and run the petclinic application and do a test load of the app
# 

ROOT_DIR=".."
source ./petclinic-common.sh
cd ${ROOT_DIR}

# Check if docker and docker-compose are installed
echo -n "Checking prereqs..."
check_prereq
echo "done"

# Get the IP of the current box
get_ip

# Build the petclinic application sources and create the docker image
echo -n "Building petclinic application..."
build_petclinic
echo "done"

# Build the jmeter docker image with the petclinic driver
echo -n "Building jmeter with petclinic driver..."
build_jmeter
echo "done"

# Run the application and mongo db
echo -n "Running petclinic with inbuilt db..."
run_petclinic
echo "done"

# Wait for the app to come up
#sleep 10

# Start the jmeter load
#echo "Starting jmeter load..."
#start_jmeter_load
