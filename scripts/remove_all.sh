#!/bin/sh

containers=$(docker ps -aq)
if [ -n "$containers" ]; then
  docker rm -f $containers
else
  echo "No containers found."
fi
