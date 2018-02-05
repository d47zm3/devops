#include <sys/syscall.h>

#ifndef DOCKER_IMAGE
	#define DOCKER_IMAGE "hello-world-d47zm3"
#endif

#ifndef DOCKER_GREETING
	#define DOCKER_GREETING "Hello from Docker by d47zm3!"
#endif

const char message[] =
	"\n"
	DOCKER_GREETING "\n";
	

void _start() {
	syscall(SYS_write, 1, message, sizeof(message) - 1);

	syscall(SYS_exit, 0);
}
