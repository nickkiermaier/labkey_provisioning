#!/bin/bash -e

echo $LABKEY_HOME
echo $TOMCAT_ZIP_FILE

## setup dependencies
apt-get update -y
apt-get upgrade -y
apt-get install -y zip unzip git curl wget

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


# fail and exit if branch not present
ls /labkey/$BRANCH

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
echo "config user gradle $HOME/.gradle"
rm -rf "$HOME/.gradle" && mkdir "$HOME/.gradle"
cp "$LABKEY_HOME/gradle/global_gradle.properties_template"  "$HOME/.gradle/gradle.properties"
sed -i "s|systemProp.tomcat.home=/path/to/tomcat/home|systemProp.tomcat.home=$TOMCAT_HOME|g" "$HOME/.gradle/gradle.properties"
echo "org.gradle.parallel=true" >> "$HOME/.gradle/gradle.properties"
echo "org.gradle.jvmargs=-Xmx4g" >> "$HOME/.gradle/gradle.properties"
cd "$LABKEY_HOME"

./gradlew pickMSSQL
./gradlew deployApp