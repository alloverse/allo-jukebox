# Alloverse app sample in Lua

This is a more comprehensive sample in how to build apps for
the Alloverse. `allonet/lang` includes short samples for other languages
if that's more to your taste.

## Get started

Requirements:

* A Unix system
* Lua 5.1
* CMake 3.10 or newer
* Git
* clang or gcc

1. `git submodule update --init --recursive`
2. `make run`

Or, if you prefer to not have a build environment to compile all the C stuff,
you can also download a
[CI-built `liballonet.so` from Azure Pipelines](https://dev.azure.com/alloverse/allonet/_build?definitionId=1&_a=summary),
and copy it into  `src/liballonet.so`, then:

1. `cd src`
2. `lua5.1 main.lua`