default: hello.exe staticpoly.exe gctest.exe misc_tests.exe

%.exe: %.cs
	gmcs $< -out:$@

clean:
	rm -f *exe
