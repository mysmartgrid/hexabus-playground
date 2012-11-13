BUILDDIR=build

#all: $(BUILDDIR)


$(BUILDDIR):
	@-mkdir $(BUILDDIR)

clean:
	@cd $(BUILDDIR) && rm -rf *

distclean:
	@rm -rf $(BUILDDIR)

.PHONY: clean distclean
