#!/bin/bash

WAIT_USER_INPUT="true"

for i in "$@"
do
case $i in

  -w=*|--wait-user-input=*)
  WAIT_USER_INPUT="${i#*=}"
  ;;

  *)
  echo "Unknown user input: ${i}"
  if [ "$WAIT_USER_INPUT" = "true" ]
    then
      echo "Job is interrupted due to unknown arg. Press any key to finish.
      "
      while [ true ] ; do
        read -t 3 -n 1
        if [ $? = 0 ] ; then
          exit ;
        fi
      done
#    else
#      exit
  fi
  ;;
esac
done

# Logic below:

echo "Running sonar..."
docker-compose -f sonar.yaml up -d

# End of logic.

if [ "$WAIT_USER_INPUT" = "true" ]
  then
    echo "Verify job is done...
    "
    while [ true ] ; do
      read -t 3 -n 1
      if [ $? = 0 ] ; then
        exit ;
      fi
    done
  else
    echo "Job is done."
#    exit
fi