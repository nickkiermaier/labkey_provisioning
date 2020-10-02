#!/bin/bash
set -e # exit if any command fails
echo "Welcome to Labkey!"
ls /labkey

# first run
if ! test -f /etc/first-run-complete; then
  echo "RUNNING FIRST RUN SCRIPT."
  /bin/bash /docker-runscripts/first-run.sh
fi

# perms
chmod 777 -R "$LABKEY_HOME"

# run labkey
/bin/bash /docker-runscripts/run-labkey.sh




