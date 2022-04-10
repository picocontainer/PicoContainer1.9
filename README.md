PicoContainer 1.1 as forked and modified by JetBrains but then pulled out of their codebase and in a standalone repo

JetBrains did a bunch of work on the original: generics work and removal of all the features they didn't need.  They moved some classes to other packages. Indeed to other buildable jars. Most likely that's cose they wanted their own
api/impl split including classloader trees.  All recombined in this repo.

Building:

```
bazel build //src/java/com/intellij/util/pico:PicoContainer
```

There's no tests - they were not forked by JetBrains.

You'll end up with `bazel-bin/PicoContainer.jar` that is 34.5K in size. 

You would consider this v 1.9-alpha. Class `com.intellij.util.pico.DefaultPicoContainer` is the main lib entrypoint.

Apache 2 license. Multiple copyright holders and authors. Historical PicoContainer 1.1 is here: https://github.com/picocontainer/PicoContainer1
    