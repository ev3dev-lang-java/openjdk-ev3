#!/usr/bin/env bash

ARG_FIFO="/tmp/jshellargs"
EV3_PORT="8000"
JAR_PATH="./jshellhack.jar"
TIMEOUT="20000"

if [ "$#" -lt 1 ]; then
  echo "Please provide SSH args." >&2
  exit 1
fi

# cd to bin directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

# (re)create fifo
rm "$ARG_FIFO"
mkfifo "$ARG_FIFO"

if [ "$?" -ne 0 ]; then
  echo "Creation of argument pipe failed." >&2
  exit 2
fi

# background ssh & agent
ssh -R "$EV3_PORT:localhost:$(cat ${ARG_FIFO})" "$@" "java" "jdk.jshell.execution.RemoteExecutionControl" "$EV3_PORT" &

# foreground jshell
CLASSPATH="$JAR_PATH" ./jshell --execution "jdi:hostname(localhost),launch(false),remoteAgent(jshellhack.DumpPort),timeout($TIMEOUT)"

exit "$?"
