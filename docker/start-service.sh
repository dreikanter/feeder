#!/bin/bash

#------------ Usage details for shell script starts here ----------------
usage()
{
  echo
  echo "Usage: $0 -s -k -h"
  echo
  echo "    -s start feeder service"
  echo "    -k stop feeder service"
  echo "    -h this text"
  echo
}

while getopts ':skh' opt; do
    case $opt in
        s)  START_SERVICE=1
            ;;
        k)  STOP_SERVICE=1
            ;;
        h)  usage
            exit 1
            ;;
    esac
done
#------------ Usage details for shell script ends here ----------------

#------------- Code to start feeder service starts here ---------------
if [[ ${START_SERVICE} -eq "1" ]]; then
  echo "Starting feeder service and postgres db..."
  docker-compose up -d

  FEEDER_APP_CONTAINER_ID=$(docker ps --filter "name=feederapp-container" -q)
  FEEDER_DB_CONTAINER_ID=$(docker ps --filter "name=feederdb-container" -q)

  if [[ -z ${FEEDER_DB_CONTAINER_ID} ]]; then
    echo "postgres db is not running"
    exit 5
  fi

  if [[ -z ${FEEDER_APP_CONTAINER_ID} ]]; then
    echo "feeder service is not running"
    docker-compose down
    exit 5
  fi

  echo "Migrating tables to postgres db..."
  docker exec $FEEDER_APP_CONTAINER_ID /bin/sh -c "bundle exec rake db:migrate"

  echo "Starting webpack service..."
  docker exec -d $FEEDER_APP_CONTAINER_ID /bin/sh -c "./bin/webpack-dev-server"

  IS_SERVER_UP=$(curl -Is http://localhost:3000/ | head -n 1)
  if [[ -z ${IS_SERVER_UP} ]]; then
    echo "Error in reaching feeder service. Check docker container logs"
  else
    sleep 20s # wait for the webpack to load js files
    echo "feeder service and postgres db is started"
  fi
fi
#------------- Code to start feeder service ends here ---------------

#------------- Code to stop feeder service starts here ---------------
if [[ ${STOP_SERVICE} -eq "1" ]]; then
  docker-compose down
fi
#------------- Code to stop feeder service ends here ---------------