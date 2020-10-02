#!/bin/bash
set -e # exit if any command fails

ls /labkey


## copy workspace template
echo "config intellij workspace template"
if ! test -f "$LABKEY_HOME/.idea/workspace.xml"; then
  cp "$LABKEY_HOME/.idea/workspace.template.xml" "$LABKEY_HOME/.idea/workspace.xml"
fi

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
./gradlew deployApp

# configure the tomcat configuration files
# REMOVING LABKEY.XML
rm /labkey_apps/apps/apache-tomcat-9.0.38/conf/Catalina/localhost/labkey.xml
cp /docker-runscripts/labkey.xml /labkey_apps/apps/apache-tomcat-9.0.38/conf/Catalina/localhost
cat /labkey_apps/apps/apache-tomcat-9.0.38/conf/Catalina/localhost/labkey.xml


# mark first run complete
touch /etc/first-run-complete