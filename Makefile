CC = lua
SOURCES = $(wildcard src/*.lua)
DATA = data
PREFIX = /usr/local

all:
	mkdir -p build/share/eu.mithos.Fons/icons/hicolor/scalable/actions
	mkdir -p build/bin/
	mkdir -p build/lib/eu.mithos.Fons
	
	gtk4-builder-tool validate $(DATA)/*.ui
	
	cp $(SOURCES) build/lib/eu.mithos.Fons/
	ln -sf ../lib/eu.mithos.Fons/main.lua build/bin/eu.mithos.Fons
	chmod +x build/bin/eu.mithos.Fons
	
	cp $(DATA)/*.ui build/share/eu.mithos.Fons/
	#cp $(DATA)/icons/*.svg build/share/eu.mithos.Fons/icons/hicolor/scalable/actions
	cp $(DATA)/texttest.css build/share/eu.mithos.Fons/texttest.css

run:
	$(CC) build/bin/eu.mithos.Fons
	@echo ""

clean:
	rm -rf build
