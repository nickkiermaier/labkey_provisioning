#!/bin/bash




JAVA_URL=https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz
TOMCAT_URL=https://downloads.apache.org/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz


if test -d ./dependencies; then
  mkdir ./dependencies
fi

wget  $JAVA_URL -P ./dependencies/ --progress=bar:force
wget  $TOMCAT_URL -P ./dependencies/ --progress=bar:force
