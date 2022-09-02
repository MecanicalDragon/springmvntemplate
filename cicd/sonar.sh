#!/bin/sh

SONAR_PROFILE="sonar-for-springmvntemplate"
PROJECT_KEY="springmvntemplate"

echo "Running sonar data pushing task...
"
cd ../
mvn sonar:sonar -P${SONAR_PROFILE} -Dsonar.projectKey=${PROJECT_KEY}

echo "DONE
"