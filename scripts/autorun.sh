#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

./prepare.sh
./fetch.sh
./build.sh
./zip.sh
