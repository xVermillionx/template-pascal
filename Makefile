# Makefile Pascal

# FLAGS=-Mtp -Criot -gl
INC=-Fu./Units #-Fu./

%.bin: %.pas
	fpc $(FLAGS) $(INC) $< -o$@

# Not Ideal (use top instead...)
$(patsubst %.pas,%,$(wildcard *.pas)):
	fpc $(FLAGS) $(INC) $@.pas -o$@.bin

RUN=run_
$(patsubst %.pas,$(RUN)%,$(wildcard *.pas)):
	$(subst $(RUN),./,$@).bin

.PHONY: clean all

all: $(patsubst %.pas,%.bin,$(wildcard *.pas))

clean:
	rm -rf *.o
	rm -rf *.bin
	rm -f Units/*.o
	rm -f Units/*.ppu

# meh
# %.pas: %.bin
#		fpc $(FLAGS) $@ -o$<

# all2: $(wildcard *.pas)
#
# Kurztest Pattern Matching
#
