#!/bin/bash

ROOT_DIR=".."
source ./petclinic-common.sh
cd ${ROOT_DIR}

docker stop petclinic-app

docker network rm ${NETWORK}
