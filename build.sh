#!/bin/bash
set -e

find src/java -name "*.java" > .sources.txt
javac -d .bin/classes/ @.sources.txt
cd .bin/classes
jar cvf ../picocontainer-1.9.jar .
cd ../..