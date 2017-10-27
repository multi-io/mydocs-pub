```
17:58 < multi_io> from APUE chapter 10 (signals): https://github.com/jivoi/junk/blob/master/apue-3e/signals/sleep2.c
17:58 < multi_io> how can longjmp() out of a signal handler work??
17:59 < multi_io> I thought the kernel needed to do special things after you return from a signal handler.
17:59 < multi_io> like, restore the previous context.
17:59 < multi_io> it looks to me like that longjmp would just return to sleep2 and then to sleep2's caller, all still in the "context" of the signal handler execution.
18:00 < LiamW> afaik signal handlers don't need to return
18:07 < multi_io> LiamW: how else would control be returned to the place where the signal suspended the main program's execution?
18:08 < LiamW> via vdso sigreturn
18:08 < LiamW> but if you don't call that it doesn't return
18:32  * multi_io reads sigreturn(2)
```



NAME
       sigreturn, rt_sigreturn - return from signal handler and cleanup stack frame

SYNOPSIS
       int sigreturn(...);

DESCRIPTION

       If the Linux kernel determines that an unblocked signal is
       pending for a process, then, at the next transition back to
       user mode in that process (e.g., upon return from a system call
       or when the process is rescheduled onto the CPU), it saves
       various pieces of process context (processor status word,
       registers, signal mask, and signal stack settings) into the
       user-space stack.

       The kernel also arranges that, during the transition back to
       user mode, the signal handler is called, and that, upon return
       from the handler, control passes to a piece of user-space code
       commonly called the "signal trampoline".  The signal trampoline
       code in turn calls sigreturn().

       This sigreturn() call undoes everything that was done --
       changing the process's signal mask, switching signal stacks
       (see sigaltstack(2)) -- in order to invoke the signal handler.
       It restores the process's signal mask, switches stacks, and
       restores the process's context (processor flags and registers,
       including the stack pointer and instruction pointer), so that
       the process resumes execution at the point where it was
       interrupted by the signal.



```
20:00 < multi_io> does a vDSO function run in kernel mode or user mode?
20:00 < sortie> User-space
20:00 < multi_io> sortie: then what's the difference to a regular library function?
20:01 < sortie> Allows the kernel to decide at runtime
20:01 < sortie> The kernel can put code there that doesn't have any extra permissions, but it has knowledge of how to best do something
20:01 < sortie> For instance, to get the current time, it might know about a special kernel page that is read-only to user-space, but contains the current time. Saves a system call.
20:02 < multi_io> ok, so it IS technically a normal library function, just one that's provided by the kernel because it contains highly kernel-specific usermode code?
20:04 < sortie> Yes
20:05 < sortie> Which isn't really a normal library function
20:05 < sortie> But it is user-space code that libc knows how to find and use

20:48 < multi_io> so to come back to my question about signal handler invocations: the kernel only stores the main program's process state on the stack and transfers control to the handler and then forgets about it immediately?
20:48 < multi_io> i.e. it doesn't track a per-process "currently executing a signal handler" state

(and restoring the process state and transferring control back to the
place where the signal suspended the main program's execution -- if
desired -- would be done via sigreturn(2), i.e. in user space or at
least statelessly in kernel space)

20:51 < sortie> multi_io: That is correct
20:52 < sortie> multi_io: Though actually in my kernel, the kernel does keep a counter of how many signals have been delivered, and how many have been returned from. If both counters are equal and a signal is returned from, that means something is wrong, and my kernel
                aborts the process. The sigreturn system call loads every register and usually in a predictable location, so hackers like to use it, so I deny them that.
20:52 < sortie> But that's a constant amount of memory for N signals
20:58 < multi_io> sortie: thanks
```



## EINTR

(APUE 10.5)

Syscalls that may be interrupted by signals: open, close, read, write
(to "slow devices" like terminals, not for disk I/O??), pause, some
ioctls, Some of the interprocess communication functions.

Historically, implementations derived from System V fail the system
call (with errno==EINTR), whereas BSD-derived implementations return
partial success (e.g. read() returns a half-filled buffer). With the
2001 version of the POSIX.1 standard, the BSD-style semantics are
required. To summarize:

- System V: abort with EINTR

- POSIX: return partial success


### Automatic Syscall Restarts

To prevent applications from having to handle interrupted system
calls, 4.2BSD introduced the automatic restarting of certain
interrupted system calls. The system calls that were automatically
restarted are ioctl, read, readv, write, writev, wait, and waitpid.

Since this caused a problem for some applications that didn’t want the
operation restarted if it was interrupted, systems now allow the
process to disable this feature on a per-signal basis (via the
`SA_RESTART` flag to `sigaction`)

When using `signal` rather than `sigaction`:

- System V: no restart

- Linux, FreeBSD, macOS: restart
