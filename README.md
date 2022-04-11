PicoContainer 1.1 as forked and modified by JetBrains over the years ... but now pulled out of their codebase and in a standalone repository.

JetBrains did a bunch of work on the original: generics work and removal of all the features they didn't need.  They moved some classes to other packages. Indeed, to other buildable jars. Most likely that's because they wanted their own
api/impl split including classloader trees.  All recombined in this repo.


You would consider this v 1.9-alpha. Class `com.intellij.util.pico.DefaultPicoContainer` is the main lib entrypoint.

Apache 2 license. Multiple copyright holders and authors. Historical PicoContainer 1.1 is here: https://github.com/picocontainer/PicoContainer1

# Playing with different build technologies

## Bazel

Compile and make jar

```
bazel build //src/java/com/intellij/util/pico:PicoContainer_deploy.jar
```

You'll end up with `bazel-bin/src/java/com/intellij/util/pico/PicoContainer_deploy.jar` that is 34.5K in size.

There's a source file that doesn't compile. You'd never normally check that it, but it serves as a clear stop-the-build 
trick for the sake of comparison of build technologies.  Try it with `bazel build //src/java/org/picocontainer/redherring:RedHerring`. 
This isn't a problem for the bazel builds we count as important as nothing depends on this build target in the DAG.

JetBrains did not fork any of the original unit tests out of PicoContainer 1.1. There is one new basic test added here that we can test:

```
bazel test //src/test/org/picocontainer/tests/integration:tests
```

## Maven

Compile

```
mvn compile 
```

Compile, test compile, run tests

```
mvn test
```

Compile, test compile, run tests, and make a jar

```
mvn install 
```

## Bash scripts showing javac/java usage (no maven, no bazel)

All these should compile, test compile, run tests, and make a jar

This one uses a build in feature of javac to work out what needs to be compiled and what does not - ignoring a `RedHerring.java` that doesn't compile:

```
./wise_classic_build.sh
```

This one naively attempt to build everything in the source tree - barfing on a `RedHerring.java` that doesn't compile:

```
./naive_classic_build.sh.sh
```

This one naively attempt to build everything in the source tree with some masking out of `RedHerring.java` (that doesn't compile) using sed:

```
./naive_masked_build.sh.sh
```
