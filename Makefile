all: atom bbc hexdump

clean:
	-rm basatom basbbc basatom.labels basbbc.labels basatom.hex

remake: clean all

atom: main.s65
	64tass -l basatom.labels -b main.s65 -o basatom -D BBC=0

bbc: main.s65
	64tass -l basbbc.labels -b main.s65 -o basbbc -D BBC=1
	@echo -n Start address =
	@grep start basbbc.labels

copy: bbc
	beeb blank_ssd atombas.ssd
	beeb title atombas.ssd ATOMBASIC
	beeb delete atombas.ssd -y bbcatom
	beeb putfile atombas.ssd bbcatom
	cp atombas.ssd /Volumes/GOTEK-FF

hexdump: atom
	od -A x -t x1 -t c basatom > basatom.hex
