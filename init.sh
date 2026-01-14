#!/bin/bash

scriptDirectory=$(dirname $(readlink -f $0))
composeCmdPrefix=(docker compose --file "$scriptDirectory/docker-compose.yml")

echo -e "== 1. Stop and remove containers, networks: =="

"${composeCmdPrefix[@]}" down --volumes

echo -e "##########\n"

echo -e "== 2. Create and start containers: =="

"${composeCmdPrefix[@]}" up --detach --wait

echo -e "##########\n"

echo -e "== 3. Init 'planets' service databases and users: =="

psqlContainerName="db-postgres"
psqlAuthCmdPart=(--username="rootuser" --dbname="postgres")
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
"${psqlCmdPrefix[@]}" --command="CREATE USER planets_user WITH ENCRYPTED PASSWORD 'planets_pass';" \
&& "${psqlCmdPrefix[@]}" --command="CREATE DATABASE planets OWNER planets_user;" \
&& "${psqlCmdPrefix[@]}" --command="GRANT ALL PRIVILEGES ON DATABASE planets TO planets_user;" \
\
&& "${psqlCmdPrefix[@]}" --command="CREATE USER planets_test_user WITH ENCRYPTED PASSWORD 'planets_test_pass';" \
&& "${psqlCmdPrefix[@]}" --command="CREATE DATABASE planets_test OWNER planets_test_user;" \
&& "${psqlCmdPrefix[@]}" --command="GRANT ALL PRIVILEGES ON DATABASE planets_test TO planets_test_user;"
echo -e "##########\n"
