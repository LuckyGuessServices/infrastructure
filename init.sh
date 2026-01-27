#!/bin/bash

scriptDirectory=$(dirname $(readlink -f $0))
composeCmdPrefix=(docker compose --file "$scriptDirectory/docker-compose.yml")
source ./.env

echo -e "== 1. Stop and remove containers, networks: =="

"${composeCmdPrefix[@]}" down --volumes

echo -e "##########\n"

echo -e "== 2. Create and start containers: =="

"${composeCmdPrefix[@]}" up --detach --wait

echo -e "##########\n"

echo -e "== 3. Init 'planets' service databases and users: =="

psqlContainerName="db-postgres"
psqlAuthCmdPart=(--username="${PSQL_ROOT_USER_NAME}" --dbname="${PSQL_ROOT_DB}")
psqlCmdPrefix=(${composeCmdPrefix[@]} exec $psqlContainerName psql ${psqlAuthCmdPart[@]})

# Firstly, ensure PostgreSQL is ready to accept commands:
timeStart=$(date +%s%N)
until "${composeCmdPrefix[@]}" exec $psqlContainerName pg_isready "${psqlAuthCmdPart[@]}" > /dev/null 2>&1; do
  sleep 0.1
done
timeElpasedNano=$(($(date +%s%N) - timeStart))
timeElapsedSeconds=$(awk "BEGIN {printf \"%.3f\", $timeElpasedNano/1000000000}")
echo "Postgres became ready for commands in: $timeElapsedSeconds seconds."

# Finally execute the commands:
"${psqlCmdPrefix[@]}" --command="CREATE USER \"${PSQL_MAIN_USER_NAME}\" WITH ENCRYPTED PASSWORD '${PSQL_MAIN_USER_PASS}';" \
&& "${psqlCmdPrefix[@]}" --command="CREATE DATABASE \"${PSQL_MAIN_DB}\" OWNER \"${PSQL_MAIN_USER_NAME}\";" \
\
&& "${psqlCmdPrefix[@]}" --command="CREATE USER \"${PSQL_TEST_USER_NAME}\" WITH ENCRYPTED PASSWORD '${PSQL_TEST_USER_PASS}';"
echo -e "##########\n"

echo -e "== 4. Install / Update go tools: =="
source ./cli/install-go-tools.sh
echo -e "##########\n"
