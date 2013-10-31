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
PLUG1_ASM = $(ASM_PREFIX)plug1.hba
PLUG1_BIN = $(ASM_PREFIX)plug1.hbs
PLUG1_IP = fd00:c:3fe8:82b3:50:c4ff:fe04:8383
PLUG2_ASM = $(ASM_PREFIX)plug2.hba
PLUG2_BIN = $(ASM_PREFIX)plug2.hbs
PLUG2_IP = fd00:c:3fe8:82b3:50:c4ff:fe04:82b2
PLUG3_ASM = $(ASM_PREFIX)plug3.hba
PLUG3_BIN = $(ASM_PREFIX)plug3.hbs
PLUG3_IP = fd00:c:3fe8:82b3:50:c4ff:fe04:82c2
PLUG4_ASM = $(ASM_PREFIX)plug4.hba
PLUG4_BIN = $(ASM_PREFIX)plug4.hbs
PLUG4_IP = fd00:c:3fe8:82b3:50:c4ff:fe04:8100

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
	cd $(BUILDDIR) && $(HBA) -i $(PLUG1_ASM) -o $(PLUG1_BIN) -d $(DATATYPEDEF)
	cd $(BUILDDIR) && $(HBA) -i $(PLUG2_ASM) -o $(PLUG2_BIN) -d $(DATATYPEDEF)
	cd $(BUILDDIR) && $(HBA) -i $(PLUG3_ASM) -o $(PLUG3_BIN) -d $(DATATYPEDEF)
	cd $(BUILDDIR) && $(HBA) -i $(PLUG4_ASM) -o $(PLUG4_BIN) -d $(DATATYPEDEF)

upload: $(BUILDDIR) assemble
	cd $(BUILDDIR) && $(HBU) -i $(PLUG1_IP) -p $(PLUG1_BIN)
	cd $(BUILDDIR) && $(HBU) -i $(PLUG2_IP) -p $(PLUG2_BIN)
	cd $(BUILDDIR) && $(HBU) -i $(PLUG3_IP) -p $(PLUG3_BIN)
	cd $(BUILDDIR) && $(HBU) -i $(PLUG4_IP) -p $(PLUG4_BIN)

$(BUILDDIR):
	@-mkdir $(BUILDDIR)

clean:
	@cd $(BUILDDIR) && rm -rf *

distclean:
	@rm -rf $(BUILDDIR)

.PHONY: clean distclean
