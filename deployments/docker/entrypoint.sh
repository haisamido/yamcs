#!/usr/bin/env bash

mvn ${MAVEN_HTTPS_PROXY} -f "./examples/${YAMCS_EXAMPLE}/pom.xml" yamcs:run

tail -f /dev/null
