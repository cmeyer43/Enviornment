
// Compiling this file is tricky, becuase the host machine
// wher the docker is built is no-good for building this. it has
// to run in the docker enviornmnet, which has different libc and
// probably different vdso and libgcc and ld.so sand the binary
// compiled on the host may not even work inside the docker.
// so to build this we do
//      docker run fedora:38
//      dnf install g++
//      g++ su_reaper.cc -o su_reaper
// and the resulting binary is what gets installed in the final
// docker image. kind of gross, but you gotta do what you gotta do.

#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <signal.h>
#include <inttypes.h>
#include <sys/wait.h>
#include <grp.h>
#include <vector>

static pid_t our_bash_pid = -1;
static bool run = true;

static void
sighand(int s)
{
    pid_t pid = -1;
    int status;
    if(s == SIGCHLD)
    {
        do
        {
            pid = waitpid(/*wait for any child*/-1, &status, WNOHANG);
            if (pid > 0)
            {
                if (pid == our_bash_pid)
                {
                    printf("su_reaper: detected death of our bash child "
                            "pid %d with status %d\n",
                            (uint32_t) pid, status);

                    run = false;
                }
                else
                {
                    printf("su_reaper: detected death of orphaned child "
                            "pid %u with status %d\n",
                            (uint32_t) pid, status);
                }
            }
        } while (pid > 0);
    }
}

int main(int argc, char ** argv)
{
    if (argc < 4)
    {
        fprintf(stderr, "usage: su_reaper uid gid cmd\n");
        exit(1);
    }

    int uid = atoi(argv[1]);
    int gid = atoi(argv[2]);
    std::vector<const char*> command;

    for (int ind = 3; ind < argc; ind++)
    {
        command.push_back(argv[ind]);
    }
    command.push_back(NULL);

    struct sigaction sa;
    sa.sa_handler = &sighand;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;

    sigaction(SIGCHLD, &sa, NULL);

    // set ourselves as a reaper so we get all
    // the zombiews and we can reap them and clean up.
    // otherwise zombies take over the world
    if (prctl(PR_SET_CHILD_SUBREAPER, 1) < 0)
    {
        int e = errno;
        printf("prctl SUBREAPER :%d (%s)\n",
                e, strerror(e));
    }

    int exec_error_pipe[2];
    if (pipe(exec_error_pipe) < 0)
    {
        int e = errno;
        printf("error: pipe: %d (%s)\n", 
                e, strerror(e));
    }

    // use vfork because all we're goint 
    // to do is exec a child
    pid_t pid = vfork();
    our_bash_pid = pid;

    if (pid == 0)
    {
        gid_t mygid;

        //child

        //child does not need read end of this pipe.
        close(exec_error_pipe[0]);

        // child will close write-end if exec succeeds.
        fcntl(exec_error_pipe[1], F_SETFD, FD_CLOEXEC);

#if 0
        // set my process credential
        if (docker_gid != 0)
        {
            mygid = (gid_t) docker_gid;
            setgroups(1, &mygid);
        }
        else
#endif
        {
            setgroups(0, NULL);
        }
        mygid = (gid_t) gid;
        if (setgid(mygid) < 0)
        {
            int e = errno;
            printf("error: setgid: %d (%s)\n",
                    e, strerror(e));
        }

        uid_t myuid = (uid_t) uid;
        if (setuid(myuid) < 0)
        {
            int e = errno;
            printf("error: setgid: %d (%s)\n",
                    e, strerror(e));
            return 1;
        }

        execvp(command[0], (char *const*)command.data());

        // if exec is successful, pipe[1] is CLOEXEC'd
        // and we don't get here. if exec is failed,we
        // get here and send errno back to parent.
        int e = errno;
        if (write(exec_error_pipe[1], &e, sizeof(e)) != sizeof(e))
        {
            // do nothing
        }

        // call _exit, not exit, because we don't want
        // to call registred atexit() handlers in a vfork'd
        // child
        _exit(99);
    }
    // else parent

    // parent doesn't need write-end.
    close(exec_error_pipe[1]);
    int e;
    int cc = read(exec_error_pipe[0], &e, sizeof(e));
    // parent no longer needs read-end
    close(exec_error_pipe[0]);

    // if cc == 0, the child's exec succeeded.
    // if cc == sizeof(int) then teh exec failed and we
    // are gettin an errno.
    if (cc == sizeof(e))
    {
        fprintf(stderr, "EXEC FAILED: %d (%s)\n",
                e, strerror(e));
        return 1;
    }

    // No longer anything to do but sit here catching
    // SIGCHLDS and reaping zombies.
    while (run)
    {
        // NOTE 10 seconds sounds like a long time
        // to detect our intended child is dead, but actually
        // the SIGCHLD interrupts this sleep andwe detect
        // the run==false instatntly.
        sleep(10);
    }

    // we don't have to go collect any more orphans, because we're
    // about to exit, giving up our subreaper status, which reparents
    // all our lost orphans up to init(1)

    // we also don't worry about running children, because this program
    // is intended to be run inside docker, and this exits whne docker
    // exits, and docker will clean all that crap up.

    return 0;
}
