#!/bin/bash
#
# Script to load test acmeair app
# 

source ./acmeair-common.sh

function usage() {
	echo
	echo "Usage: $0 [Number of iterations of the jmeter load]"
	exit -1
}

MAX_LOOP=5

if [ "$#" -eq 1 ]; then
	if [[ ! "$1" =~ ^[0-9]+$ ]]; then
		usage
	else
		MAX_LOOP=$1
	fi
elif [ "$#" -ne 0 ]; then
	usage
fi

# Go back up one dir
cd ..
ROOT_DIR=${PWD}
JMX_FILE="${ROOT_DIR}/acmeair-driver/acmeair-jmeter/scripts/AcmeAir.jmx"
LOG_FILE="${ROOT_DIR}/logs/jmeter.log"

# IP addr of the server where acmeair is running (could be k8s proxy node)
get_ip

for iter in `seq 1 ${MAX_LOOP}`
do
	echo
	echo "#########################################################################################"
	echo "                             Starting Iteration ${iter}                                  "
	echo "#########################################################################################"
	echo
	
	# Change these appropriately to vary load
	JMETER_LOAD_USERS=$(( 150*iter ))
	JMETER_LOAD_DURATION=20

	# Load dummy users into the DB
	wget -O- http://${IP_ADDR}:${ACMEAIR_PORT}/rest/info/loader/load?numCustomers=${JMETER_LOAD_USERS}

	# Reset the max user id value to default
	git checkout ${JMX_FILE}

	# Calculate maximum user ids based on the USERS values passed
	MAX_USER_ID=$(( JMETER_LOAD_USERS-1 ))

	# Update the jmx value with the max user id
	sed -i 's/"maximumValue">99</"maximumValue">'${MAX_USER_ID}'</' ${JMX_FILE}

	# Run the jmeter load
	echo "Running jmeter load with the following parameters"
	echo "-Jdrivers=${JMETER_LOAD_USERS} -Jduration=${JMETER_LOAD_DURATION} -Jhost=${IP_ADDR} -Jport=${ACMEAIR_PORT} -n -t /opt/app/acmeair-driver/acmeair-jmeter/scripts/AcmeAir.jmx -DusePureIDs=true -l /opt/app/logs/jmeter.log -j /opt/app/logs/jmeter.log"

	docker run --rm -v ${PWD}:/opt/app -it dinogun/jmeter:3.1 jmeter -Jdrivers=${JMETER_LOAD_USERS} -Jduration=${JMETER_LOAD_DURATION} -Jhost=${IP_ADDR} -Jport=${ACMEAIR_PORT} -n -t /opt/app/acmeair-driver/acmeair-jmeter/scripts/AcmeAir.jmx -DusePureIDs=true -l /opt/app/logs/jmeter.log -j /opt/app/logs/jmeter.log
done
