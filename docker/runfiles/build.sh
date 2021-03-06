#!/bin/bash
set -e # exit if any command fails

# setup dependencies
apt-get update
apt-get upgrade -y
apt-get install -y zip unzip git curl wget nano sudo iputils-ping python3-pip

# make apps directories if not exist
if ! test -d "$APP_ROOT"; then
  mkdir "$APP_ROOT"
fi

if ! test -d "$APP_ROOT/src"; then
  mkdir "$APP_ROOT/src"
fi

if ! test -d "$APP_ROOT/apps"; then
  mkdir "$APP_ROOT/apps"
fi

# setup java
echo "Removing old Java if exists for idempotency."
rm -rf "$JAVA_HOME"
cd "$APP_ROOT/src" || exit
tar -xvzf "$DEPENDENCY_DIR/$JAVA_ZIP_FILE" -C "$APP_ROOT/apps"

# setup tomcat
echo "Removing old Tomcat if exists for idempotency."
rm -rf "$TOMCAT_HOME"
cd "$APP_ROOT/src" || exit
tar -xvzf "$DEPENDENCY_DIR/$TOMCAT_ZIP_FILE" -C "$APP_ROOT/apps"
mkdir -p "$TOMCAT_HOME/conf/Catalina/localhost"

# wipe any existing build artifacts
rm -rf $LABKEY_HOME/build