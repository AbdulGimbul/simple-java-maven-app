#!/bin/bash
if pgrep -f *.jar; then
    pkill -f *.jar
fi
cd app
java -jar *.jar &