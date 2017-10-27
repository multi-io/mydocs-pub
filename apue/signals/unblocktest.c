#include <signal.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

void check_sigmask(const char *msg) {
    sigset_t ss;
    sigprocmask(0, 0, &ss);
    printf("%s: SIGINT blocked: %i\n", msg, sigismember(&ss, SIGINT));
}

sigjmp_buf jbuf;
volatile sig_atomic_t canjump = 0;

void sig_handler(int signum) {
    if (!canjump) {
        printf("too early signal\n");
        return;
    }
    check_sigmask("in sig handler");
    siglongjmp(jbuf, 1);
}


int main() {
    signal(SIGINT, sig_handler);

    for (volatile int i=0; i<499999999; i++) { }  // busy loop to make it easier to trigger "too early signal" race

    check_sigmask("after handler initialization");

    if (1 == sigsetjmp(jbuf, 1)) {
        check_sigmask("after handler return");
    } else {
        canjump = 1;
        printf("waiting for SIGINT...\n");
        pause();
    }
}

/*
(OSX & Linux)
$ ./unblocktest
after handler initialization: SIGINT blocked: 0
waiting for SIGINT...
^Cin sig handler: SIGINT blocked: 1
after handler return: SIGINT blocked: 0
$
*/

//19:55 < multi_io_> question: the automatic signal unblocking upon return from the signal handler -- how does that work if the handler isn't ended via sigreturn?
//19:55 < multi_io_> I just tested it, returned from the handler via longjmp. The signal still gets unblocked.

//=>
// man siglongjmp:
 //      The sigsetjmp()/siglongjmp() function pairs save and restore the signal mask if the argument savemask is non-zero; otherwise, only the register set and the stack are saved.
