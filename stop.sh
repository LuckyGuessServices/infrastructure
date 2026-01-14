#!/bin/bash

scriptDirectory=$(dirname $(readlink -f $0))
composeCmdPrefix=(docker compose --file "$scriptDirectory/docker-compose.yml")

"${composeCmdPrefix[@]}" stop
