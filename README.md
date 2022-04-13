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

JetBrains did not fork any of the original unit tests out of PicoContainer 1.1. There is one new basic test added here that we can test:

```
bazel test //src/test/org/picocontainer/tests/integration:tests
```
### Oopsies

![](https://user-images.githubusercontent.com/82182/163056846-899bcdcc-61aa-408c-8a7c-a38e310d3190.png)

There's a source file that does not compile. You'd never normally check that it, but it serves as a clear stop-the-build
trick for the sake of comparison of build technologies. Try it with `bazel build //src/java/org/picocontainer/redherring:RedHerring`.
This isn't a problem for the bazel builds we count as important as nothing depends on this BUILD target in the DAG.  
Take a [look at the directory](https://github.com/picocontainer/PicoContainer1.9/tree/main/src/java/org/picocontainer/redherring/) 
too - see the broken Java source and the BUILD file

## Maven

The maven `pom.xml` is where the build is defined. There's even a hack in there to mask out the `RedHerring.java` source.
[See here](https://github.com/picocontainer/PicoContainer1.9/tree/main/pom.xml)

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

## Bash scripts showing classic javac/java usage (no maven, no bazel)

All these SHOULD compile, test compile, run tests, and make a jar

This one uses a build in feature of javac to work out what needs to be compiled and what does not - ignoring a `RedHerring.java` that doesn't compile:

```
./wise_classic_build.sh
```

This one naively attempt to build everything in the source tree - barfing on a `RedHerring.java` that doesn't compile:

```
./naive_classic_build.sh
```

^ SHOULD but doesn't by design.

You would not have committed breaking code, but I have as this is just a demo of build technologies.

This next one naively attempt to build everything in the source tree with some masking out of `RedHerring.java` (that doesn't compile) using sed to remove it from the list of sources to compile (a cheap hack really):

```
./naive_masked_build.sh
```

Related blog entry, discussing this repo more: [More on Depth-first recursive vs DAG build technologies](https://paulhammant.com/2022/04/13/more-on-depth-first-recursive-vs-dag-build-techs)