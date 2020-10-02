FROM ubuntu:latest

# env vars
# to do: explore Docker variable expansion logic.
ENV APP_ROOT='/labkey_apps' \
    DEPENDENCY_DIR='/tmp/dependencies'  \
    JAVA_ZIP_FILE='openjdk-13.0.2_linux-x64_bin.tar.gz' \
    JAVA_VERSION='jdk-13.0.2' \
    JAVA_HOME='/labkey_apps/apps/jdk-13.0.2' \
    TOMCAT_ZIP_FILE='apache-tomcat-9.0.38.tar.gz' \
    TOMCAT_VERSION='apache-tomcat-9.0.38'\
    TOMCAT_HOME='/labkey_apps/apps/apache-tomcat-9.0.38' \
    CATALINA_HOME='/labkey_apps/apps/apache-tomcat-9.0.38' \
    SQL_USER='sa' \
    SQL_PASSWORD='Labkey1098!' \
    LABKEY_BRANCH='release20.7-SNAPSHOT' \
    LABKEY_ROOT='/labkey' \
    LABKEY_HOME='/labkey/release20.7-SNAPSHOT' \
    PATH="$PATH:/labkey_apps/apps/jdk-13.0.2/bin:/labkey/release20.7-SNAPSHOT/build/deploy/bin" \
    USERNAME=labkey \
    DEBIAN_FRONTEND=noninteractive \
    TZ="Etc/UTC"

# mount
ADD runfiles /docker-runscripts
ADD ./dependencies /tmp/dependencies

# layers
RUN chmod +x -R /docker-runscripts
RUN /docker-runscripts/base.sh
