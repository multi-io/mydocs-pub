PUBHTMLDIR=$(HOME)/www/mydocs

.PHONY: update-and-publish wwwpublish update

default: wwwpublish-cs

update-and-publish:
	$(MAKE) update
	$(MAKE) wwwpublish

wwwpublish:
	mkdir --parents $(PUBHTMLDIR) && \
	./wwwpublish $(PUBHTMLDIR)

wwwpublish-cs: wwwpublish
	cd $(PUBHTMLDIR) && \
	tar cz . | ssh butterfly.cs.tu-berlin.de 'cd www/mydocs; gtar xz'


update:
	cvs up -Pd
