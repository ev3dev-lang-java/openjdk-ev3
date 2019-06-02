#!/bin/bash

if [ "$AUTOBUILD" -eq "1" ] || [ "$AUTOBUILD" == "yes" ]; then
    set -e

    cd "$(dirname ${BASH_SOURCE[0]})"
    source config.sh

    ./prepare.sh
    ./fetch.sh
    ./build.sh
    ./zip.sh
else
    exec bash --login
fi
