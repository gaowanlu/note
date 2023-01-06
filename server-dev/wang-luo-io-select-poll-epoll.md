# 网络 IO 与 select、poll、epoll

## 网络 IO 与 select、poll、epoll

### 一请求一线程

```cpp
#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#define BUFFER_LENGTH	128
// thread --> fd
void *routine(void *arg) {
	int clientfd = *(int *)arg;
	while (1) {
		unsigned char buffer[BUFFER_LENGTH] = {0};
		int ret = recv(clientfd, buffer, BUFFER_LENGTH, 0);
		if (ret == 0) {
			close(clientfd);
			break;
		}
		printf("buffer : %s, ret: %d\n", buffer, ret);
		ret = send(clientfd, buffer, ret, 0); //
	}
}
// socket -->
// bash --> execve("./server", "");
//
// 0, 1, 2
// stdin, stdout, stderr
int main() {
// block
	int listenfd = socket(AF_INET, SOCK_STREAM, 0);  //
	if (listenfd == -1) return -1;
// listenfd
	struct sockaddr_in servaddr;
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(9999);
	if (-1 == bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr))) {
		return -2;
	}
#if 0 // nonblock
	int flag = fcntl(listenfd, F_GETFL, 0);
	flag |= O_NONBLOCK;
	fcntl(listenfd, F_SETFL, flag);
#endif
	listen(listenfd, 10);
#if 0
	// int
	struct sockaddr_in client;
	socklen_t len = sizeof(client);
	int clientfd = accept(listenfd, (struct sockaddr*)&client, &len);
	//printf("sendbuffer : %d\n", ret);
#else
	while (1) {
		struct sockaddr_in client;
		socklen_t len = sizeof(client);
		int clientfd = accept(listenfd, (struct sockaddr*)&client, &len);
		pthread_t threadid;
		pthread_create(&threadid, NULL, routine, &clientfd);
		//fork();
	}
#endif
}
```

### select 单线程

```cpp
#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

#define BUFFER_LENGTH	128

// thread --> fd
void *routine(void *arg) {
	int clientfd = *(int *)arg;
	while (1) {
		unsigned char buffer[BUFFER_LENGTH] = {0};
		int ret = recv(clientfd, buffer, BUFFER_LENGTH, 0);
		if (ret == 0) {
			close(clientfd);
			break;
		}
		printf("buffer : %s, ret: %d\n", buffer, ret);
		ret = send(clientfd, buffer, ret, 0); // 
	}
}
// socket --> 
// bash --> execve("./server", "");
// 
// 0, 1, 2
// stdin, stdout, stderr
int main() {
// block
	int listenfd = socket(AF_INET, SOCK_STREAM, 0);  // 
	if (listenfd == -1) return -1;
// listenfd
	struct sockaddr_in servaddr;
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(9999);
	if (-1 == bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr))) {
		return -2;
	}
#if 0 // nonblock
	int flag = fcntl(listenfd, F_GETFL, 0);
	flag |= O_NONBLOCK;
	fcntl(listenfd, F_SETFL, flag);
#endif
	listen(listenfd, 10);
#if 0
	// int 
	struct sockaddr_in client;
	socklen_t len = sizeof(client);
	int clientfd = accept(listenfd, (struct sockaddr*)&client, &len);
	unsigned char buffer[BUFFER_LENGTH] = {0};
	int ret = recv(clientfd, buffer, BUFFER_LENGTH, 0);
	if (ret == 0) {
		close(clientfd);
	}
	printf("buffer : %s, ret: %d\n", buffer, ret);
	ret = send(clientfd, buffer, ret, 0); // 
	//printf("sendbuffer : %d\n", ret);
#elif 0
	while (1) {
		struct sockaddr_in client;
		socklen_t len = sizeof(client);
		int clientfd = accept(listenfd, (struct sockaddr*)&client, &len);
		pthread_t threadid;
		pthread_create(&threadid, NULL, routine, &clientfd);
		//fork();
	}
#else
	fd_set rfds, wfds, rset, wset;
	FD_ZERO(&rfds);
	FD_SET(listenfd, &rfds);

	FD_ZERO(&wfds);

	int maxfd = listenfd;

	unsigned char buffer[BUFFER_LENGTH] = {0}; // 0 
	int ret = 0;

	// int fd, 
	while (1) {
		rset = rfds;
		wset = wfds;
		int nready = select(maxfd+1, &rset, &wset, NULL, NULL);//每次都需要给select重新拷贝
		if (FD_ISSET(listenfd, &rset)) {//判断listenfd的是否可读了
			printf("listenfd --> \n");
			struct sockaddr_in client;
			socklen_t len = sizeof(client);
			int clientfd = accept(listenfd, (struct sockaddr*)&client, &len);
			FD_SET(clientfd, &rfds);//将clientfd进行注册
			if (clientfd > maxfd) maxfd = clientfd;//更改select监听范围	
		} 
		
		int i = 0;
		for (i = listenfd+1; i <= maxfd;i ++) {//遍历所有select监听的范围
			if (FD_ISSET(i, &rset)) { //查询fd i是否可读了
				ret = recv(i, buffer, BUFFER_LENGTH, 0);
				if (ret == 0) {
					close(i);
					FD_CLR(i, &rfds);//取消监听fd i读
				} else if (ret > 0) {
					printf("buffer : %s, ret: %d\n", buffer, ret);
					FD_SET(i, &wfds);//注册监听fd i写
				}
				
			} else if (FD_ISSET(i, &wset)) {//查询是否可写了
				
				ret = send(i, buffer, ret, 0); // 
				
				FD_CLR(i, &wfds); //取消监听写
				FD_SET(i, &rfds);//注册监听读
			}
		}
	}
#endif
}

```
