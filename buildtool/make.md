---
coverY: 0
---

# make 的使用

## Make

### 简单使用

```cpp
//项目结构
.
├── h1.cpp
├── h1.h
├── h2.cpp
├── h2.h
├── main.cpp
└── makefile
```

```bash
#makefile
main: main.o h1.o h2.o
	g++ main.o h1.o h2.o -o main

mian.o:	main.cpp
	g++ main.c -c -Wall -o main.o

h1.o: h1.h h1.cpp
	g++ h1.cpp -c -Wall -o h1.o

h2.o: h1.h h1.cpp h2.cpp h2.h
	g++ h2.cpp -c -Wall -o h2.o

clean:
	rm *.o main -rf

#h1.cpp
#include "h1.h"
void h1()
{
    using namespace std;
    cout << "h1" << endl;
}

#h1.h
#pragma once
#include <iostream>
void h1();

#h2.h
#pragma once
#include <iostream>
void h2();

#h2.cpp
#include "h2.h"
#include "h1.h"
void h2()
{
    using namespace std;
    h1();
    cout << "h2" << endl;
}

#main.cpp
#include <iostream>
#include "h2.h"
using namespace std;
int main(int agrc, char **argv)
{
	h2();
	cout << "main" << endl;
	return 0;
}
```

```bash
make //构建
make clean //清楚中间文件
```

### 简化 makefile

使用变量简化

```makefile
OBJS=main.o h1.o h2.o
CC=g++
CFLAGS+=-c -Wall -g

main: $(OBJS)
	$(CC) $(OBJS) -o main

mian.o:	main.cpp
	$(CC) main.c $(CFLAGS) -o main.o

h1.o: h1.h h1.cpp
	$(CC) h1.cpp $(CFLAGS) -o h1.o

h2.o: h1.h h1.cpp h2.cpp h2.h
	$(CC) h2.cpp $(CFLAGS) -o h2.o

clean:
	$(RM) *.o main -r
#equal rm -f *.o main -r

run:
	./main

```

再简化`$^ $@`

```makefile
OBJS=main.o h1.o h2.o
CC=g++
CFLAGS+=-c -Wall -g

main: $(OBJS)
	$(CC) $^ -o $@

#$^ 为:后面的内容
#$@ 为:前面的内容

mian.o:	main.cpp
	$(CC) $^ $(CFLAGS) -o $@

h1.o: h1.h h1.cpp
	$(CC) h1.cpp $(CFLAGS) -o $@

h2.o: h1.h h1.cpp h2.cpp h2.h
	$(CC) h2.cpp $(CFLAGS) -o $@

clean:
	$(RM) *.o main -r
#equal rm -f *.o main -r

run:
	./main

```

极致简化 使用通配符

```makefile
OBJS=main.o h1.o h2.o
CC=g++
CFLAGS+=-c -Wall -g

main: $(OBJS)
	$(CC) $^ -o $@

#S^ 为:后面的内容

mian.o:	main.cpp
	$(CC) $^ $(CFLAGS) -o $@

%.o: %.cpp
	$(CC) $^ $(CFLAGS) -o $@

clean:
	$(RM) *.o main -r
#equal rm -f *.o main -r

run:
	./main

# runtime
g++ main.cpp -c -Wall -g -o main.o
g++ h1.cpp -c -Wall -g -o h1.o
g++ h2.cpp -c -Wall -g -o h2.o
g++ main.o h1.o h2.o -o main

```

### 后面还有更多内容

待续...
