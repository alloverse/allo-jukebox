PHONY: build run

lib/allonet/build:
	mkdir -p lib/allonet/build
	cd lib/allonet/build; \
		cmake -G "Unix Makefiles" ..

lib/allonet/build/liballonet.so: lib/allonet/build
	cd lib/allonet/build; \
		make allonet

liballonet.so: lib/allonet/build/liballonet.so
	cp lib/allonet/build/liballonet.so liballonet.so

build: liballonet.so

run: build
	cd src; \
		luajit main.lua $(ALLO)