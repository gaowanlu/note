# 🅰️ 总览全局

## 为什么要学下 GO 语言

我是一名 C++开发者，我其次写过 java、web 前端开发、也对 nodejs 有些了解，但是都没在工作中用过，没有在生产环境下使用过，但是入职 C++开发游戏服务端岗位后，发现公司有些业务已经用 Go 写了。而且同事大佬们许多也都会 Go，所以不学就要落后喽，但是对于 C++仍旧持续学习新特性，深入深入再深入学习，虽然工作中写的 C++代码像 C++98，但挡不住对技术的热爱。

## 怎么学

先看一下 Go By Example 毕竟咱也是代码经验不错的开发者了，此笔记不适用于没有开发背景的人学习。我想更是从 C++视角看 Go。

## hello world

main.go,像 java 一样上来就是模块化

```go
package main

import "fmt"

func main(){
	fmt.Println("hello world")
}
```

直接运行

```bash
go run main.go
```

编译

```bash
go build main.go
```

对于 hello world 对于 C++开发应该一点压力都没有

## 值类型

- 布尔类型 bool
- 整数类型 int、int8、int16、int32、int64
- 无符号整数类型 uint、uint8、uint16、uint32、uint64、uintptr
- 浮点数类型 float32、float64
- 复数类型 complex64、complex128
- 字符串类型 string
- 字符类型 rune
- 错误类型 error

```go
package main

import "fmt"

func main(){
	fmt.Println("go"+"lang")
	//golang
	fmt.Println("1+1=",1+1)
	//1+1= 2
	fmt.Println("7.0/3.0=",7.0/3.0)
	//7.0/3.0= 2.3333333333333335
	fmt.Println(true&&false)
	//false
	fmt.Println(true||false)
	//true
	fmt.Println(!true)
	//false
}
```

这些对于科班的老鸟还不是小意思吗

## 变量

在 Go 中变量是需要显示声明的，其实和 C++差不多，Go 总之不是弱类型语言

```go
package main

import "fmt"

func main(){
	//自动推断有初始值的变量像C++的auto
	var a="initial"
	fmt.Println(a)//initial
	//var可以声明多个变量 int b,c不更优雅，有点无语
	var b,c int = 1,2;
	fmt.Println(b,c)//1 2
	var d = true
	fmt.Println(d)//true
	//默认初始化 整形的话一般为0，但是这不是规范的写法，开发中声明的变量理应都初始化
	var e int8
	fmt.Println(e)//0
	//:=为声明初始化的简写
	f := "short"
	var f_str string = "short"
	fmt.Println(f," ",f_str)//short short
}
```

在此还真没感觉 Go 很香，对于写 C/C++或者 js 的，我感觉很难接收这种写法和 Python 一样写起来别扭

## 常量

常量 const,支持字符、字符串、布尔、数值

```go
package main

import(
	"fmt"
	"math"
)

const s string = "constant string"

func main(){
	fmt.Println(s)//打印全局变量
	//constant string
	const n = 500000000;
	const d = 3e20 / n;
	fmt.Println(d)
	//6e+11
	fmt.Println(int64(d))//强制转换
	//600000000000
	fmt.Println(math.Sin(n))
	//-0.28470407323754404
}
```

Go 中的常量表达式，常量表达式是指在编译期间就可以确定结果的表达式。常量表达式可以包括数字、字符串、布尔值和枚举类型等。

```go
const Pi = 3.14159
const MaxSize int = 100
const Str = "Hello,World"
const MaxInt = 1 << 32 - 1
const MinInt = -MaxInt - 1
const IsTrue = true && false
```

常熟表达式可以执行任意精度的运算,应该编译时就已经算好了

## For 循环

先看代码,真服了还真像 Python 那种狗屎写法

```go
package main

import(
	"fmt"
)

func main(){
	var i int = 1
	for i<=3{
		fmt.Println(i)//1 2 3
		i = i + 1
	}
	for j:=7;j<=9;j++{
		fmt.Println(j)//7 8 9
	}
	for{
		fmt.Println("For Loop")
		break;//不进行break则是死循环
	}
	for n:=0;n<=5;n++{
		if n%2 == 0{
			continue
		}
		fmt.Println(n)//1 3 5
	}
}
```
