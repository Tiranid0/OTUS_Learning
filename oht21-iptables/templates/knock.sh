#!/bin/bash

if [ "$1" == "close" ]; then
    PORTS="9000 8000 7000"
elif [ "$1" == "open" ]; then
    PORTS="7000 8000 9000"
else
    echo "Usage: $0 [open|close] HOST"
    exit 1
fi

HOST="$2"

if [ -z "$HOST" ]; then
    echo "Host not specified"
    echo "Usage: $0 [open|close] HOST"
    exit 1
fi

knock $HOST $PORTS
