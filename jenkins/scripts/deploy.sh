#!/bin/bash
if pgrep -f my-app-1.0-SNAPSHOT.jar.jar; then
    pkill -f my-app-1.0-SNAPSHOT.jar.jar
fi
cd app
java -jar my-app-1.0-SNAPSHOT.jar.jar &