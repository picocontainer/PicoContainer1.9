#!/bin/bash

set -e

find src/java -name "*.java" | sed '/RedHerring/d' > .sources.txt
javac -target 1.8 -source 1.8 -d .bin/classes/ @.sources.txt
find src/test -name "*.java" > .all_tests_for_default_picocontainer.txt
javac -target 1.8 -source 1.8 -d .bin/test-classes/ -cp .bin/classes:third_party/tests/junit.jar @.all_tests_for_default_picocontainer.txt
java -cp .bin/classes:.bin/test-classes:third_party/tests/junit.jar:third_party/tests/hamcrest-all.jar org.junit.runner.JUnitCore org.picocontainer.tests.integration.MyTests
cd .bin/classes
jar cvf ../picocontainer-1.9.jar .
cd ../..
rm .sources.txt
