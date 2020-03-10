PHONY: build

lib/allonet/build:
	mkdir -p lib/allonet/build
	cd lib/allonet/build; \
		cmake -G "Unix Makefiles" ..

lib/allonet/build/liballonet.so: lib/allonet/build
	cd lib/allonet/build; \
		make allonet

src/liballonet.so: lib/allonet/build/liballonet.so
	cp lib/allonet/build/liballonet.so src/liballonet.so

build: src/liballonet.so

run: build
	cd src; \
		lua5.1 main.lua