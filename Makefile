project = rpg

sim: $(project).mif
	sim $< res/charmap.mif

%.easm : src/%.asm
	gcc -E -x c -P $< -o $@

%.mif : %.easm
	montador $< $@

.PHONY: clean

clean:
	rm -f $(project).mif *.easm
