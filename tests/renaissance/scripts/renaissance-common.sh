#!/bin/bash

LOGFILE="${ROOT_DIR}/setup.log"

function err_exit() {
        if [ $? != 0 ]; then
                printf "$*"
                echo
                echo "See ${LOGFILE} for more details"
                exit -1
        fi
}

# Check for all the prereqs
function check_prereq() {
        docker version 2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: docker not installed \nInstall docker and try again."

        docker-compose version 2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: docker-compose not installed \nInstall docker-compose and try again."
}

function build_renaissance() {

    	# pushd renaissance >>${LOGFILE}

	docker run --rm -v "$PWD":/home/gradle/project -w /home/gradle/project dinogun/gradle:5.5.0-jdk8-openj9 gradle build 2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: gradle build of acmeair monolithic application failed."

	git clone https://github.com/renaissance-benchmarks/renaissance.git 2>>${LOGFILE} >>${LOGFILE}
	err_exit "Error: git clone of renaissance benchmark failed."        

	pushd renaissance >>${LOGFILE}
	
	# Build the application
     #   tools/sbt/bin/sbt assembly 2>>${LOGFILE} >>${LOGFILE}
     #   err_exit "Error: build of renaissance application failed."

        # Build the renaissance docker image
        docker build -t renaissance:0.10 .  2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: building docker image of renaissance failed."

        popd >>${LOGFILE}
}

function pullrenaissance() {
	docker pull kusumach/renaissance:0.10 2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: Error pulling the renaissance image."
}

function run_renaissance() {

#java ${JVM_OPTIONS} -jar /target/renaissance-gpl-0.10.0.jar -t ${TIME_LIMIT} --csv /output/renaissance-output.csv ${BENCHMARK}
	echo "Command used to run the benchmark"
	echo "docker run --rm -d --name=renaissance-app -v logs:/output -e JVM_OPTIONS="-Xms12g -Xmx12g" -e BENCHMARK=all -e TIME_LIMIT=660 kusumach/renaissance:0.10 /run-renaissance.sh"
        # Run the renaissance app container
        docker run --rm -d --name=renaissance-app -v logs:/output -e JVM_OPTIONS="-Xms12g -Xmx12g" -e BENCHMARK=all -e TIME_LIMIT=660 kusumach/renaissance:0.10 /run-renaissance.sh 2>>${LOGFILE} >>${LOGFILE}
        err_exit "Error: Unable to start renaissance container."
}

