#!/bin/bash
if pgrep -f my-app-1.0-SNAPSHOT.jar; then
    pkill -f my-app-1.0-SNAPSHOT.jar
fi
cd app
java -jar my-app-1.0-SNAPSHOT.jar &