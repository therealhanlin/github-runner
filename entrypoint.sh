#!/bin/bash

TOKEN=$TOKEN
REPO_URL=$REPO_URL

cd /home/actions/actions-runner

./config.sh --url ${REPO_URL} --token ${TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!