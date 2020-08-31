#!/bin/bash
#
# Script to run the renaissance application 
#

source ./renaissance-common.sh
cd ..
ROOT_DIR=${PWD}

#Run the application
echo "Running the renaissance app"
run_renaissance
echo "It runs in background..Check the mounted logs for output"
