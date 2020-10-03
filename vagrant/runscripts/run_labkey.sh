#!/bin/bash -e


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