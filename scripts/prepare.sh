#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

if [ ! -d "HOSTJDK" ]; then
  if [ ! -e "$HOSTJDK_FILE" ]; then
    wget "$HOSTJDK_URL" -O "$HOSTJDK_FILE"
  fi
  tar -xf "$HOSTJDK_FILE" -C "$(dirname "$HOSTJDK")"
fi
