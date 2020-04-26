# Allo Jukebox

Alloverse currently only has a low level world representation and interaction
API; but it wants to have a high-level UI API for easily building applications
with very few lines of code.

This project attempts to explore such UI APIs, emulating e g UIKit. It's using
Lua since that's the most up-to-date bridge in allonet at the moment.

## Get started

Requirements:

* A Unix system (including WSL)
* luajit (could be made to work with lua 5.1 with some effort)
* libgme (`apt install libgme-dev`)
* CMake 3.10 or newer
* Git
* clang or gcc

1. `git submodule update --init --recursive`
2. `make run`

Or, if you prefer to not have a build environment to compile all the C stuff,
you can also download a
[CI-built `liballonet.so` from Azure Pipelines](https://dev.azure.com/alloverse/allonet/_build?definitionId=1&_a=summary),
and copy it into  `liballonet.so`, then:

1. `cd src`
2. `luajit main.lua`
