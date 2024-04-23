#include <sys/types.h>
#include <sys/syscall.h>   /* For SYS_xxx definitions */
#include <unistd.h>
#include <poll.h>
#include <unistd.h>

#include <cstdio>
#include <cstdint>


extern "C" {

// Example code from Linux pidfd_open manpage (ubuntu 20.04)

#ifndef __NR_pidfd_open
#define __NR_pidfd_open 434   /* System call # on most architectures */
#endif

int my_pidfd_open(int64_t pid, uint64_t flags){
    return syscall(__NR_pidfd_open, pid, flags);
}

int my_pidfd_wait(int64_t pidfd){
    struct pollfd pollfd;
    pollfd.fd = pidfd;
    pollfd.events = POLLIN;

    int ready = poll(&pollfd, 1, -1);
    if (ready == -1) {
        perror("poll");
        return -1;
    }

    return (pollfd.revents & POLLIN);
}

void my_pidfd_close(int64_t pidfd){
    ::close(pidfd);
}

}
