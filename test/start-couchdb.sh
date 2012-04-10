#!/usr/bin/env bash -l

set -v
set -e

COUCHDB_PID=couchdb &
wait $COUCHDB_PID
