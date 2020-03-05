# zld autolinking issue
In some cases, [zld](https://github.com/michaeleisel/zld) is not able to autolink `libswiftCompatibility50.a` and `libswiftCompatibilityDynamicReplacements.a`. We can see error message like below.

```
Undefined symbols for architecture x86_64:
  "__swift_FORCE_LOAD_$_swiftCompatibility50", referenced from:
      __swift_FORCE_LOAD_$_swiftCompatibility50_$_foo in foo.a(foo.o)
     (maybe you meant: __swift_FORCE_LOAD_$_swiftCompatibility50_$_foo)
  "__swift_FORCE_LOAD_$_swiftCompatibilityDynamicReplacements", referenced from:
      __swift_FORCE_LOAD_$_swiftCompatibilityDynamicReplacements_$_foo in foo.a(foo.o)
     (maybe you meant: __swift_FORCE_LOAD_$_swiftCompatibilityDynamicReplacements_$_foo)
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```


To reproduce this problem, clone this repo and run `./build.sh`. You can compare with default `ld` by commenting out the line of `-fuse-ld`.

To work around the issue, we need to append `-lswiftCompatibility50 -lswiftCompatibilityDynamicReplacements`.
