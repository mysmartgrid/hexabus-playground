BUILDDIR=build




clean:
	@cd $(BUILDDIR) && rm -rf *

distclean:
	rm -rf $(BUILDDIR)

.PHONY: clean distclean
