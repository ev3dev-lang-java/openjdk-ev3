#!/bin/bash

echo hello $1!

sudo docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile  system
