#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"

./prepare.sh
./fetch.sh
./build.sh
./zip.sh
