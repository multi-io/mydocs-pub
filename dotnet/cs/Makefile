default: hello.exe staticpoly.exe gctest.exe

%.exe: %.cs
	gmcs $< -out:$@

clean:
	rm -f *exe
