BINARIES=main ws ws3 ws3

.PHONY: default clean

default: $(BINARIES)

clean:
	rm -f $(BINARIES)

%: %.go
	GOPATH=$$(pwd) go build -a -o $@ $<
