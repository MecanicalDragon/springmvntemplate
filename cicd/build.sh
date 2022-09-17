#!/bin/dash

# Black        0;30    Blue         0;34    Dark Gray     1;30     Light Blue    1;34
# Red          0;31    Purple       0;35    Light Red     1;31     Light Purple  1;35
# Green        0;32    Cyan         0;36    Light Green   1;32     Light Cyan    1;36
# Brown/Orange 0;33    Light Gray   0;37    Yellow        1;33     White         1;37

FAINT="\033[0m"
RED="\033[0;31m"
GREEN="\033[32;1m"
BLUE="\033[34;1m"

echoWithTime() {
  echo "${BLUE}[$(date +%T)]$FAINT $1"
}

echoGreen() {
  echoWithTime "$GREEN$1$FAINT"
}

echoRed() {
  echoWithTime "$RED$1$FAINT"
}

SCRIPT_PROFILE="local"

WAIT_USER_INPUT=true
BUILD_LOCALLY=false
RUN_CONTAINER=true
MVN_CLEAN=true
SKIP_TESTS=true
VERBOSE=true

IMAGE_NAME="springmvntemplate-image"
DOCKER_IMAGE_TAG="latest"
DOCKERFILE="Dockerfile-springmvntemplate-local"
CONTAINER_NAME="springmvntemplate-app"

SKIP_TESTS_CMD="-Dmaven.test.skip=true"
BUILD_EXTRA_KEYS="-Dmaven.test.skip=true"
RUN_EXTRA_KEYS=""
PORT=5454

for arg in "$@"
do
case $arg in
  -v=*|--verbose=*)
    VERBOSE="${arg#*=}"
  ;;

  -w=*|--wait-user-input=*)
    WAIT_USER_INPUT="${arg#*=}"
  ;;

  -t=*|--tag=*)
    DOCKER_IMAGE_TAG="${arg#*=}"
  ;;

  -d=*|--dockerfile=*)
    DOCKERFILE="${arg#*=}"
  ;;

  -r=*|--run=*)
    RUN_CONTAINER="${arg#*=}"
  ;;

  -c=*|--clean=*)
    MVN_CLEAN="${arg#*=}"
  ;;

  -b=*|--build=*)
    BUILD_LOCALLY="${arg#*=}"
  ;;

  -s=*|--skip-tests=*)
    SKIP_TESTS="${arg#*=}"
  ;;

  -p=*|--port=*)
    PORT="${arg#*=}"
  ;;

  -e=*|--build-extra-keys=*)
    BUILD_EXTRA_KEYS="${arg#*=}"
  ;;

  -k=*|--run-keys=*)
    RUN_EXTRA_KEYS="${arg#*=}"
  ;;

  *)
  echoRed "Unknown user input: ${arg}"
  if [ "$WAIT_USER_INPUT" = "true" ]
  then
    echoRed "Press any key to exit...
    "
    while [ true ] ; do
#      Bash case:
#      read -t 3 -n 1
#      Dash case:
      read -r DONE
      if [ $? = 0 ] ; then
        exit ;
      fi
    done
  else
    exit
  fi
  ;;
esac
done

echoWithTime "Stopping and removing old container..."

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

if [ $SKIP_TESTS = false ]
then
  SKIP_TESTS_CMD=""
fi

if [ $MVN_CLEAN = true ]
then
  echoWithTime "mvn clean..."
  cd ../
  mvn clean
  cd cicd || exit
fi

if [ $BUILD_LOCALLY = true ]
then
  echoWithTime "mvn clean package..."
  cd ../
  mvn clean package "$SKIP_TESTS_CMD"
  cd cicd || exit
fi

echoWithTime "Building docker image ${IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
echo "-----------------------------------------------------------------------------------------------------------"

if [ $VERBOSE = true ]
then
  docker build --build-arg EXTRA_KEYS=$BUILD_EXTRA_KEYS -t "${IMAGE_NAME}":"${DOCKER_IMAGE_TAG}" -f $DOCKERFILE ../
else
  EFFECTIVE_CMD="docker build --build-arg EXTRA_KEYS=$BUILD_EXTRA_KEYS -t $IMAGE_NAME:$DOCKER_IMAGE_TAG -f $DOCKERFILE ../"
  echoWithTime "Effective command running in background is '$EFFECTIVE_CMD'"
  echoWithTime "Please, wait. It may take some time."
  RESULT=$(${EFFECTIVE_CMD})
  echoWithTime "Result: $RESULT"
fi

if [ $RUN_CONTAINER = true ]
then
  echoWithTime "Running container..."
  docker run -d -p=$PORT:$PORT ${RUN_EXTRA_KEYS} --name $CONTAINER_NAME $IMAGE_NAME:$DOCKER_IMAGE_TAG

  until [ "$(curl --silent -o /dev/null -w %{http_code} http://localhost:${PORT}/actuator/health/readinessState)" = "200" ]; do
    echoWithTime "Application is starting - waiting..."
    sleep 1
  done
fi

echoGreen "DONE"

# End of logic.

if [ "$WAIT_USER_INPUT" = "true" ]
  then
    echo "Verify job is done...
    "
    while [ true ] ; do
#      Bash case:
#      read -t 3 -n 1
#      Dash case:
      read -r DONE
      if [ $? = 0 ] ; then
        exit ;
      fi
    done
  else
    echoGreen "Job is done."
    exit
fi