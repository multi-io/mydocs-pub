PUBHTMLDIR=$(HOME)/public_html/multi-io.github.com/mydocs
REMOTE_SERVER=some.server.com

.PHONY: wwwpublish wwwpublish-remote ghpublish

default:
	@echo 'see the Makefile for publishing options'

wwwpublish:
	mkdir -p $(PUBHTMLDIR) && \
	./wwwpublish $(PUBHTMLDIR)

wwwpublish-remote: wwwpublish
	cd $(PUBHTMLDIR) && \
	tar cz . | ssh $(REMOTE_SERVER) 'cd public_html/mydocs; gtar xz'

ghpublish:
	./gh-publish

