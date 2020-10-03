#!/bin/bash -e


VARS=$(cat <<'END_HEREDOC'
export APP_ROOT='/labkey_apps'
export DEPENDENCY_DIR='/tmp/dependencies'
export JAVA_ZIP_FILE='openjdk-13.0.2_linux-x64_bin.tar.gz'
export JAVA_VERSION='jdk-13.0.2'
export JAVA_HOME='/labkey_apps/apps/jdk-13.0.2'
export TOMCAT_ZIP_FILE='apache-tomcat-9.0.38.tar.gz'
export TOMCAT_VERSION='apache-tomcat-9.0.38'
export TOMCAT_HOME='/labkey_apps/apps/apache-tomcat-9.0.38'
export CATALINA_HOME='/labkey_apps/apps/apache-tomcat-9.0.38'
export SQL_USER='sa'
export SQL_PASSWORD='Labkey1098!'
export LABKEY_BRANCH='release20.7-SNAPSHOT'
export LABKEY_ROOT='/labkey'
export LABKEY_HOME='/labkey/release20.7-SNAPSHOT'
export PATH="$PATH:/labkey_apps/apps/jdk-13.0.2/bin:/labkey/release20.7-SNAPSHOT/build/deploy/bin"
export USERNAME=labkey
export DEBIAN_FRONTEND=noninteractive
export TZ="Etc/UTC"
END_HEREDOC
)

if ! test -d /shared; then
  mkdir /shared
  chmod 777 /shared
fi

file=/shared/env_vars.sh
touch $file  && chmod 777 $file
echo "$VARS" > /shared/env_vars.sh
echo "source /shared/env_vars.sh" >> /etc/profile
echo "source /shared/env_vars.sh" >> /etc/bash.bashrc