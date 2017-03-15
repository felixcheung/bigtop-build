#!/bin/bash

AMBARI_BLUEPRINT_PATH=`pwd`/blueprint.json
AMBARI_BLUEPRINT_NAME=BIGTOP-1.0
AMBARI_SHELL_PATH=/tmp/ambari-shell.jar
WN_COUNT=${1:-2}

echo "Stopping previous cluster if it is running..."
docker-compose down

echo "Starting cluster..."
docker-compose up -d
docker-compose scale workernode=$WN_COUNT

HN_NAME=$(docker-compose exec headnode hostname | tr -d '\r')
WN_NAMES=$(docker-compose ps -q workernode)
WN_JOIN_CMD=""
NL=$'\n'

for WN_NAME in $WN_NAMES; do
  WN_NAME=${WN_NAME:0:12}
  WN_JOIN_CMD="${WN_JOIN_CMD}cluster assign --host $WN_NAME --hostGroup workernode $NL"
done

if [ ! -f $AMBARI_SHELL_PATH ]; then
  echo "Downloading ambari-shell to $AMBARI_SHELL_PATH ..."
  ./get-ambari-shell.sh $AMBARI_SHELL_PATH
fi

AMBARI_SHELL_SCRIPT_PATH=$(mktemp /tmp/ambari-script.XXXXXX)
echo "Generating ambari-shell script $AMBARI_SHELL_SCRIPT_PATH"

cat << EOF > $AMBARI_SHELL_SCRIPT_PATH
blueprint add --file $AMBARI_BLUEPRINT_PATH
cluster build --blueprint $AMBARI_BLUEPRINT_NAME
cluster assign --host $HN_NAME --hostGroup headnode
$WN_JOIN_CMD
cluster create
EOF

printf "Waiting for ambari-server to start"
until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
  printf "."
  sleep 1
done
printf "\n"

printf "Waiting ambari-agents to register with ambari-server"
until [ $((WN_COUNT + 1)) -eq $(curl -sSu admin:admin http://localhost:8080/api/v1/hosts | grep -co host_name) ]; do
  printf "."
  sleep 1
done
printf "\n"

pushd /tmp
cat $AMBARI_SHELL_SCRIPT_PATH - | java -jar $AMBARI_SHELL_PATH --ambari.user=admin
popd
rm $AMBARI_SHELL_SCRIPT_PATH
