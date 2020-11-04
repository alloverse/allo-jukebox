# Allo Jukebox

This is a sample project exploring Alloverse's UI APIs. 

Allo Jukebox plays retro game music, such as NES, SNES, Genesis etc
using blargg's LibGME.

## Get started

Requirements:

* A Unix system (including WSL)
* libgme (`apt install libgme-dev`)
* Git
* A bunch of nintendo music in a folder called "music" in this folder
* An alloplace to connect the app to

Application sources are in `lua/`.

To start the app and connect it to an Alloplace for testing, run

```
./allo/assist run alloplace://nevyn.places.alloverse.com
```
