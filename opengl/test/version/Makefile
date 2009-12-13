INCLUDE = -I/usr/X11R6/include/
LIBDIR  = -L/usr/X11R6/lib

COMPILERFLAGS = -g -O0 -Wall
CC = gcc
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)
CPPFLAGS = $(COMPILERFLAGS) $(INCLUDE)
LIBRARIES = -lX11 -lXi -lXmu -lglut -lGL -lGLU -lm

All: glprintversion

glprintversion: main.o
	$(CC) $(CFLAGS) -o $@ $(LIBDIR) $+ $(LIBRARIES)

clean:
	rm -f glprintversion *.o

gtags:
	if [ -f GTAGS ]; then \
		global -u; \
	else \
		gtags -I; \
	fi

depend:
	makedepend -Y *.c *.cc 2>/dev/null

# DO NOT DELETE THIS LINE -- make depend depends on it.
