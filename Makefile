all: basatom basbbc basatom.hex

clean:
	-rm basatom basbbc basatom.labels basbbc.labels basatom.hex basbbc.ssd

remake: clean all diff

basatom basatom.labels: main.s65
	64tass -l basatom.labels -b main.s65 -o basatom -D BBC=0

basbbc basbbc.labels: main.s65
	64tass -l basbbc.labels -b main.s65 -o basbbc -D BBC=1
	@echo -n Start address =
	@grep start basbbc.labels

basatom.hex: basatom
	head -c 4096 basatom | od -A x -t x1 -t a > basatom.hex

diff: basatom.hex
	diff basatom-orig.hex basatom.hex

.PHONY: copy
copy: basbbc
	-beeb blank_ssd basbbc.ssd
	-beeb title basbbc.ssd ATOMBASIC
	-beeb delete basbbc.ssd -y basbbc
	-beeb putfile basbbc.ssd basbbc
