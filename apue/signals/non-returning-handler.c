#include <signal.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//jmp_buf jbuf;

void alarm_handler(int signum) {
    // a signal handler doesn't HAVE to ever return.  if it does not,
    // it doesn't have to care about not messing up the main program's
    // data structures by calling non-reentrant functions (because the
    // main program will never be invoked again, at least not via the
    // normal signal-return mechanism (see sigreturn(2))).
    //
    // Instead, the handler can do anything it wants, including
    // calling non-reentrant functions or even execing other
    // programs...
    
    printf("in alarm_handler, execing vim...\n");
    execl("/usr/bin/vim", "/usr/bin/vim", NULL);
    perror("execl failed");
    exit(1);

    // longjmp would be a non-sigreturn way to return control back to
    // the main routine (which must've called setjmp() before the
    // signal was delivered). The longjmp would simply "unwind" the
    // stack, thereby discarding the saved process state (register
    // contents etc.)  that the kernel has stored on the stack.
    //
    // This has practical applications; e.g. for avoiding certain race
    // conditions; see APUE 10.10 "alarm and pause Functions"

    //longjmp(jbuf, 1);
}


int main() {
    signal(SIGALRM, alarm_handler);
    printf("sleeping...\n");
    alarm(3);
    pause();
}
