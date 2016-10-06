#!/bin/bash
run_server() {
  echo "Starting RStudio server..."
  /usr/lib/rstudio-server/bin/rserver --server-daemonize 0
}

SPARK_HOME="/opt/spark/spark-2.0.0-bin-hadoop2.7/"

run_server & 

trap "{ deactivate; exit 0; }" SIGTERM SIGINT

# infinite loop so container doesn't exit.
while true; do :; done
