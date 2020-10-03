#!/bin/bash
set -e # exit if any command fails


./gradlew
./gradlew deployApp
