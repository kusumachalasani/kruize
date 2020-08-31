#!/bin/bash
#
# Script to build and run the acmeair application and do a test load of the app
#

ROOT_DIR=".."
source ./renaissance-common.sh
cd ${ROOT_DIR}

# Check if docker and docker-compose are installed
echo -n "Checking prereqs..."
check_prereq
echo "done"

# Commenting this out as few machines has issues creating the build.
# Build the renaissance application sources and create the docker image.
#echo -n "Building Renaissance application..."
#build_renaissance
#echo "done"

#Uses the docker image pushed in repo 
echo -n "Pull the docker image..."
pullrenaissance
echo "done"




