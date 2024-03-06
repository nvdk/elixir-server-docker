#!/bin/sh

if [ "$DEVELOPMENT" != "" ]
then
    sh /setup.sh
fi

IP_ADDRESS=`ip addr show eth0 | grep inet | grep -oP "\\d+.\\d+.\\d+.\\d+" | head -n 1`
CMD_OPTS=""
ERL_OPTS=""
ERL_OPTS="-start_epmd true"

if [ $IEX_NAME ]
then
    NODE_NAME=`echo "$IEX_NAME" | sed -e "s/@ip/@$IP_ADDRESS/"`
    CMD_OPTS="$CMD_OPTS --name $NODE_NAME"
fi

if [ $IEX_COOKIE ]
then
    CMD_OPTS="$CMD_OPTS --cookie $IEX_COOKIE"
fi

if [ $IEX_PORT ]
then
    ERL_OPTS="$ERL_OPTS -kernel inet_dist_listen_min $IEX_PORT -kernel inet_dist_listen_max $IEX_PORT"
fi

cd /app

if [ ! -z "${LOG_ELIXIR_STARTUP_COMMAND}" ]
then
  echo -n "Launching Elixir on IP $IP_ADDRESS as "
  echo "MIX_ENV=prod elixir $CMD_OPTS --erl \"$ERL_OPTS\" -pa _build/prod/consolidated -S mix run --no-halt"
fi

MIX_ENV=prod exec elixir $CMD_OPTS --erl "$ERL_OPTS" -pa _build/prod/consolidated -S mix run --no-halt
