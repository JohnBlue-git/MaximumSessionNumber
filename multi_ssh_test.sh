#!/bin/bash

attemptNum=0
successNum=0
failNum=0
num_connections=0

usage() {
    echo "Usage: $0 <hostname> <num_connections> <duration>"
    exit 1
}

if [ "$#" -ne 3 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

hostname=$1
username='root'
password='0penBmc'
num_connections=$2
duration=$3

lock() {
    eval "exec 200>/tmp/lockfile"
    flock -n 200 && return 0 || return 1
}

unlock() {
    flock -u 200
    rm -f /tmp/lockfile
}

create_ssh_connection() {
    local hostname=$1
    local duration=$2
    ((attemptNum++))

    sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$hostname" "sleep $duration" &
    if [ $? -eq 0 ]; then
        ((successNum++))
    else
        ((failNum++))
    fi
}

create_connections_in_batches() {
    local hostname=$1
    local duration=$2
    local num_connections=$3
    local batch_size=50
    local delay=1
    local i=0

    while [ $i -lt $num_connections ]; do
        for ((j=0; j<batch_size; j++)); do
            if [ $((i+j)) -lt $num_connections ]; then
                create_ssh_connection $hostname $duration &
            fi
        done
        wait
        sleep $delay
        ((i+=batch_size))
    done
}

create_connections_in_batches $hostname $duration $num_connections

# Print results
echo "Connection Success: $successNum"
echo "Connection Fail: $failNum"
echo "All connections attempted and closed after the specified duration."
