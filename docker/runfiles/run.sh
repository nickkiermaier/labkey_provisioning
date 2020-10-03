#!/bin/bash
set -e # exit if any command fails
echo "Welcome to Labkey!"
ls /labkey

## copy workspace template
echo "config intellij workspace template"
if ! test -f "$LABKEY_HOME/.idea/workspace.xml"; then
  cp "$LABKEY_HOME/.idea/workspace.template.xml" "$LABKEY_HOME/.idea/workspace.xml"
fi

# config mssql file
echo "config gradle mssql.properties"
sed -i "s|jdbcUser=sa|jdbcUser=$SQL_USER|g" $LABKEY_HOME/server/configs/mssql.properties
sed -i "s|jdbcPassword=sa|jdbcPassword=$SQL_PASSWORD|g" $LABKEY_HOME/server/configs/mssql.properties

## setup user gradle file
if ! test -d "$HOME/.gradle"; then
  mkdir "$HOME/.gradle"
  echo "config user gradle $HOME/.gradle"
  cp "$LABKEY_HOME/gradle/global_gradle.properties_template"  "$HOME/.gradle/gradle.properties"
  sed -i "s|systemProp.tomcat.home=/path/to/tomcat/home|systemProp.tomcat.home=$TOMCAT_HOME|g" "$HOME/.gradle/gradle.properties"
  echo "org.gradle.parallel=true" >> "$HOME/.gradle/gradle.properties"
  echo "org.gradle.jvmargs=-Xmx4g" >> "$HOME/.gradle/gradle.properties"
  cd "$LABKEY_HOME"
fi

# deploy the app
./gradlew
./gradlew pickMSSQL

# set correct hostnames
file=/labkey_apps/apps/apache-tomcat-9.0.38/conf/Catalina/localhost/labkey.xml
sed -i "s|jdbc:jtds:sqlserver://localhost|jdbc:jtds:sqlserver://labkey_mssql_server|" $file

./gradlew deployApp

# perms
chmod 777 -R "$LABKEY_HOME"



cd $CATALINA_HOME || exit

/labkey_apps/apps/jdk-13.0.2/bin/java  \
-agentlib:jdwp=transport=dt_socket,address=127.0.0.1:37353,suspend=n,server=y \
-Djava.io.tmpdir="$CATALINA_HOME/temp" \
-Ddevmode=true \
-ea \
-Dsun.io.useCanonCaches=false \
-Xmx8G \
-classpath "$CATALINA_HOME/bin/*" \
-Dfile.encoding=UTF-8 \
org.apache.catalina.startup.Bootstrap start