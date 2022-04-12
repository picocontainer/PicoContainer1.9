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

There's a source file that doesn't compile. You'd never normally check that it, but it serves as a clear stop-the-build
trick for the sake of comparison of build technologies. Try it with `bazel build //src/java/org/picocontainer/redherring:RedHerring`.
This isn't a problem for the bazel builds we count as important as nothing depends on this BUILD target in the DAG.  
Take a [look at the directory](https://github.com/picocontainer/PicoContainer1.9/tree/main/src/java/org/picocontainer/redherring/) 
too - see the broken Java source and the BUILD file

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

You woud not have committed breaking code, but I have as this is just a demo of build technologies.

This next one naively attempt to build everything in the source tree with some masking out of `RedHerring.java` (that doesn't compile) using sed to remove it from the list of sources to compile (a cheap hack really):

```
./naive_masked_build.sh
```

# Mucking around with Git's Sparse Checkout

This feature came with Git 2.25 (Jan 2020). I had listed it as something that was needed in [June 2019](https://paulhammant.com/2019/06/14/merkle-trees-and-source-control/) but who knows whether the git leads read my blog entry. See also my [update to the same list](https://paulhammant.com/2020/01/19/vcs-nirvana/) in Jan 2020.

```
git sparse-checkout init --cone
git sparse-checkout set third_party src/java/org/picocontainer/defaults "src/java/org/picocontainer/*.java" "src/java/org/picocontainer/BUILD" src/java/org/jetbrains src/java/com src/test README.md pom.xml "*.sh" WORKSPACE ".all*"
```

This elaborate modification to the checkout allow the `RedHerring.java` to be ignored in all situations. Specifically `./naive_classic_build.sh` build passes instead of fails. Whereas `naive_masked_build.sh` asked out the reg herring via sed trick, this new way doesn't need to hide the dir/file as it is no longer there.

Git sparse checkout has 'set' for a big list as above. This smushes prior settings each time you use it. It also has 'add' which adds new patterns to the list it had before. I think 'remove' is needed. My case above could be just:

```
git sparse-checkout init --cone
git sparse-checkout remove src/java/org/picocontainer/redherring 
```

Mucking around this way, gives you a glimpse of what Google's Blaze would readily do for committers in their monorepo subsetting down from many hundreds of different team's permutation of directories for meaningful buildable deployables.