PREFIX=${PARSECDIR}/pkgs/libs/pascal-releases/inst/${PARSECPLAT}

all: 
	@echo "NOP" > /dev/null

clean:
	@echo "NOP" > /dev/null

install:
	mkdir -p $(PREFIX)
	cp -rf * $(PREFIX)
	@rm $(PREFIX)/Makefile
	rm -rf obj


.PHONY: all clean install
