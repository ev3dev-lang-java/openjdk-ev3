#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

if [ ! -d "$HOSTJDK" ]; then
  if [ ! -e "$HOSTJDK_FILE" ]; then
    echo "[PREPARE] Downloading host JDK"
    wget -nv "$HOSTJDK_URL" -O "$HOSTJDK_FILE"
  else
    echo "[PREPARE] Using cached host JDK archive"
  fi
  echo "[PREPARE] Unpacking host JDK"
  tar -xf "$HOSTJDK_FILE" -C "$(dirname "$HOSTJDK")"
else
  echo "[PREPARE] Using cached host JDK directory"
fi

if [ ! -d "$JTREG" ]; then
  if [ ! -e "$JTREG_FILE" ]; then
    echo "[PREPARE] Downloading jtreg"
    wget -nv "$JTREG_URL" -O "$JTREG_FILE"
  else
    echo "[PREPARE] Using cached jtreg archive"
  fi
  echo "[PREPARE] Unpacking jtreg"
  tar -xf "$JTREG_FILE" -C "$(dirname "$JTREG")"
else
  echo "[PREPARE] Using cached jtreg directory"
fi
