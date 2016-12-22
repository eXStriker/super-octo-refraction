PYTHON := python
MD5 := md5sum -c --quiet

.SUFFIXES:
.PHONY: all clean prism prism00 lzcomp freespace
.SECONDEXPANSION:
.PRECIOUS: %.2bpp %.1bpp %.png %.asm %.c %.blk %.tilemap %.pal %.lz %.wav %.ded %.ctf %.bsp

poketools := extras/pokemontools
gfx       := $(PYTHON) gfx.py
includes  := $(PYTHON) $(poketools)/scan_includes.py
bank_ends := $(PYTHON) bank_ends.py
EXE := 
LZ := utils/lzcomp${EXE}
TEXTCOMP := utils/textcomp${EXE}
BSPCOMP := utils/bspcomp${EXE}
IPSPATCH := utils/ipspatch${EXE}
XORBANKS := utils/xorbanks${EXE}

prism_obj := \
wram.o \
main.o \
audio.o \
maps.o \
text.o \
gfx.o

prism_nodebug_obj := $(prism_obj:.o=_nodebug.o)

roms := pokeprism.gbc
all_roms := pokeprism.gbc pokeprism00.gbc pokeprism_nodebug.gbc

all: freespace nodebug

prism: pokeprism.gbc
prism00: pokeprism00.gbc
nodebug: pokeprism_nodebug.gbc
lzcomp: ${LZ}
textcomp: ${TEXTCOMP}
bspcomp: ${BSPCOMP}
ipspatch: ${IPSPATCH}
xorbanks: ${XORBANKS}

freespace: bank_ends.txt

${LZ}: utils/lzcomp.c
	gcc -O3 $< -o $@

${TEXTCOMP}: utils/textcomp.c
	gcc -O3 $< -o $@

${BSPCOMP}: utils/bsp/bspcomp.c
	gcc -O3 $< -o $@

${IPSPATCH}: utils/ipspatch.c
	gcc -O3 $< -o $@

${XORBANKS}: utils/xorbanks.c
	gcc -O3 $< -o $@

clean:
	rm -f $(all_roms) $(prism_obj) $(all_roms:.gbc=.map) $(all_roms:.gbc=.sym) $(LZ) ${TEXTCOMP} ${IPSPATCH} ${BSPCOMP} pokeprism.bsp

patch: all baserom.gbc ${IPSPATCH} ${BSPCOMP} ${XORBANKS}
	[ $(shell sha1sum -b baserom.gbc | cut -c 1-40) = f2f52230b536214ef7c9924f483392993e226cfb ]
	utils/ipspatch create pokeprism_nodebug.gbc pokeprism.gbc patch/debug.ips
	printf "\\thexdata %s\\n\\thexdata %s\\n" `sha1sum -b pokeprism_nodebug.gbc | cut -c 1-40` `sha1sum -b pokeprism.gbc | cut -c 1-40` > patch/hashes.txt
	utils/xorbanks baserom.gbc pokeprism_nodebug.gbc patch/xorpatch.bin
	hexdump -s 252 -n 4 -v -e '"\t" "hexdata " 4/1 "%02x" "\n"' pokeprism.gbc > patch/version.txt
	cd patch && ../utils/bspcomp patch.txt ../pokeprism.bsp && rm -f xorpatch.bin debug.ips hashes.txt version.txt

%.asm: ;

%.o: dep = $(shell $(includes) $(@D)/$*.asm)
%.o: %.asm $$(dep)
	rgbasm -DDEBUG_MODE -o $@ $<

%_nodebug.o: dep = $(shell $(includes) $(@D)/$*.asm)
%_nodebug.o: %.asm $$(dep)
	rgbasm -o $@ $<

pokeprism.gbc: $(prism_obj)
	rgblink -n pokeprism.sym -m pokeprism.map -p 0xff -o $@ $^
	rgbfix -Cjv -i PRSM -k 01 -l 0x33 -m 0x10 -p 0xff -r 3 -t PM_PRISM $@

pokeprism00.gbc: $(prism_obj)
	rgblink -n pokeprism00.sym -m pokeprism00.map -p 0x00 -o $@ $^
	rgbfix -Cjv -i PRSM -k 01 -l 0x33 -m 0x10 -p 0x00 -r 3 -t PM_PRISM $@

pokeprism_nodebug.gbc: $(prism_nodebug_obj)
	rgblink -n pokeprism_nodebug.sym -m pokeprism_nodebug.map -p 0xff -o $@ $^
	rgbfix -Cjv -i PRSM -k 01 -l 0x33 -m 0x10 -p 0xff -r 3 -t PM_PRISM $@


%.png: ;
%.2bpp: %.png ; $(gfx) 2bpp $<
%.1bpp: %.png ; $(gfx) 1bpp $<
%.lz: % ${LZ} ; $(LZ) $< $@
%.txt: ;
bank_ends.txt: prism prism00 ; $(bank_ends) > $@

%.wav: ;
%.ded: %.wav dedenc.py ; $(PYTHON) dedenc.py $< $@

%.pal: %.2bpp ;
gfx/pics/%/normal.pal gfx/pics/%/bitmask.asm gfx/pics/%/frames.asm: gfx/pics/%/front.2bpp ;
%.bin: ;
%.blk: ;
%.tilemap: ;

%.ctf: %.asm macros/charmap.asm ${TEXTCOMP} ; ${TEXTCOMP} macros/charmap.asm $< $@
