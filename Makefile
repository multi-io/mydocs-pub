PUBHTMLDIR=$(HOME)/www/mydocs

update-and-publish:
	$(MAKE) update
	$(MAKE) wwwpublish

wwwpublish:
	mkdir --parents $(PUBHTMLDIR) && \
	./wwwpublish $(PUBHTMLDIR)

update:
	cvs up -Pd
