# find . -name '*xpm' | xargs -i basename {} .xpm | xargs -i make-misc {}.png


%.pnm: %.xpm
	xpmtoppm <$< >$@

%.pnm_alpha: %.xpm
	xpmtoppm --alphaout=- <$< >$@

%.png: %.pnm %.pnm_alpha
	pnmtopng -alpha $*.pnm_alpha <$*.pnm >$@

# fallback when no .pnm_alpha is available
%.png: %.pnm
	pnmtopng <$< >$@

xpms=$(shell echo *.xpm)
pngs=$(xpms:.xpm=.png)

default: $(pngs)


clean:
	rm -f $(pngs)
