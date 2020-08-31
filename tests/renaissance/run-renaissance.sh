#!/bin/bash

if [ -z "${TIME_LIMIT}" ]
then
	export TIME_LIMIT=660
fi

if [ -z "${JVM_OPTIONS}" ]
then
	export JVM_OPTIONS="-Xms12g -Xmx12g"
fi

if [ -z "${BENCHMARK}" ]
then
        export BENCHMARK="all"
fi

java ${JVM_OPTIONS} -jar /target/renaissance-gpl-0.10.0.jar -t ${TIME_LIMIT} --csv /output/renaissance-output.csv ${BENCHMARK} > /output/output.log
