BUILDDIR = build
HBC := hbcomp
HBA := hbasm
HBU := hexaupload

TARGET = playground

HBC_FILE = ../src/$(TARGET).hbc
DOT_FILE = $(TARGET).dot
ASM_PREFIX = $(TARGET)_
DATATYPEDEF = /usr/share/hexabus/std_datatypes.hb

# TODO: Develop an automatic dependency generation for this.
LAMP1_ASM = $(ASM_PREFIX)lamp1.hba
LAMP1_BIN = $(ASM_PREFIX)lamp1.hbs
LAMP1_IP = fe80::50:c4ff:fe04:83f6

all: compile graph assemble

compile: $(BUILDDIR) 
	@cd $(BUILDDIR) && $(HBC) $(HBC_FILE) -o $(ASM_PREFIX)

graph: $(BUILDDIR) 
	@cd $(BUILDDIR) && $(HBC) $(HBC_FILE) -g $(DOT_FILE)

png: $(BUILDDIR) graph
	@cd $(BUILDDIR) && dot -Tpng playground.dot -o playground.png

# TODO: One line for each device. Can this be formatted as a generic
# rule?
assemble: $(BUILDDIR) compile
	@cd $(BUILDDIR) && $(HBA) -i $(LAMP1_ASM) -o $(LAMP1_BIN) -d $(DATATYPEDEF)

upload: $(BUILDDIR) assemble
	@cd $(BUILDDIR) && $(HBU) -i $(LAMP1_IP) -p $(LAMP1_BIN)

$(BUILDDIR):
	@-mkdir $(BUILDDIR)

clean:
	@cd $(BUILDDIR) && rm -rf *

distclean:
	@rm -rf $(BUILDDIR)

.PHONY: clean distclean
