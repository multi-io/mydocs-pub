BINARIES=simplewaits complexwaits

.PHONY: default clean

default: $(BINARIES)

clean:
	rm -f $(BINARIES)

%: %.go
	GOPATH=$$(pwd) go build -a -o $@ $<
