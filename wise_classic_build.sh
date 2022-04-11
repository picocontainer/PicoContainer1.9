#!/bin/bash

set -e

cd src/java/
# Javac can determine the other sources that are imported by a single taget source and compile them too
javac -target 1.8 -source 1.8  -d ../../.bin/classes/ com/intellij/util/pico/DefaultPicoContainer.java
cd ../test/
javac -target 1.8 -source 1.8 -d ../../.bin/test-classes/ -cp ../../.bin/classes:../../third_party/tests/junit.jar org/picocontainer/tests/integration/MyTests.java
cd ../..
java -cp .bin/classes:.bin/test-classes:third_party/tests/junit.jar:third_party/tests/hamcrest-all.jar org.junit.runner.JUnitCore org.picocontainer.tests.integration.MyTests
cd  .bin/classes
jar cvf ../picocontainer-1.9.jar .
cd ../..