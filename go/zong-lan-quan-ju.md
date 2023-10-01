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

## 基本类型

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

## 值类型与引用类型

值类型（Value Types）是指变量直接存储值本身，它们在赋值或传递给函数时会被复制。以下是一些 Go 语言中的值类型：

- 基本类型（Primitive Types）：如整数类型（int、int8、int16、int32、int64）、浮点数类型（float32、float64）、布尔类型（bool）、字符类型（rune）、字符串类型（string）等。
- 数组类型（Array Types）：数组是一种固定长度的值类型，它包含相同类型的一系列元素。
- 结构体类型（Struct Types）：结构体是由一系列具有不同类型的字段组成的自定义类型。

引用类型（Reference Types）是指变量存储的是值的内存地址，而不是值本身。它们在赋值或传递给函数时，复制的是指向底层数据的指针。以下是一些 Go 语言中的引用类型：

- 切片类型（Slice Types）：切片是一个动态数组，它依赖于底层数组，可以动态增长和缩小。
- 映射类型（Map Types）：映射是一种无序的键值对集合。
- 通道类型（Channel Types）：通道用于在 goroutine 之间进行通信，实现同步和数据传输。
- 函数类型（Function Types）：函数也是引用类型，可以作为参数传递和返回值。

需要注意的是，虽然切片和映射看起来像是引用类型，但它们实际上是引用类型的包装器，底层仍然是值类型。

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

## IF ELSE

Go 中没有三目运算符，if 支持定义语句作用域变量和 for 一样

```go
package main

import "fmt"

func main() {
	if 0 == 7%2 {
		fmt.Println("7 is even")
	} else {
		fmt.Println("8 is odd")
	}
	if num := 9; num < 0 {
		fmt.Println(num, "is negative")
	} else if num < 10 {
		fmt.Println(num, "has 1 digit")
	} else {
		fmt.Println(num, "has multiple digits")
	}
}

/*
8 is odd
9 has 1 digit
*/
```

## switch

go 的 switch 不支持使用 break，但是支持用 fallthrough 执行所在 case 后执行下一个 case。go 的 switch 支持定义变量

go 的 switch 语句可以用于对以下类型匹配

- 整数类型（int、int8、int16、int32、int64）
- 无符号整数类型（uint、uint8、uint16、uint32、uint64、uintptr）
- 浮点数类型（float32、float64）
- 复数类型（complex64、complex128）
- 字符串类型（string）
- 接口类型（interface）
- 字符类型（rune）
- 布尔类型（bool）

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	i := 2
	fmt.Print("write ", i, " as ")
	switch i {
	case 1:
		fmt.Println("one")
	case 2:
		fmt.Println("two")
	case 3:
		fmt.Println("three")
	}
	//write 2 as two
	switch time.Now().Weekday() {
	case time.Saturday, time.Sunday:
		fmt.Println("It's the weekend")
	default:
		fmt.Println("It's a weekday")
	}
	//It's the weekend
	t := time.Now()
	fmt.Println(t) //2023-08-05 17:31:51.7226392 +0800 CST m=+0.011514601
	switch {
	case t.Hour() < 12:
		fmt.Println("It's before noon")
	default:
		fmt.Println("It's after noon")
	}
	//It's after noon
	//看是那种接口类型的实现
	whatAmI := func(i interface{}) {
		switch t := i.(type) {
		case bool:
			fmt.Println("I'm a bool")
		case int:
			fmt.Println("I'm an int")
		default:
			fmt.Printf("Don't know type %T\n", t)
		}
	}
	whatAmI(true) //I'm a bool
	num := 100
	whatAmI(num)     //I'm an int
	whatAmI("hello") //Don't know type string
}
```

## 数组

在 go 中数组是一个具有编号且长度固定的元素序列,起始但从数组这来看，go 是有点香的对吧，比起 C 的要方便不少

```go
package main

import "fmt"

func main() {
	var arrInt [5]int
	fmt.Println("arrInt:", arrInt)
	//emp: [0 0 0 0 0]
	arrInt[4] = 444
	fmt.Println("arrInt:", arrInt)
	//arrInt: [0 0 0 0 444]
	fmt.Println("ele:", arrInt[4])
	//ele:  444
	//获取数组长度
	fmt.Println("len:", len(arrInt))
	//5
	//初始化
	b := [5]int{1, 2, 3, 4, 5}
	fmt.Println(b)
	//[1 2 3 4 5]
	//多维数组
	var twoD [2][3]int
	for i := 0; i < len(twoD); i++ {
		for j := 0; j < len(twoD[i]); j++ {
			twoD[i][j] = i + j
		}
	}
	fmt.Println("2d:", twoD)
	//2d: [[0 1 2] [1 2 3]]
	threeD := [2][2][2]int{{{1, 2}, {1, 2}}, {{1, 2}, {1, 2}}}
	fmt.Println("3d", threeD)
	//3d [[[1 2] [1 2]] [[1 2] [1 2]]]
}
```

## 切片

Go 语言中的切片（slice）是一种动态数组，它提供了对数组的部分或全部元素的访问和操作。切片是引用类型，它底层依赖于数组，但具有更灵活的长度和容量。
有点像 C++的 std::vector 喽

其实 Go 中没有真的数组，下面我们来看下，出下列外还可以进行 copy 与多维切片之类的，在此先不展开阐述，仅为本章知识总揽全局。我们 C++程序员先了解了解就好。

```go
package main

import "fmt"

func main() {
	//1.声明一个切片类型
	var s []int
	s = []int{1, 2, 3}   //初始化切片
	s1 := []int{1, 2, 3} //简写
	//2.可以使用内置函数len与cap获取切片的长度和容量
	fmt.Println(len(s))  //3
	fmt.Println(cap(s))  //3
	fmt.Println(len(s1)) //3
	//3.可以使用索引访问与修改元素
	s[1] = 666
	fmt.Println(s[1]) //666
	fmt.Println(s)    //[1 666 3]
	//4.支持切片表达式获取子切片
	s2 := []int{1, 2, 3, 4, 5}
	subS2 := s2[0:2]    //下标0到下标1
	fmt.Println(subS2)  //[1 2]
	fmt.Println(s2[:])  //[1 2 3 4 5]
	fmt.Println(s2[:3]) //[1 2 3]
	fmt.Println(s2[1:]) //[2 3 4 5]
	//这种切片骚操作有点像Python了其实
	//5.可以用append函数向切片末尾追加元素
	s3 := []int{1, 2, 3}
	s3 = append(s3, 4)
	fmt.Println(s3) //[1 2 3 4]
	//6.切片可以用make函数创建指定长度和容量的切片
	s4 := make([]int, 3, 5) //长度3容量5
	fmt.Println(len(s4))    //3
	fmt.Println(cap(s4))    //5
	fmt.Println(s4)         //[0 0 0]
	s4 = append(s4, 9)
	fmt.Println(s4) //[0 0 0 9]
	s4 = append(s4, 999)
	s4 = append(s4, 888)
	fmt.Println(s4) //[0 0 0 9 999 888]
}
```

## map

map 对于 C++程序员用的 std::map 熟悉不过了。如 std::map 基于红黑树按照键的顺序排列，属于有序的关联容器。std::unordered_map 属于无序的关联容器，基于哈希表。

在 Go 语言中，map 是一种键值对的集合，也被称为字典或关联数组。它提供了一种快速查找和访问数据的方式。

```go
package main

import "fmt"

func main() {
	//1.声明与初始化
	m := make(map[string]int)
	m["k1"] = 12
	m["k2"] = 23
	fmt.Println(m) //map[k1:12 k2:23]
	v1 := m["k1"]
	fmt.Println(v1)     //12
	fmt.Println(len(m)) //2
	n := map[string]int{"a": 1, "b": 2}
	fmt.Println(n) //map[a:1 b:2]
	//2.删除键值对
	delete(m, "k2")
	fmt.Println(m) //map[k1:12]
	//3.判断有没有某个键
	_, prs := m["k2"]
	fmt.Println(prs) //false
	/*
		当从一个 map 中取值时，还有可以选择是否接收的第二个返回值，
		该值表明了 map 中是否存在这个键。 这可以用来消除 键不存在
		 和 键的值为零值 产生的歧义， 例如 0 和 ""。这里我们不需
		 要值，所以用 空白标识符(blank identifier) _ 将其忽略。
	*/
	//4.遍历map所有元素
	for name, age := range m {
		fmt.Println(name, age)
	} // k1 12
}
```

## range 遍历

range 用于迭代各种各样的数据结构。 让我们来看看如何在我们已经学过的数据结构上使用 range。

```go
package main

import "fmt"

func main() {
	//1.例如遍历切片
	nums := []int{1, 2, 3, 4}
	sum := 0
	for _, num := range nums {
		sum += num
	}
	fmt.Println(sum) //10
	for i, num := range nums {
		if num == 3 {
			fmt.Println(i, " ", num)
			//2 3
		}
	}
	//2.例如遍历map
	kvs := map[string]string{"a": "apple", "b": "banana"}
	for k, v := range kvs {
		fmt.Println(k, "=", v)
	} //a = apple b = banana
	//3.遍历字符串
	for i, c := range "go" {
		fmt.Printf("%d %c\n", i, c)
	} //0 g 1 o
}
```

## 函数

go 中有一点说的就是，函数是不支持重载的,说实话骚操作没有 C++多

当多个连续的参数为同样类型时， 可以仅声明最后一个参数的类型，忽略之前相同类型参数的类型声明。

```go
package main

import "fmt"

func plus(a int, b int) int {
	return a + b
}

func plusplus(a, b, c int) int {
	return a + b + c
}

func plusf(a float32, b float32) float32 {
	return a + b
}

func main() {
	fmt.Println(plus(1, 2))        //3
	fmt.Println(plusplus(1, 2, 3)) //6
	fmt.Println(plusf(1.2, 1.4))   //2.6
}
```

## 多返回值

挺骚操作的，C++起码用数组和 std::tuple

```cpp
package main

import (
	"fmt"
)

func vals() (int, int) {
	return 3, 7
}

func main() {
	a, b := vals()
	fmt.Println(a, b) // 输出：3 7
	_, c := vals()
	d, _ := vals()
	fmt.Println(c) //7
	fmt.Println(d) //3
}
```

## 变参函数

变参函数早已不是什么骚操作，C 中和 C++11 变参模板都可以

C 风格

```c
#include <iostream>
#include <cstdarg>

// 接受可变数量参数的函数
double average(int count, ...) {
    va_list args;
    va_start(args, count);

    double sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }

    va_end(args);

    return sum / count;
}

int main() {
    double result = average(4, 2, 4, 6, 8);
    std::cout << "Average: " << result << std::endl;

    return 0;
}
```

C++11 变参模板

```go
#include <iostream>

// 递归终止函数
double average() {
    return 0;
}

// 变参模板函数
template<typename T, typename... Args>
double average(T arg, Args... args) {
    return arg + average(args...) / (sizeof...(args) + 1);
}

int main() {
    double result = average(2, 4, 6, 8);
    std::cout << "Average: " << result << std::endl;

    return 0;
}
```

go 语言,语法而言确实挺香

```go
package main

import "fmt"

func sum(nums ...int) {
	fmt.Println(nums, " ")
	total := 0
	for _, num := range nums {
		total += num
	}
	fmt.Println(total)
}

func main() {
	sum(1, 2)
	//[1 2]
	//3
	sum(1, 2, 3)
	//[1 2 3]
	//6
	nums := []int{1, 2, 3, 4}
	sum(nums...) //解构
	//[1 2 3 4]
	//10
}
```

## 闭包

闭包这东西，对于写 js 的其实很熟悉，go 中也有

C++除此之外还有像写可调用对象之类的形式

```cpp
#include <iostream>
using namespace std;

auto createClosure(int x)
{
    return [x]()
    {
        return x * x;
    };
}

int main(int argc, char **argv)
{
    auto closure = createClosure(43);
    std::cout << closure() << std::endl;
    // 1849
    return 0;
}
```

GO 中像 JavaScript 一样是支持延长变量声明周期的,毕竟 go 有垃圾回收,C++就要使用动态内存实现这种骚操作了，而且很难实现动态内存管理

```go
package main

import "fmt"

func intSeq() func() int {
	i := 0
	return func() int {
		i++
		return i
	}
}

func main() {
	mfunc := intSeq()
	fmt.Println(mfunc()) //1
	fmt.Println(mfunc()) //2
	fmt.Println(mfunc()) //3
	fmt.Println(mfunc()) //4
	fmt.Println(mfunc()) //5
}
```

## 递归

函数递归

```go
package main

import "fmt"

func fact(n int) int {
	fmt.Println(n)
	if n == 0 {
		return 1
	}
	return n * fact(n-1)
}

func main() {
	fmt.Println(fact(10))
}

//10 9 8 7 6 5 4 3 2 1 0 3628800
```

闭包递归,必须先显式声明

```go
package main

import "fmt"

func main() {
	var fib func(n int) int
	fib = func(n int) int {
		fmt.Println(n)
		if n < 2 {
			return n
		}
		return fib(n-1) + fib(n-2)
	}
	fmt.Println(fib(7)) //13
}
```

## 指针

指针对于一名 C++程序员再熟悉不过了

```go
package main

import "fmt"

func zeroval(ival int64) {
	ival = 0
}

func zeroptr(iptr *int64) {
	*iptr = 0
}

func main() {
	var a int64 = 2
	var b int64 = 3
	zeroval(a)
	zeroptr(&b)
	fmt.Println(a) //2
	fmt.Println(b) //0
}
```

## 字符串与字符

Go 语言中的字符串是一个只读的 byte 类型的切片。 Go 语言和标准库特别对待字符串 - 作为以 UTF-8 为编码的文本容器。 在其他语言当中， 字符串由”字符”组成。 在 Go 语言当中，字符的概念被称为 rune - 它是一个表示 Unicode 编码的整数。

```go
package main

import (
	"fmt"
	"unicode/utf8"
)

func isGao(r rune) bool {
	return r == '高'
}

func main() {
	var s string = "高万禄abcd"
	fmt.Println(len(s)) //13
	for i := 0; i < len(s); i++ {
		fmt.Printf("%x ", s[i])
	}
	fmt.Println()
	//e9 ab 98 e4 b8 87 e7 a6 84 61 62 63 64
	//                           a  b  c  d
	//可见"高万禄"占据了9个字节
	fmt.Println(utf8.RuneCountInString(s)) //7
	for idx, runeVal := range s {
		fmt.Println(idx, runeVal)
	}
	//0 39640 3 19975 6 31108 9 97 10 98 11 99 12 100
	fmt.Println(utf8.DecodeRuneInString(s)) //39640 3 ,编码39640 3bytes
	for i, bytes := 0, 0; i < len(s); i += bytes {
		runeValue, width := utf8.DecodeRuneInString(s[i:])
		fmt.Printf("%#U at %d\n", runeValue, i)
		bytes = width
		fmt.Println(isGao(runeValue))
	}
	//U+9AD8 '高' at 0 true|U+4E07 '万' at 3 false|U+7984 '禄' at 6 false
	//U+0061 'a' at 9 false|U+0062 'b' at 10 false|U+0063 'c' at 11 false
	//U+0064 'd' at 12 false
}
```

可见从兼容 utf8 这种设计而言，go 比 C++强太多了，而且不需要考虑语言版本问题

## 结构体

这对于来鸟不是小意思？

```go
package main

import "fmt"

type Person struct {
	name string
	age  int
}

func newPerson(name string) *Person {
	p := Person{name: name}
	p.age = 21
	return &p
}

func main() {
	fmt.Println(Person{"gwl", 21})            //{gwl 21}
	fmt.Println(Person{name: "gwl", age: 30}) //{gwl 30}
	fmt.Println(Person{name: "fred"})         //{fred 0}
	fmt.Println(&Person{name: "", age: 0})    //&{ 0}
	var s Person = Person{name: "gaowanlu", age: 21}
	fmt.Println(s.name, s.age) //gaowanlu 21
	sptr := &s
	fmt.Println(sptr.name, sptr.age) //gaowanlu 21
	personPtr := newPerson("gaowanlu")
	fmt.Println(*personPtr) //{gaowanlu 21}
}
```

## 方法

GO 支持为结构体类型定义方法

调用方法时，Go 会自动处理值和指针之间的转换。 想要避免在调用方法时产生一个拷贝，或者想让方法可以修改接受结构体的值， 你都可以使用指针来调用方法。

- ptrChange 方法接收一个指向 Person 结构体的指针作为接收者。这意味着在调用该方法时，可以直接修改原始结构体的值。在方法内部，通过指针来访问结构体的字段，并对其进行更改。因此，通过调用 personPtr.ptrChange() ， person 的值将被修改为 name: "a" 和 age: 1 。

- valChange 方法接收一个 Person 结构体的值作为接收者。当调用该方法时，会创建一个接收者的副本，并在副本上进行操作，而不会影响原始结构体的值。因此，通过调用 person.valChange() ， person 的值不会改变。

```go
package main

import "fmt"

type Person struct {
	name string
	age  int
}

func (p *Person) print() {
	fmt.Println("name: ", p.name, " age: ", p.age)
}

func (p *Person) ptrChange() {
	p.name = "a"
	p.age = 1
}

func (v Person) valChange() {
	v.name = "b"
	v.age = 2
}

func main() {
	person := Person{name: "w", age: 3}
	person.print()      //name:  w  age:  3
	fmt.Println(person) //{w 3}
	person.valChange()
	person.print()      //name:  w  age:  3
	fmt.Println(person) //{w 3}
	personPtr := &person
	personPtr.ptrChange()
	personPtr.print()       //name:  a  age:  1
	fmt.Println(*personPtr) //{a 1}
}
```

## 接口

方法签名的集合叫做：_接口(Interfaces)_。

```go
package main

import (
	"fmt"
	"math"
)

type geometry interface {
	area() float64
	perim() float64
}

type rect struct {
	width, height float64
}
type circle struct {
	radius float64
}

func (r rect) area() float64 {
	return r.width * r.height
}
func (r rect) perim() float64 {
	return 2*r.width + 2*r.height
}

func (c circle) area() float64 {
	return math.Pi * c.radius * c.radius
}
func (c circle) perim() float64 {
	return 2 * math.Pi * c.radius
}

func measure(g geometry) {
	fmt.Println(g)
	fmt.Println(g.area())
	fmt.Println(g.perim())
}

func main() {
	r := rect{width: 3, height: 4}
	c := circle{radius: 5}
	measure(r)
	// {3 4}
	// 12
	// 14
	measure(c)
	// {5}
	// 78.53981633974483
	// 31.41592653589793
}
```

## Embedding

Go 支持对于结构体(struct)和接口(interfaces)的 嵌入(embedding) 以表达一种更加无缝的 组合(composition) 类型

Go 语言中没有像其他一些面向对象编程语言那样的继承机制。相反，Go 语言使用组合来实现代码的重用和扩展。

在 Go 语言中，可以通过在结构体中嵌入其他结构体来实现组合。这样，嵌入的结构体可以访问其字段和方法，就好像它们是在当前结构体中定义的一样。这种方式可以实现代码的重用，而无需显式地继承。

另外，Go 语言还提供了接口（interface）的概念，通过接口可以实现多态性。结构体可以实现一个或多个接口，并按照接口定义的方法来调用结构体的行为。这样，可以在不同的结构体上使用相同的接口，实现代码的灵活性和可扩展性。

总而言之，尽管 Go 语言没有继承的概念，但通过组合和接口的使用，可以实现代码的重用和扩展。

```go
package main

import "fmt"

type base struct {
	num int
}

func (b base) describe() string {
	return fmt.Sprintf("base with num=%v", b.num)
}

type container struct {
	base
	str string
}

func main() {
	co := container{
		base: base{
			num: 1,
		},
		str: "some name",
	}
	fmt.Printf("co={num: %v, str: %v}\n", co.num, co.str)
	fmt.Println("also num:", co.base.num)
	fmt.Println("describe:", co.describe())
	type describer interface {
		describe() string
	}
	var d describer = co
	fmt.Println("describer:", d.describe())
}

/*
co={num: 1, str: some name}
also num: 1
describe: base with num=1
describer: base with num=1
*/
```

## 泛型

C++的泛型是基于模板的，Go 中也有泛型的特性

```go
package main

import "fmt"

func MapKeys[K comparable, V any](m map[K]V) []K {
	r := make([]K, 0, len(m))
	for k, _ := range m {
		r = append(r, k)
	}
	return r
}

func main() {
	var m = map[int]string{1: "2", 2: "4", 4: "8"}
	//自动推断
	fmt.Println("keys :", MapKeys(m)) //keys : [1 2 4]
	//显式指定
	fmt.Println(MapKeys[int, string](m)) //[1 2 4]
}
```

用泛型写链表 C++

```cpp
#include <iostream>
#include <vector>
using namespace std;

template <typename T>
class Element
{
public:
    Element<T> *next{nullptr};
    T val;
};

template <typename T>
class List
{
public:
    Element<T> *head{nullptr};
    Element<T> *tail{nullptr};
};

// 尾插法
template <typename T>
void Push(List<T> *lst, T v)
{
    if (lst->tail == nullptr)
    {
        lst->head = new Element<T>;
        lst->head->val = v;
        lst->tail = lst->head;
    }
    else
    {
        lst->tail->next = new Element<T>;
        lst->tail->next->val = v;
        lst->tail = lst->tail->next;
    }
}

template <typename T>
vector<T> GetAll(List<T> *lst)
{
    vector<T> vec;
    for (auto ptr = lst->head; ptr != nullptr; ptr = ptr->next)
    {
        vec.push_back(ptr->val);
    }
    return vec;
}

int main(int argc, char **argv)
{
    List<int> lst;
    Push(&lst, 1);
    Push(&lst, 2);
    Push(&lst, 3);
    for (auto n : GetAll(&lst))
    {
        cout << n << " ";
    }
    cout << std::endl;
    // 1 2 3
    return 0;
}
```

使用 GO 编写，对比上面的 C++样例很容易学习

```go
package main

import "fmt"

type List[T any] struct {
	head, tail *element[T]
}

type element[T any] struct {
	next *element[T]
	val  T
}

// 尾插法
func (lst *List[T]) Push(v T) {
	if lst.tail == nil {
		lst.head = &element[T]{val: v}
		lst.tail = lst.head
	} else {
		lst.tail.next = &element[T]{val: v}
		lst.tail = lst.tail.next
	}
}

func (lst *List[T]) GetAll() []T {
	var elems []T
	for e := lst.head; e != nil; e = e.next {
		elems = append(elems, e.val)
	}
	return elems
}

func main() {
	lst := List[int]{}
	lst.Push(1)
	lst.Push(2)
	lst.Push(3)
	fmt.Println(lst.GetAll()) //[1 2 3]
}
```

## 错误处理

符合 Go 语言习惯的做法是使用一个独立、明确的返回值来传递错误信息。 这与 Java、Ruby 使用的异常（exception） 以及在 C 语言中有时用到的重载 (overloaded) 的单返回/错误值有着明显的不同。 Go 语言的处理方式能清楚的知道哪个函数返回了错误，并使用跟其他（无异常处理的）语言类似的方式来处理错误。

```go
package main

import (
	"errors"
	"fmt"
)

func f1(arg int) (int, error) {
	if arg == 42 {
		return -1, errors.New("can't work with 42")
	}
	return arg + 3, nil
}

// 自定义Error类型
type argError struct {
	arg  int
	prob string
}

func (e *argError) Error() string {
	return fmt.Sprintf("%d - %s", e.arg, e.prob)
}

func f2(arg int) (int, error) {
	if arg == 42 {
		return -1, &argError{arg, "can't work with it"}
	}
	return arg + 3, nil
}

func main() {
	for _, i := range []int{7, 32} {
		if r, e := f1(i); e != nil {
			fmt.Println("f1 failed:", e)
		} else {
			fmt.Println("f1 worked:", r)
		}
	}
	//f1 worked: 10
	//f1 worked: 35
	for _, i := range []int{7, 42} {
		if r, e := f2(i); e != nil {
			fmt.Println("f2 failed:", e)
		} else {
			fmt.Println("f2 worked", r)
		}
	}
	//f2 worked 10
	//f2 failed: 42 - can't work with it
	_, e := f2(42)
	if ae, ok := e.(*argError); ok {
		fmt.Println(ae.arg)
		fmt.Println(ae.prob)
	}
	//42
	//can't work with it
}
```

关于以下部分是用于检查错误类型的代码段。首先，我们调用函数 f2(42) 并将返回的结果赋值给变量 e 。然后，我们使用类型断言将 e 转换为 `*argError` 类型的变量 ae 。如果类型断言成功，即 e 的类型是 `*argError` ，则条件 ok 为 true ，我们可以访问 ae 的字段。在这种情况下，我们打印出 ae.arg 和 ae.prob 的值，分别对应错误的参数和问题描述。

因为 error 类型是个接口,argError 实际上实现了 error

```go
type error interface {
    Error() string
}
```

e 是接口 error 类型,go 中可用 interface.(\*T)转换为具体类型，还会进行断言 ok 为真则转换成功，非接口类型转换直接 T(v)如`i:=64 f:=float64(i)`

```go
_, e := f2(42)
if ae, ok := e.(*argError); ok {
	fmt.Println(ae.arg)
	fmt.Println(ae.prob)
}
```

其实 Go 中这种异常处理方式，其实也挺优雅的，但是说不上是真正的异常机制

## 协程

协程(goroutine)是轻量级得执行线程

1. import 语句导入了两个包： fmt 和 time 。 fmt 包用于格式化输出， time 包用于时间相关操作。

2. f 函数是一个普通函数，它接受一个字符串参数 from 。在函数体内部，使用 for 循环打印出三次 from 的值。

3. main 函数是程序的入口函数。在函数体内部，首先调用 f("direct") ，这是直接调用函数的方式。然后使用 go 关键字调用 f("goroutin") ，这是使用协程（goroutine）并发运行函数的方式。接下来，使用协程运行一个匿名函数，该函数接受一个字符串参数 msg ，并打印出该参数的值。最后，使用 time.Sleep(time.Second) 让程序休眠一秒钟，以确保协程有足够的时间执行。最后，打印出"done"表示程序执行完毕。

```go
package main

import (
	"fmt"
	"time"
)

func f(from string) {
	for i := 0; i < 3; i++ {
		fmt.Println(from, ":", i)
	}
}

func main() {
	f("direct")      //直接运行
	go f("goroutin") //使用协程运行
	//协程运行匿名函数
	go func(msg string) {
		fmt.Println(msg)
	}("going")
	time.Sleep(time.Second)
	fmt.Println("done")
}
/*
direct : 0
direct : 1
direct : 2
going
goroutin : 0
goroutin : 1
goroutin : 2
done
*/
```

## 通道

通道(channels) 是连接多个协程的管道。 你可以从一个协程将值发送到通道，然后在另一个协程中接收。  
使用 make(chan val-type) 创建一个新的通道。 通道类型就是他们需要传递值的类型。  
使用 channel <- 语法 发送 一个新的值到通道中。使用 <-channel 语法从通道中 接收 一个值。

默认发送和接收操作是阻塞的，直到发送方和接收方都就绪。 这个特性允许我们，不使用任何其它的同步操作， 就可以在程序结尾处等待消息 "ping"。

```go
package main

import (
	"fmt"
	"time"
)

type Message struct {
	name string
	age  int
}

func main() {
	message := make(chan Message)
	go func() {
		timestamp := time.Now().Unix()
		for {
			now := time.Now().Unix()
			if now-timestamp > 5 {
				message <- Message{name: "end", age: 21}
				break
			}
			message <- Message{name: "gaowanlu", age: 21}
		}
	}()
	go func() {
		timestamp := time.Now().Unix()
		for {
			now := time.Now().Unix()
			if now-timestamp > 7 {
				break
			}
			msg := <-message
			fmt.Println(msg)
			if msg.name == "end" {
				break
			}
		}
	}()
	time.Sleep(time.Second * 10)
}

//{gaowanlu 21}......{end 21}
```

## 通道缓冲

在默认情况下，通道是无缓冲的，意味着只有对应的接收(`<-chan`)通道准备好接收时，才允许进行发送（`chan<-`）。有缓冲通道允许在没有对应接收者的情况下，缓存一定数量的值。

```go
package main

import "fmt"

func main() {
	messages := make(chan string, 2) //2个缓冲
	messages <- "message1"
	messages <- "message2"
	fmt.Println(<-messages) //message1
	fmt.Println(<-messages) //message2
}
```

## 通道同步

C++程序员肯定直到线程同步，协程同步理解起来当然也很简单

```go
package main

import (
	"fmt"
	"time"
)

// 接收通道bool型，形参命名为done
func worker(done chan bool) {
	fmt.Println("working...")
	time.Sleep(time.Second)
	fmt.Println("done")
	done <- true
}

func main() {
	done := make(chan bool, 1)
	go worker(done)
	<-done //阻塞
}

//working...
//等三秒
//done
```

## 通道方向

当使用通道作为函数的参数时，可以指定通道是否为只读或只写，该特性可以提升程序的类型安全。

```go
package main

import "fmt"

//只写
func ping(pings chan<- string, msg string) {
	pings <- msg
}

//pings只读,pongs只写
func pong(pings <-chan string, pongs chan<- string) {
	msg := <-pings
	pongs <- msg
}

func main() {
	pings := make(chan string, 1)
	pongs := make(chan string, 1)
	ping(pings, "passed message")
	pong(pings, pongs)
	fmt.Println(<-pongs) //passed message
}
```

## 通道选择器

Go 的选择器(select)可以同时等待多个通道操作。有点像 C++的 select IO 多路复用。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	c1 := make(chan string)
	c2 := make(chan string)
	go func() {
		time.Sleep(1 * time.Second)
		c1 <- "one"
	}()
	go func() {
		time.Sleep(2 * time.Second)
		c2 <- "two"
	}()
	for i := 0; i < 2; i++ {
		fmt.Println("select ", i)
		select {
		case msg1 := <-c1:
			fmt.Println("received", msg1)
		case msg2 := <-c2:
			fmt.Println("received", msg2)
		}
	}
}
/*
select  0
received one
select  1
received two
*/
```

## 超时处理

超时 对于一个需要连接外部资源， 或者有耗时较长的操作的程序而言是很重要的。 得益于通道和 select，在 Go 中实现超时操作是简洁而优雅的。更像 C++ IO 多路复用超时处理了。

select 是阻塞的。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("select 1")
	c1 := make(chan string, 1)
	go func() {
		time.Sleep(2 * time.Second)
		c1 <- "result 1"
	}()
	select {
	case res := <-c1:
		fmt.Println(res)
	case <-time.After(1 * time.Second):
		fmt.Println("timeout 1")
	}
	fmt.Println("select 2")
	c2 := make(chan string, 1)
	go func() {
		time.Sleep(2 * time.Second)
		c2 <- "result 2"
	}()
	select {
	case res := <-c2:
		fmt.Println(res)
	case <-time.After(3 * time.Second):
		fmt.Println("timeout 2")
	}
}
/*
select 1
timeout 1
select 2
result 2
*/
```

## 非阻塞通道操作

有非阻塞 IO 肯定有非阻塞通道喽。常规的通过通道发送和接收数据是阻塞的。 然而，我们可以使用带一个 default 子句的 select 来实现 非阻塞 的发送、接收，甚至是非阻塞的多路 select。

```go
package main

import "fmt"

func main() {
	messages := make(chan string)
	signals := make(chan bool)
	select {
	case msg := <-messages:
		fmt.Println("received message", msg)
	default:
		fmt.Println("no message received")
	}
	//会直接输出 no message received
	msg := "hi"
	select {
	case messages <- msg:
		fmt.Println("sent message", msg)
	default:
		fmt.Println("no message sent")
	}
	//会直接输出 no message sent
	//因为没有人接收
	select {
	case msg := <-messages:
		fmt.Println("received message", msg)
	case sig := <-signals:
		fmt.Println("received signal", sig)
	default:
		fmt.Println("no activity")
	}
	//直接输出no activity
}
```

## 通道的关闭

关闭 一个通道意味着不能再向这个通道发送值了。 该特性可以向通道的接收方传达工作已经完成的信息。

```go
package main

import "fmt"

func main() {
	jobs := make(chan int, 3)
	done := make(chan bool)
	go func() {
		//死循环
		for {
			j, more := <-jobs
			if more {
				fmt.Println("received job", j)
			} else {
				fmt.Println("received all jobs")
				done <- true
				break
			}
		}
	}()
	for j := 1; j <= 3; j++ {
		jobs <- j
		fmt.Println("sent job", j)
	}
	close(jobs)
	fmt.Println("sent all jobs")
	fmt.Println(<-done)
}

// received job 1
// sent job 1
// sent job 2
// sent job 3
// sent all jobs
// received job 2
// received job 3
// received all jobs
// true
```

## 通道的遍历

通道是支持 for 和 range 迭代遍历的

遍历的话用这种方式也不是不行

```go
for {
	j, more := <-jobs
	if more {
		//
	} else {
		//
		break
	}
}
```

但是 for-range 更像语法糖，里应当只遍历 close 过的通道，一个非空的通道也是可以关闭的，通道中剩下的值仍然可以被接收到。遍历没有 close 的通道会报错。

```go
package main

import "fmt"

func main() {
	queue := make(chan string, 2)
	queue <- "one"
	queue <- "two"
	close(queue)
	for elem := range queue {
		fmt.Println(elem)
	}
}
// one
// two
```

## Timer

Go 有内置的定时器

timer1 是从构造开始计时的。当 timer1.C 的通道接收到数据时，表示定时器已经触发，而不是在接收到数据时开始计时。timer.C 中的 C 是 Channel（通道）的缩写。

```go
package main
import (
	"fmt"
	"time"
)
func main() {
	timer1 := time.NewTimer(2 * time.Second)
	<-timer1.C
	fmt.Println("Timer 1 fired")
}
```

在 main 函数中，我们创建了一个名为 timer2 的定时器，它将在 1 秒后触发。使用了一个匿名函数来作为一个 goroutine（并发执行的函数）。在这个 goroutine 中，我们使用 <-timer2.C 语句从 timer2 的通道中接收数据。当定时器触发时，这个语句会解除阻塞，从而执行后续的代码。

调用了 timer2.Stop() 方法来停止定时器。如果定时器成功停止，返回值 stop2 会为 true，我们将打印出 "Timer 2 stopped"。协程中的`<-timer2.C`并不会返回。

```go
package main
import (
	"fmt"
	"time"
)
func main() {
	timer2 := time.NewTimer(time.Second)
	go func() {
		<-timer2.C
		fmt.Println("Timer 2 fired")
	}()
	stop2 := timer2.Stop() //停止定时器
	//停止timer2成功
	if stop2 {
		fmt.Println("Timer 2 stopped")
	}
	time.Sleep(3 * time.Second)
}
//Timer 2 stopped
```

## Ticker

打点器是以固定的时间间隔重复执行而准备的。死循环，加定时器，select

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ticker := time.NewTicker(500 * time.Millisecond)
	done := make(chan bool)
	go func() {
		for {
			select {
			case <-done:
				return
			case t := <-ticker.C:
				fmt.Println("Tick at", t)
			}
		}
	}()
	time.Sleep(8000 * time.Millisecond)
	ticker.Stop()
	done <- true
	fmt.Println("Ticker stopped")
}

/*
Tick at 2023-08-19 15:22:39.2576045 +0800 CST m=+0.513205701
Tick at 2023-08-19 15:22:39.7555552 +0800 CST m=+1.011156401
Tick at 2023-08-19 15:22:40.2530881 +0800 CST m=+1.508689301
Tick at 2023-08-19 15:22:40.753203 +0800 CST m=+2.008804201
Tick at 2023-08-19 15:22:41.2539281 +0800 CST m=+2.509529301
Tick at 2023-08-19 15:22:41.7518864 +0800 CST m=+3.007487601
Tick at 2023-08-19 15:22:42.2498314 +0800 CST m=+3.505432601
Tick at 2023-08-19 15:22:42.7499687 +0800 CST m=+4.005569901
Tick at 2023-08-19 15:22:43.2495641 +0800 CST m=+4.505165301
Tick at 2023-08-19 15:22:43.749537 +0800 CST m=+5.005138201
Tick at 2023-08-19 15:22:44.2538916 +0800 CST m=+5.509492801
Tick at 2023-08-19 15:22:44.7520632 +0800 CST m=+6.007664401
Tick at 2023-08-19 15:22:45.2503554 +0800 CST m=+6.505956601
Tick at 2023-08-19 15:22:45.7527025 +0800 CST m=+7.008303701
Tick at 2023-08-19 15:22:46.2523764 +0800 CST m=+7.507977601
Tick at 2023-08-19 15:22:46.7510895 +0800 CST m=+8.006690701
Ticker stopped
*/
```

## 工作池

C++通常用线程池来进行 Task 处理，但在 go 中使用协程池会非常便捷

```go
package main

import (
	"fmt"
	"time"
)

func worker(id int, jobs <-chan int, results chan<- int) {
	for j := range jobs {
		fmt.Println("worker", id, "started job")
		time.Sleep(time.Second) //模拟费时人物
		fmt.Println("worker", id, "finished job", j)
		results <- j * 2
	}
}

func main() {
	const numJobs = 10
	jobs := make(chan int, numJobs)
	results := make(chan int, numJobs)
	//建3个worker协程
	for w := 1; w <= 3; w++ {
		go worker(w, jobs, results)
	}
	for j := 1; j <= 5; j++ {
		jobs <- j
	}
	close(jobs)
	for i := 1; i <= 5; i++ {
		fmt.Println(<-results)
	}
}
/*
worker 3 started job
worker 1 started job
worker 2 started job
worker 2 finished job 3
worker 2 started job
worker 1 finished job 2
worker 1 started job
6
4
worker 3 finished job 1
2
worker 1 finished job 5
worker 2 finished job 4
10
8
*/
```

## WaitGroup

想要等待多个协程完成，我们可以使用 wait group。像 C++多线程编程里的屏障。

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

func worker(id int) {
	fmt.Println("Worker %d starting", id)
	time.Sleep(time.Second)
	fmt.Println("Worker %d done", id)
}

func main() {
	var wg sync.WaitGroup
	for i := 1; i <= 5; i++ {
		//在等待组中添加一个等待任务，表示有一个任务需要等待。
		wg.Add(1)
		//这一行的目的是为了避免在闭包中捕获到循环变量 i 的引用。由于闭包是在稍后异步执行的，如果不保存 i 的当前值，所有的闭包都会捕获相同的 i 值，导致打印的 id 不正确。
		i := i
		go func() {
			//使用 defer 延迟执行，当协程执行完成时，会调用 wg.Done() 来通知等待组，表示一个任务已经完成。
			defer wg.Done()
			worker(i)
		}()
	}
	//等待等待组中的所有任务完成。这个函数会一直阻塞，直到等待组中的计数器降为零，也就是所有工作任务都完成了。
	wg.Wait()
}

/*
Worker %d starting 5
Worker %d starting 2
Worker %d starting 3
Worker %d starting 4
Worker %d starting 1
Worker %d done 1
Worker %d done 4
Worker %d done 3
Worker %d done 2
Worker %d done 5
*/
```

## 速率限制

速率限制是控制服务资源利用和质量的重要机制，基于协程、通道和打点器

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	requests := make(chan int, 5)
	for i := 1; i <= 5; i++ {
		requests <- i
	}
	close(requests)
	limiter := time.Tick(200 * time.Millisecond)

	//没200ms才会loop一次
	for req := range requests {
		<-limiter
		fmt.Println("request", req, time.Now())
	}

	burstyLimiter := make(chan time.Time, 3)
	for i := 0; i < 3; i++ {
		burstyLimiter <- time.Now()
	}
	//协程定时发出信号
	go func() {
		for t := range time.Tick(200 * time.Millisecond) {
			burstyLimiter <- t
		}
	}()
	burstyRequests := make(chan int, 5)
	for i := 1; i <= 5; i++ {
		burstyRequests <- i
	}
	close(burstyRequests)
	for req := range burstyRequests {
		<-burstyLimiter
		fmt.Println("request", req, time.Now())
	}
}

/*
request 1 2023-09-02 02:13:21.4947625 +0800 CST m=+0.206486401
request 2 2023-09-02 02:13:21.7054319 +0800 CST m=+0.417155801
request 3 2023-09-02 02:13:21.8956622 +0800 CST m=+0.607386101
request 4 2023-09-02 02:13:22.094804 +0800 CST m=+0.806527901
request 5 2023-09-02 02:13:22.2934502 +0800 CST m=+1.005174101
request 1 2023-09-02 02:13:22.2934502 +0800 CST m=+1.005174101
request 2 2023-09-02 02:13:22.2939621 +0800 CST m=+1.005686001
request 3 2023-09-02 02:13:22.2939621 +0800 CST m=+1.005686001
request 4 2023-09-02 02:13:22.5088651 +0800 CST m=+1.220589001
request 5 2023-09-02 02:13:22.6968576 +0800 CST m=+1.408581501
*/
```

## 原子计数器

C++新版本中其实也有了原子整型，GO 中也不例外

```go
package main

import (
	"fmt"
	"sync"
	"sync/atomic"
)

func main() {
	var ops uint64
	ops = 0
	var wg sync.WaitGroup
	for i := 0; i < 50; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for c := 0; c < 1000; c++ {
				atomic.AddUint64(&ops, 1)
			}
		}()
	}
	wg.Wait()
	fmt.Println("ops:", ops)
}

//ops:50000
```

## 互斥锁

写 C++的肯定知道 posix 的 mutex 与 C++并发标准库的 mutex,Go 中当然也会有。

```go
package main

import (
	"fmt"
	"sync"
)

type Container struct {
	mu       sync.Mutex
	counters map[string]int
}

func (c *Container) inc(name string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.counters[name]++
}

func main() {
	c := Container{
		counters: map[string]int{"a": 0, "b": 0},
	}
	var wg sync.WaitGroup
	doIncrement := func(name string, n int) {
		for i := 0; i < n; i++ {
			c.inc(name)
		}
		wg.Done()
	}
	wg.Add(3)
	go doIncrement("a", 10000)
	go doIncrement("a", 10000)
	go doIncrement("b", 10000)
	wg.Wait()
	fmt.Println(c.counters)
}

//map[a:20000 b:10000]
```

## 状态协程

除了使用互斥量，其实还可以利用通道和协程来实现对某些数据的互斥访问,在游戏开发中常常用这种思想，来实现并发,就像使用消息队列一样，多个线程发出操作请求，但处理请求的服务是单线程的。

```go
package main

import (
	"fmt"
	"math/rand"
	"sync/atomic"
	"time"
)

type readOp struct {
	key  int
	resp chan int
}

type writeOp struct {
	key  int
	val  int
	resp chan bool
}

func main() {
	var readOps uint64
	var writeOps uint64
	reads := make(chan readOp)
	writes := make(chan writeOp)
	//消费者
	go func() {
		var state = make(map[int]int)
		for {
			select {
			case read := <-reads:
				atomic.AddUint64(&readOps, 1)
				read.resp <- state[read.key]
			case write := <-writes:
				atomic.AddUint64(&writeOps, 1)
				state[write.key] = write.val
				write.resp <- true
			}
		}
	}()
	//并发读
	for r := 0; r < 100; r++ {
		go func() {
			for {
				read := readOp{
					key:  rand.Intn(5),
					resp: make(chan int)}
				reads <- read
				<-read.resp
				time.Sleep(time.Millisecond)
			}
		}()
	}
	//并发写
	for w := 0; w < 10; w++ {
		go func() {
			for {
				write := writeOp{
					key:  rand.Intn(5),
					val:  rand.Intn(100),
					resp: make(chan bool)}
				writes <- write
				<-write.resp
				time.Sleep(time.Millisecond)
			}
		}()
	}
	time.Sleep(time.Second)
	readOpsFinal := atomic.LoadUint64(&readOps)
	fmt.Println("readOps:", readOpsFinal)
	writeOpsFinal := atomic.LoadUint64(&writeOps)
	fmt.Println("writeOps:", writeOpsFinal)
}
```

## 排序

Go 的 sort 包实现了内建及用户自定义数据类型的排序功能。

```go
package main

import (
	"fmt"
	"sort"
)

func main() {
	strs := []string{"c", "a", "b"}
	sort.Strings(strs)
	fmt.Println("Strings:", strs)
	ints := []int{7, 2, 4}
	sort.Ints(ints)
	fmt.Println("Ints:", ints)
	s := sort.IntsAreSorted(ints)
	fmt.Println("Sorted:", s)
}

/*
Strings: [a b c]
Ints: [2 4 7]
Sorted: true
*/
```

## 自定义排序

数据类型需要实现 Len、Swap、Less 方法

```go
package main

import (
	"fmt"
	"sort"
)

// byLength如果像支持sort则需要
// 实现sort.Interface接口
// Len Less Swap方法
type byLength []string

func (s byLength) Len() int {
	return len(s)
}

func (s byLength) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s byLength) Less(i, j int) bool {
	return len(s[i]) < len(s[j])
}

func main() {
	fruits := []string{"peach", "banana", "kiwi"}
	sort.Sort(byLength(fruits))
	fmt.Println(fruits)
}

//[kiwi peach banana]
```

## Panic

，panic 是一种运行时异常，用于表示程序发生了一个不可恢复的错误或紧急情况。

```go
package main

import "fmt"

func test1() {
	panic("This is a panic")
}

func test2() {
	test1()
	fmt.Println("test 2")
}

func main() {
	test2()
	fmt.Println("hello world")
}

/*
panic: This is a panic

goroutine 1 [running]:
main.test1(...)
        c:/Users/gaowanlu/Desktop/MyProject/note/testcode/go/main.go:6
main.test2()
        c:/Users/gaowanlu/Desktop/MyProject/note/testcode/go/main.go:10 +0x27
main.main()
        c:/Users/gaowanlu/Desktop/MyProject/note/testcode/go/main.go:15 +0x19
exit status 2
*/
```

panic 会立即停止当前函数的执行，并开始执行调用栈上的延迟（deferred）函数

```go
package main

import "fmt"

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic:", r)
		}
	}()
	panic("This is a panic")
}

//Recovered from panic: This is a panic
```

## Defer

Defer 用于确保程序在执行完成后，会调用某个函数，一般是执行清理工作。 Defer 的用途跟其他语言的 ensure 或 finally 类似。

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	f := createFile("./tmp/defer.txt")
	defer closeFile(f)
	writeFile(f)
}

func createFile(p string) *os.File {
	fmt.Println("creating")
	f, err := os.Create(p)
	if err != nil {
		panic(err)
	}
	return f
}

func writeFile(f *os.File) {
	fmt.Println("writing")
	fmt.Fprintln(f, "data")
}

func closeFile(f *os.File) {
	fmt.Println("closing")
	err := f.Close()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error:%v\n", err)
		os.Exit(1)
	}
}

/*
creating
writing
closing
*/
```

## Recover

Go 通过使用 recover 内置函数，可以从 panic 中 恢复 recover 。 recover 可以阻止 panic 中止程序，并让它继续执行。panic->defer->end

```go
package main

import "fmt"

func mayPanic() {
	panic("a problem")
}

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered,Error:\n", r)
		}
	}()
	mayPanic()
	fmt.Println("After mayPanic()")
	//这行代码不会执行，因为 mayPanic 函数会调用 panic。 main 程序的执行在 panic 点停止，并在继续处理完 defer 后结束。
}

/*
Recovered,Error:
 a problem
*/
```

下面的代码，就会输出 After mayPanic,因为所有 panic 已经在 test 函数内处理过了。

```go
package main

import "fmt"

func mayPanic() {
	panic("a problem")
}

func test() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered,Error:\n", r)
		}
	}()
	mayPanic()
}

func main() {
	test()
	fmt.Println("After mayPanic()")
}

/*
Recovered,Error:
 a problem
After mayPanic()
*/
```

## 字符串函数

标准库的 strings 包提供了很多有用的字符串相关的函数。

```go
package main

import (
	"fmt"
	s "strings"
)

var p = fmt.Println

func main() {
	//包含Contains:  true
	p("Contains: ", s.Contains("test", "es"))
	//子串数 Count:  2
	p("Count: ", s.Count("test", "t"))
	//前缀 HasPrefix: true
	p("HasPrefix: ", s.HasPrefix("test", "tes"))
	//后缀 HasSuffix:  true
	p("HasSuffix: ", s.HasSuffix("test", "st"))
	//Index:  1
	p("Index: ", s.Index("test", "es"))
	//Join:  a-b
	p("Join: ", s.Join([]string{"a", "b"}, "-"))
	//Repeat:  abcabcabcabcabc
	p("Repeat: ", s.Repeat("abc", 5))
	//Replace:  abcdkkfff
	p("Replace: ", s.Replace("abcdeeeefff", "ee", "k", -1))
	//Replace:  abcdeekkk
	p("Replace: ", s.Replace("abcdeefff", "f", "k", 3))
	//Replace:  abcdeekkf
	p("Replace: ", s.Replace("abcdeefff", "f", "k", 2))
	//Split:  [a b c d e]
	p("Split: ", s.Split("a-b-c-d-e", "-"))
	//ToLower:  test
	p("ToLower: ", s.ToLower("TEST"))
	//ToUpper:  TEST
	p("ToUpper: ", s.ToUpper("test"))
	//Len:  5
	p("Len: ", len("hello"))
	//Char: a
	fmt.Printf("Char: %c\n", "abcde"[0])
	//Char: b
	fmt.Printf("Char: %c\n", "abcde"[1])
}
```

## 字符串格式化

Go 在传统的 printf 中对字符串格式化提供了优异的支持。

```go
package main

import (
	"fmt"
	"os"
)

type point struct {
	x, y int
}

func main() {
	p := point{1, 2}
	p.x = 4
	//对象打印
	//struct1: {4 2}
	fmt.Printf("struct1: %v\n", p)
	//struct2: {x:4 y:2}
	fmt.Printf("struct2: %+v\n", p)
	//带有类型 struct3: main.point{x:4, y:2}
	fmt.Printf("struct3: %#v\n", p)
	//type: main.point
	fmt.Printf("type: %T\n", p)
	//格式化布尔值 bool: true
	fmt.Printf("bool: %t\n", true)
	//整数 int: 123
	fmt.Printf("int: %d\n", 123)
	//二进制 bin: 1110
	fmt.Printf("bin: %b\n", 14)
	//字符 char: !
	fmt.Printf("char: %c\n", 33)
	//十六进制 hex: 1c8
	fmt.Printf("hex: %x\n", 456)
	//浮点 float1: 78.900000
	fmt.Printf("float1: %f\n", 78.9)
	//科学计数法
	//float2: 1.234000e+08
	fmt.Printf("float2: %e\n", 123400000.0)
	//float3: 1.234000E+08
	fmt.Printf("float3: %E\n", 123400000.0)
	//字符串转义 str1: "string"
	fmt.Printf("str1: %s\n", "\"string\"")
	//字符串不转义 str2: "\"string\""
	fmt.Printf("str2: %q\n", "\"string\"")
	//%x 输出使用 base-16 编码的字符串， 每个字节使用 2 个字符表示
	fmt.Printf("str3: %x\n", "hex this")
	//打印指针 pointer: 0xc00001a0c0
	fmt.Printf("pointer: %p\n", &p)
	//6位数字空间 右对齐
	//width1: |    12|   345|
	fmt.Printf("width1: |%6d|%6d|\n", 12, 345)
	//6位整数部分, . 占用一个 小数部分占2个
	//width2: |  1.20|  3.45|
	fmt.Printf("width2: |%6.2f|%6.2f|\n", 1.2, 3.45)
	//和width2一样，只不过为左对齐
	//width3: |1.20  |3.45  |
	fmt.Printf("width3: |%-6.2f|%-6.2f|\n", 1.2, 3.45)

	//6个字符空间，右对齐
	//width4: |   foo|     b|
	fmt.Printf("width4: |%6s|%6s|\n", "foo", "b")
	//左对齐
	//width5: |foo   |b     |
	fmt.Printf("width5: |%-6s|%-6s|\n", "foo", "b")

	//格式化到字符串
	s := fmt.Sprintf("sprintf: a %s", "string")
	fmt.Println(s) //sprintf: a string

	//格式化到文件描述符,os.Stderr其实就是文件指针
	//io: an sprintf: a string
	fmt.Fprintf(os.Stderr, "io: an %s\n", s)

}
```

## 文本模板

Go 使用 text/template 包为创建动态内容或向用户显示自定义输出提供了内置支持。 一个名为 html/template 的兄弟软件包提供了相同的 API，但具有额外的安全功能，被用于生成 HTML。

C++有个第三方库挺好用，https://github.com/pantor/inja

```go
package main

import (
	"html/template"
	"os"
)

func main() {
	//创建名为t1的模板
	t1 := template.New("t1")
	//解析模板字符串
	t1, err := t1.Parse("Value is {{.}}\n")
	if err != nil {
		panic(err)
	}
	/*
		template.Must函数是一个实用函数，它用于将模板解析过程和错误检查结合在一起。如果t1.Parse成功，template.Must返回t1，否则会引发panic并显示错误消息。这样可以确保模板的解析过程不会失败，否则程序会崩溃。
	*/
	t1 = template.Must(t1.Parse("Value: {{.}}\n"))
	/*
		Value: some text
		Value: 5
		Value: [Go Rust C&#43;&#43; C#]
	*/
	t1.Execute(os.Stdout, "some text")
	t1.Execute(os.Stdout, 5)
	t1.Execute(os.Stdout, []string{
		"Go",
		"Rust",
		"C++",
		"C#",
	})

	//封装模板构造
	Create := func(name, t string) *template.Template {
		return template.Must(template.New(name).Parse(t))
	}

	//如果数据是一个结构体，我们可以使用 {{.FieldName}} 动作来访问其字段。 这些字段应该是导出的，以便在模板执行时可访问。
	t2 := Create("t2", "Name: {{.Name}}\n")
	//Name: Jane Doe
	t2.Execute(os.Stdout, struct {
		Name string
	}{"Jane Doe"})
	//Name: Mickey Mouse
	t2.Execute(os.Stdout, map[string]string{
		"Name": "Mickey Mouse",
	})
	//这同样适用于 map；在 map 中没有限制键名的大小写。

	//if/else 提供了条件执行模板。如果一个值是类型的默认值，例如 0、空字符串、空指针等， 则该值被认为是 false。
	//这个示例演示了另一个模板特性：使用 - 在动作中去除空格。
	t3 := Create("t3",
		"{{if . -}} yes {{else -}} no {{end}}\n")
	//yes
	t3.Execute(os.Stdout, "not empty")
	//no
	t3.Execute(os.Stdout, "")

	//切片 在模板中使用Range
	t4 := Create("t4", "Range:{{range .}}{{.}} {{end}}\n")
	t4.Execute(os.Stdout, []string{
		"GO",
		"Rust",
		"C++",
		"C#",
	})
	//Range:GO Rust C&#43;&#43; C#
}
```

## 正则表达式

Go 提供了内建的正则表达式支持。C++当然也有支持的。

```go
package main

import (
	"bytes"
	"fmt"
	"regexp"
)

func main() {
	//正则匹配
	match, _ := regexp.MatchString("p([a-z]+)ch", "peach")
	fmt.Println(match) //true

	//构造正则表达式
	r, _ := regexp.Compile("p([a-z]+)ch")
	fmt.Println(r.MatchString("peach")) //true

	//搜索 返回第一个
	//peach
	fmt.Println(r.FindString("peach punch"))
	//[2 7] 下标[2,7)
	fmt.Println(r.FindStringIndex("a peach punch"))

	//[peach ea]
	fmt.Println(r.FindStringSubmatch("peach punch"))
	//[0 5 1 3]
	fmt.Println(r.FindStringSubmatchIndex("peach punch"))

	//搜索多个
	//[peach punch]
	fmt.Println(r.FindAllString("peach punch pinch", 2))
	//搜索所有
	//[peach punch pinch]
	fmt.Println(r.FindAllString("peach punch pinch", -1))
	//all: [[0 5 1 3] [6 11 7 9] [12 17 13 15]]
	fmt.Println("all:", r.FindAllStringSubmatchIndex(
		"peach punch pinch", -1))

	//true
	fmt.Println(r.Match([]byte("peach")))

	//MustCompile失败则会panic
	r = regexp.MustCompile("p([a-z]+)ch")
	fmt.Println("regexp:", r) //regexp: p([a-z]+)ch

	//正则替换
	//a <fruit>
	fmt.Println(r.ReplaceAllString("a peach", "<fruit>"))

	//正则回调替换
	//a PEACH
	in := []byte("a peach")
	out := r.ReplaceAllFunc(in, bytes.ToUpper)
	fmt.Println(string(out))
}
```

## JSON

Go 提供内建的 JSON 编码解码（序列化反序列化）支持， 包括内建及自定义类型与 JSON 数据之间的转化。Awesome!!!

```go
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type response1 struct {
	Page   int
	Fruits []string
}

type resposne2 struct {
	Page   int      `json:"page"`
	Fruits []string `json:"fruits"`
}

func main() {
	//序列化json.Marshal

	//bool
	bolB, _ := json.Marshal(true)
	fmt.Println(string(bolB)) //true

	//int
	intB, _ := json.Marshal(1)
	fmt.Println(string(intB)) //1

	//float
	fltB, _ := json.Marshal(2.34)
	fmt.Println(string(fltB)) //2.34

	//string
	strB, _ := json.Marshal("gopher")
	fmt.Println(string(strB)) //"gopher"

	//array
	slcD := []string{"apple", "peach", "pear"}
	slcB, _ := json.Marshal(slcD)
	fmt.Println(string(slcB)) //["apple","peach","pear"]

	//map
	mapD := map[string]int{"apple": 5, "lettuce": 7}
	mapB, _ := json.Marshal(mapD)
	fmt.Println(string(mapB)) //{"apple":5,"lettuce":7}

	//object
	res1D := &response1{
		Page:   1,
		Fruits: []string{"apple", "peach", "pear"}}
	res1B, _ := json.Marshal(res1D)
	//{"Page":1,"Fruits":["apple","peach","pear"]}
	fmt.Println(string(res1B))

	res2D := &resposne2{
		Page:   1,
		Fruits: []string{"apple", "peach", "pear"}}
	res2B, _ := json.Marshal(res2D)
	//{"page":1,"fruits":["apple","peach","pear"]}
	fmt.Println(string(res2B))

	byt := []byte(`{"num":6.13,"strs":["a","b"]}`)
	var dat map[string]interface{}
	if err := json.Unmarshal(byt, &dat); err != nil {
		panic(err)
	}
	//map[num:6.13 strs:[a b]]
	fmt.Println(dat)

	num := dat["num"].(float64)
	fmt.Println(num) //6.13

	strs := dat["strs"].([]interface{})
	str1 := strs[0].(string)
	fmt.Println(str1) //a

	str := `{"page": 1, "fruits": ["apple", "peach"]}`
	res := resposne2{}
	json.Unmarshal([]byte(str), &res)
	fmt.Println(res)           //{1 [apple peach]}
	fmt.Println(res.Fruits[0]) //apple

	enc := json.NewEncoder(os.Stdout)
	d := map[string]int{"apple": 5, "lettuce": 7}
	enc.Encode(d) //{"apple":5,"lettuce":7}
}
```

## XML

Go 通过 encoding.xml 包为 XML 和 类-XML 格式提供了内建支持。总之很鸡肋。

```go
package main

import (
	"encoding/xml"
	"fmt"
)

type Plant struct {
	XMLName xml.Name `xml:"plant"`
	Id      int      `xml:"id,attr"`
	Name    string   `xml:"name"`
	Origin  []string `xml:"Origin"`
}

func (p Plant) String() string {
	return fmt.Sprintf("Plant id=%v,name=%v,origin=%v", p.Id, p.Name, p.Origin)
}

func main() {
	coffee := &Plant{Id: 27, Name: "Coffee"}
	coffee.Origin = []string{"AAA", "BBB"}
	out, _ := xml.MarshalIndent(coffee, " ", " ")
	fmt.Println(string(out))
	/*
		<plant id="27">
		  <name>Coffee</name>
		  <Origin>AAA</Origin>
		  <Origin>BBB</Origin>
		</plant>
	*/
	fmt.Println(xml.Header + string(out))
	/*
		<?xml version="1.0" encoding="UTF-8"?>
		 <plant id="27">
		  <name>Coffee</name>
		  <Origin>AAA</Origin>
		  <Origin>BBB</Origin>
		 </plant>
	*/
	var p Plant
	if err := xml.Unmarshal(out, &p); err != nil {
		panic(err)
	}
	fmt.Println(p)
	//Plant id=27,name=Coffee,origin=[AAA BBB]

	tomato := &Plant{Id: 81, Name: "Tomato"}
	tomato.Origin = []string{"Mexico", "California"}

	type Nesting struct {
		XMLName xml.Name `xml:"nesting"`
		Plants  []*Plant `xml:"parent>child>plant"`
	}
	nesting := &Nesting{}
	nesting.Plants = []*Plant{coffee, tomato}
	out, _ = xml.MarshalIndent(nesting, " ", " ")
	fmt.Println(string(out))
	/*
		<nesting>
		  <parent>
		   <child>
		    <plant id="27">
		     <name>Coffee</name>
		     <Origin>AAA</Origin>
		     <Origin>BBB</Origin>
		    </plant>
		    <plant id="81">
		     <name>Tomato</name>
		     <Origin>Mexico</Origin>
		     <Origin>California</Origin>
		    </plant>
		   </child>
		  </parent>
		</nesting>
	*/
}
```

## 时间

Go 为时间（time）和时间段（duration）提供了大量的支持；

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	p := fmt.Println
	now := time.Now()
	p(now) //2023-09-06 23:17:04.2315883 +0800 CST m=+0.003479201
	then := time.Date(2009, 11, 17, 20, 34, 58, 651387237, time.UTC)
	p(then) //2009-11-17 20:34:58.651387237 +0000 UTC

	p(then.Year())       //2009
	p(then.Month())      //November
	p(then.Day())        //17
	p(then.Hour())       //20
	p(then.Minute())     //34
	p(then.Second())     //58
	p(then.Nanosecond()) //651387237
	p(then.Location())   //UTC
	p(then.Weekday())    //Tuesday

	p(then.Before(now)) //true
	p(then.After(now))  //false
	p(then.Equal(then)) //true

	//时间间隔
	diff := now.Sub(then)
	p(diff)               //120978h46m45.054955063s
	p(diff.Hours())       //120978.79400789388
	p(diff.Minutes())     //7.258727640473633e+06
	p(diff.Seconds())     //4.35523658428418e+08
	p(diff.Nanoseconds()) //435523658428417963

	p(then.Add(diff))  //2023-09-06 15:23:31.7993186 +0000 UTC
	p(then.Add(-diff)) //1996-01-30 01:46:25.503455874 +0000 UTC

}
```

## 事件戳

一般程序会有获取 Unix 时间 的秒数，毫秒数，或者微秒数的需求。  
分别使用 time.Now 的 Unix 和 UnixNano， 来获取从 Unix 纪元起，到现在经过的秒数和纳秒数。  
注意 UnixMillis 是不存在的，所以要得到毫秒数的话， 你需要手动的从纳秒转化一下。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	now := time.Now()
	secs := now.Unix()
	nanos := now.UnixNano()
	fmt.Println(now)

	millis := nanos / 1000000
	fmt.Println(secs)   //1694014017
	fmt.Println(millis) //1694014017306
	fmt.Println(nanos)  //1694014017306408400

	//你也可以将 Unix 纪元起的整数秒或者纳秒转化到相应的时间。
	fmt.Println(time.Unix(secs, 0))  //2023-09-06 23:28:28 +0800 CST
	fmt.Println(time.Unix(0, nanos)) //2023-09-06 23:28:28.5384755 +0800 CST
}
```

## 时间的格式化和解析

Go 支持通过基于描述模板的时间格式化与解析。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	p := fmt.Println

	t := time.Now()
	//2023-09-13T22:48:00+08:00
	p(t.Format(time.RFC3339))

	t1, e := time.Parse(
		time.RFC3339,
		"2012-11-01T22:08:41+00:00")
	if e == nil {
		p(t1) //2012-11-01 22:08:41 +0000 +0000
	}
	//10:50PM
	p(t.Format("3:04PM"))
	//Wed Sep 13 22:52:01 2023
	p(t.Format("Mon Jan _2 15:04:05 2006"))
	//2023-09-13T22:56:01.126711+08:00
	p(t.Format("2006-01-02T15:04:05.999999-07:00"))
	form := "3 04 PM"
	t2, e := time.Parse(form, "8 41 PM")
	if e == nil {
		p(t2) //0000-01-01 20:41:00 +0000 UTC
	}

	//2023-09-13T22:57:56-00:00
	fmt.Printf("%d-%02d-%02dT%02d:%02d:%02d-00:00\n",
		t.Year(), t.Month(), t.Day(),
		t.Hour(), t.Minute(), t.Second())

	ansic := "Mon Jan _2 15:04:05 2006"
	t, e = time.Parse(ansic, "8:41PM")
	p(e) //parsing time "8:41PM" as "Mon Jan _2 15:04:05 2006": cannot parse "8:41PM" as "Mon"
	p(t) //0001-01-01 00:00:00 +0000 UTC
}
```

## 随机数

Go 的 math/rand 包提供了伪随机数生成器。

```go
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	//rand.Intn 返回一个随机的整数 n，且 0 <= n < 100。
	fmt.Println(rand.Intn(100)) //85
	fmt.Println(rand.Intn(100)) //30

	//rand.Float64 返回一个64位浮点数 f，且 0.0 <= f < 1.0。
	fmt.Println(rand.Float64())           //0.5017169387431317
	fmt.Println((rand.Float64() * 5) + 5) //[5.0,10.0]

	//种种子
	s1 := rand.NewSource(time.Now().UnixNano())
	r1 := rand.New(s1)

	fmt.Println(r1.Intn(100)) //[0,100]
	fmt.Println(r1.Intn(100)) //[0,100]

	s2 := rand.NewSource(42)
	r2 := rand.New(s2)
	fmt.Println(r2.Intn(100)) //5 每次都是5

	s3 := rand.NewSource(42)
	r3 := rand.New(s3)
	fmt.Println(r3.Intn(100)) //5 每次都是5

	fmt.Println(r3.Intn(100)) //87 每次都是87
}
```

## 数字解析

从字符串中解析数字在很多程序中是一个基础常见的任务，内建的 strconv 包提供了数字解析能力。

```go
package main

import (
	"fmt"
	"strconv"
)

func main() {
	f, _ := strconv.ParseFloat("1.234", 64)
	fmt.Println(f) //1.234

	i, _ := strconv.ParseInt("123", 0, 64)
	fmt.Println(i) //123

	d, _ := strconv.ParseInt("0x1c8", 0, 64)
	fmt.Println(d) //456

	u, _ := strconv.ParseUint("789", 0, 64)
	fmt.Println(u) //789

	k, _ := strconv.Atoi("135")
	fmt.Println(k) //135

	_, e := strconv.Atoi("wat")
	fmt.Println(e) //strconv.Atoi: parsing "wat": invalid syntax
}
```

## URL 解析

URL 提供了统一资源定位方式。

```go
package main

import (
	"fmt"
	"net"
	"net/url"
)

func main() {
	s := "postgres://user:pass@host.com:5432/path?k=v&k=o#f"
	u, err := url.Parse(s)
	if err != nil {
		fmt.Println(err)
	} else {
		//postgres
		fmt.Println(u.Scheme)
		fmt.Println(u.User)            //pass
		fmt.Println(u.User.Username()) //user
		p, _ := u.User.Password()
		fmt.Println(p) //pass

		fmt.Println(u.Host) //host.com:5432
		host, port, _ := net.SplitHostPort(u.Host)
		fmt.Println(host) //host.com
		fmt.Println(port) //5432

		fmt.Println(u.Path)     // /path
		fmt.Println(u.Fragment) // f
		fmt.Println(u.RawQuery) // k=v&k=o

		m, _ := url.ParseQuery(u.RawQuery)
		fmt.Println(m)         //map[k:[v o]]
		fmt.Println(m["k"][0]) //v
	}
}
```

## SHA256 散列

SHA256 散列（hash） 经常用于生成二进制文件或者文本块的短标识。 例如，TLS/SSL 证书使用 SHA256 来计算一个证书的签名。

SHA-256，全称为"Secure Hash Algorithm 256-bit"，是一种密码学散列函数，它接受输入数据并将其转换为固定长度的 256 位（32 字节）散列值。SHA-256 属于 SHA-2（Secure Hash Algorithm 2）家族，是 SHA-2 家族中的一员。

SHA-256 散列函数有以下特点：

- 固定长度输出： 无论输入数据的大小如何，SHA-256 始终生成一个 256 位的散列值，这意味着输出长度始终相同。

- 不可逆性： SHA-256 是一个单向散列函数，即不能从散列值反推出原始输入数据。这是密码学安全性的基本要求之一。

- 碰撞抵抗性： SHA-256 被设计为具有很高的碰撞抵抗性，这意味着找到两个不同的输入，它们产生相同的散列值的难度非常大。

- 困难性： 计算 SHA-256 散列值的逆过程（从散列值到原始输入）应该在当前计算技术下是困难的，以确保散列值的安全性。

SHA-256 常常用于密码学应用、数字签名、数据完整性验证和密码哈希存储。例如，在密码学中，它可以用于确保数据传输的完整性，或者用于存储用户密码的散列值，以增加安全性。

需要注意的是，虽然 SHA-256 在许多用例中非常有用，但在某些情况下，可能需要更长的散列（如 SHA-512）或其他加密算法，以满足特定的安全要求。此外，密码学领域不断发展，对于安全性要求不断提高，因此也会出现更安全的散列算法。因此，在选择散列算法时，需要考虑具体的用例和安全需求。

```go
package main

import (
	"crypto/sha256"
	"fmt"
)

func main() {
	s := "sha256 this string"
	h := sha256.New()
	h.Write([]byte(s))
	bs := h.Sum(nil)
	fmt.Println(s)
	fmt.Printf("%x", bs)
}

//sha256 this string
//1af1dfa857bf1d8814fe1af8983c18080019922e557f15a8a0d3db739d77aacb
```

## Base64 编码

Go 提供了对 base64 编解码的内建支持。

Base64 编码是一种用于将二进制数据转换为文本字符的编码方法。它将二进制数据（例如图片、音频、文件等）转换为由 64 个不同字符组成的 ASCII 字符串，这些字符包括大小写字母、数字和一些特殊符号。Base64 编码的主要目的是将二进制数据表示为文本，以便在文本协议（如电子邮件、XML、JSON）中传输或存储，因为文本协议通常不支持二进制数据的直接传输。

Base64 编码的特点和用途包括：

- 可打印字符集： Base64 使用的字符都是可打印字符，不包含控制字符，因此适合在文本环境中使用。
- 固定长度： Base64 编码后的输出是由一系列字符组成的，这些字符的数量是固定的，这有助于在不同系统之间准确地传输二进制数据。
- 无损压缩： Base64 编码不会损失原始数据的信息，因此可以对数据进行无损压缩。
- 常见用途： Base64 编码常常用于将二进制数据嵌入到文本文档中，如将图片嵌入到 HTML 或将二进制数据附加到 JSON 或 XML 数据中。它也常用于编码用户名和密码等凭据，以便在 HTTP 请求中传输。

Base64 编码的原理是将每 3 个字节的二进制数据编码为 4 个 Base64 字符。如果原始数据的字节数不是 3 的倍数，编码后会使用填充字符（通常是等号 =）来保持输出长度的完整性。解码过程是 Base64 编码的逆过程，将 Base64 字符串还原为原始的二进制数据。

以下是一个示例，展示了如何使用 Base64 编码和解码数据，假设有一个二进制数据流：

原始数据：Hello, World!

Base64 编码后的数据：SGVsbG8sIFdvcmxkIQ==

Base64 解码后的数据：Hello, World!

Base64 编码通常由各种编程语言的标准库提供支持，因此在实际开发中，你可以方便地进行编码和解码操作。

```go
package main

import (
	b64 "encoding/base64"
	"fmt"
)

func main() {
	data := "Hello, World!"

	//使用 标准 base64 格式进行编解码。
	sEnc := b64.StdEncoding.EncodeToString([]byte(data))
	fmt.Println(sEnc) //SGVsbG8sIFdvcmxkIQ==

	sDec, _ := b64.StdEncoding.DecodeString(sEnc)
	fmt.Println(string(sDec)) //Hello, World!

	//使用 URL base64 格式进行编解码。
	data1 := "abc123!?$*&()'-=@~ '"
	uEnc := b64.URLEncoding.EncodeToString([]byte(data1))
	fmt.Println(uEnc) //YWJjMTIzIT8kKiYoKSctPUB-
	uDec, _ := b64.URLEncoding.DecodeString(uEnc)
	fmt.Println(string(uDec)) //abc123!?$*&()'-=@~
}
```

## 读文件

读文件，任何语言都差不多嘛。但是 io 毕竟是重头戏，肯定有很多的语法糖或者语言特性。下面的只是冰山一角。

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	//ReadFile
	dat, err := os.ReadFile("./mypack.go")
	check(err)
	fmt.Print(string(dat)) //输出文件内全部内容

	f, err := os.Open("./mypack.go")
	check(err)

	//Read
	b1 := make([]byte, 5)
	n1, err := f.Read(b1)
	check(err)
	fmt.Printf("%d bytes: %s\n", n1, string(b1[:n1]))
	//5 bytes: packa

	//Seek
	o2, err := f.Seek(6, io.SeekStart)
	//io.SeekCurrent io.SeekEnd
	check(err)
	b2 := make([]byte, 2)
	n2, err := f.Read(b2)
	check(err)
	fmt.Printf("%d bytes @ %d: %v", n2, o2, string(b2[:n2]))

	//io.ReadAtLeast 用于从输入源中读取至少指定数量的字节数据
	o3, err := f.Seek(6, io.SeekStart)
	check(err)
	b3 := make([]byte, 2)

	n3, err := io.ReadAtLeast(f, b3, 2)
	check(err)
	fmt.Printf("%d bytes @ %d: %s\n", n3, o3, string(b3))

	_, err = f.Seek(0, io.SeekStart)
	check(err)

	//bufio.NewReader 创建一个带有缓冲的读取器，它可以用于提高文件或其他输入源的读取性能
	r4 := bufio.NewReader(f) //缓冲区默认的大小是 4096 字节
	b4, err := r4.Peek(5)    //取前5字节
	check(err)
	fmt.Printf("5 bytes: %s\n", string(b4))
	f.Close()
}

//func NewReader(rd io.Reader) *Reader
//rd：实现了 io.Reader 接口的输入源，可以是文件、网络连接、字符串、字节数组等。
```

## 写文件

写文件和读文件类似，二者操作基本呈现对称。

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	d1 := []byte("hello\ngo\n")
	//覆盖写
	err := os.WriteFile("./tmp.txt", d1, 0644)
	check(err)

	//创建新文件
	f, err := os.Create("./tmp1.txt")
	check(err)

	defer f.Close() //推迟

	d2 := []byte{115, 111, 109, 101, 10}
	n2, err := f.Write(d2)
	check(err)
	fmt.Printf("wrote %d bytes\n", n2)
	//wrote 5 bytes

	n3, err := f.WriteString("writes\n")
	check(err)
	fmt.Printf("wrote %d bytes\n", n3)
	//wrote 7 bytes

	f.Sync() //同步,用于将文件的内存缓冲区的内容刷新到磁盘上的文件中

	w := bufio.NewWriter(f)
	n4, err := w.WriteString("buffered\n")
	check(err)
	fmt.Printf("wrote %d bytes\n", n4)
	//wrote 9 bytes
	w.Flush() //用于手动刷新缓冲区，将缓冲区中的数据写入底层的输出流（如文件、网络连接等
}
```

## 行过滤器

行过滤器（line filter） 是一种常见的程序类型， 它读取 stdin 上的输入，对其进行处理，然后将处理结果打印到 stdout。 grep 和 sed 就是常见的行过滤器。

```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	//scanner.Scan将在回车时返回
	for scanner.Scan() {
		ucl := strings.ToUpper(scanner.Text())
		fmt.Println(ucl)
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "error: ", err)
		os.Exit(1)
	}
}
```

检查 Scan 的错误。 文件结束符（EOF）是可以接受的，它不会被 Scan 当作一个错误。

## 文件路径

filepath 包为 文件路径 ，提供了方便的跨操作系统的解析和构建函数； 比如：Linux 下的 dir/file 和 Windows 下的 dir\file 。

其实 C++ filesystem 库现在也有这套东西了。

```go
package main

import (
	"fmt"
	"path/filepath"
	"strings"
)

func main() {
	p := filepath.Join("dir1", "dir2", "filename")
	fmt.Println("p:", p)
	//p: dir1\dir2\filename
	fmt.Println(filepath.Join("dir1//", "filename"))
	//dir1\filename
	fmt.Println(filepath.Join("dir1/../dir1", "filename"))
	//dir1\filename

	// Dir 和 Base 可以被用于分割路径中的目录和文件。 此外，Split 可以一次调用返回上面两个函数的结果。
	fmt.Println("Dir(p):", filepath.Dir(p))
	//Dir(p): dir1\dir2
	fmt.Println("Base(p):", filepath.Base(p))
	//Base(p): filename

	//判断是否为绝对路径
	fmt.Println(filepath.IsAbs("dir/file")) //false
	fmt.Println(filepath.IsAbs("C:\\Users\\gaowanlu\\Desktop\\MyProject\\note\\testcode\\go"))
	//true

	//文件扩展名
	filename := "config.json"
	ext := filepath.Ext(filename)
	fmt.Println(ext)                               //.json
	fmt.Println(strings.TrimSuffix(filename, ext)) //config

	//Rel 寻找 basepath 与 targpath 之间的相对路径。 如果相对路径不存在，则返回错误。
	rel, err := filepath.Rel("./tmp", "../build/")
	if err != nil {
		panic(err)
	}
	fmt.Println(rel) //..\..\build
}
```

## 目录

对于操作文件系统中的 目录 ，Go 提供了几个非常有用的函数。

```go
package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	err := os.Mkdir("subdir", 0755) //在当前工作目录下，创建一个子目录。
	check(err)
	defer os.RemoveAll("subdir") //类似于 rm -rf

	// 一个用于创建临时文件的帮助函数
	createEmptyFile := func(name string) {
		d := []byte("")
		check(os.WriteFile(name, d, 0644))
	}
	createEmptyFile("subdir/file1")

	//类似于命令 mkdir -p
	err = os.MkdirAll("subdir/parent/child", 0755)
	check(err)

	//ReadDir 列出目录的内容，返回一个 os.DirEntry 类型的切片对象。
	c, err := os.ReadDir("subdir/parent")
	check(err)
	for _, entry := range c {
		fmt.Println(" ", entry.Name(), entry.IsDir()) //  child true
	}

	//Chdir 可以修改当前工作目录，类似于 cd。
	err = os.Chdir("subdir/")
	check(err)
	c, err = os.ReadDir(".")
	check(err)
	for _, entry := range c {
		fmt.Println(" ", entry.Name(), entry.IsDir()) //  child true
	}

	//遍历一个目录及其所有子目录。 Walk 接受一个路径和回调函数，用于处理访问到的每个目录和文件。
	err = filepath.Walk("../", visit)
	check(err)
}

func visit(p string, info os.FileInfo, err error) error {
	if err != nil {
		return err
	}
	fmt.Println(" ", p, info.IsDir())
	return nil
}
```

## 临时文件和目录

在程序运行时，我们经常创建一些运行时用到，程序结束后就不再使用的数据。 临时目录和文件 对于上面的情况很有用，因为它不会随着时间的推移而污染文件系统。

```go
package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	//默认临时文件目录创建
	f, err := os.CreateTemp("", "sample")
	check(err)

	fmt.Println("Temp file name:", f.Name())
	//Temp file name: C:\Users\gaowanlu\AppData\Local\Temp\sample47593345

	defer os.Remove(f.Name())

	_, err = f.Write([]byte{1, 2, 3, 4})
	check(err)

	dname, err := os.MkdirTemp("", "sampledir")
	fmt.Println("Temp dir name:", dname)
	//Temp dir name: C:\Users\gaowanlu\AppData\Local\Temp\sampledir3959527615

	defer os.RemoveAll(dname)

	fname := filepath.Join(dname, "file1")
	err = os.WriteFile(fname, []byte{1, 2}, 0666)
	check(err)
}
```

## 单元测试和基准测试

单元测试是很重要的一部分。 testing 包为提供了编写单元测试所需的工具，写好单元测试后，我们可以通过 go test 命令运行测试。

实际上，单元测试的代码可以位于任何包下。 测试代码通常与需要被测试的代码位于同一个包下。

单元测试和基准测试，也算是专门的测试知识，尽量还是去单独学一下软件测试。不会也没关系，在服务端编程中有时写代码进行单元测试不常见，进行黑盒挺多的。

```go
package main

import (
	"fmt"
	"testing"
)

func IntMin(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func TestIntMinBasic(t *testing.T) {
	ans := IntMin(2, -2)
	if ans != -2 {
		//t.Error*会报告测试失败的信息，然后继续运行测试
		t.Errorf("IntMin(2, -2) = %d; want -2", ans)
	}
}

// 单元测试可以重复，所以会经常使用表驱动风格编写单元测试，
// 表中列出了输入数据，预期输出，使用循环，遍历并执行测试逻辑
func TestIntMinTableDriven(t *testing.T) {
	var tests = []struct {
		a, b int
		want int
	}{
		{0, 1, 0},
		{1, 0, 0},
		{2, -2, -2},
		{0, -1, -1},
		{-1, 0, -1},
	}

	for _, tt := range tests {
		testname := fmt.Sprintf("%d,%d", tt.a, tt.b)
		t.Run(testname, func(t *testing.T) {
			ans := IntMin(tt.a, tt.b)
			if ans != tt.want {
				t.Errorf("got %d, want %d", ans, tt.want)
			}
		})
	}
}

// 基准测试通常在_test.go文件中，以Benchmark开头命名
// testing 运行器多次执行每个基准测试函数，并在每次运行时增加 b.N， 直到它收集到精确的测量值。
// 通常，基准测试运行一个函数，我们在一个 b.N 次的循环内进行基准测试。
func BenchmarkIntMin(b *testing.B) {
	for i := 0; i < b.N; i++ {
		IntMin(1, 2)
	}
}

//$go test -v

//运行当前项目中的所有基准测试。所有测试都在基准测试之前运行。 bench 标志使用正则表达式过滤基准函数名称
//$go test -bench=.
```

## 命令行参数

命令行参数 是指定程序运行参数的一个常见方式。例如，go run hello.go， 程序 go 使用了 run 和 hello.go 两个参数。

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	argsWithProg := os.Args
	argsWithoutProg := os.Args[1:]
	fmt.Println(argsWithProg)
	fmt.Println(argsWithoutProg)
}

/*
./main.exe a b c
[C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go\main.exe a b c]
[a b c]
*/
```

## 命令行标识

命令行标志 是命令行程序指定选项的常用方式。例如，在 wc -l 中， 这个 -l 就是一个命令行标志。Go 提供了一个 flag 包，支持基本的命令行标志解析。

```go
package main

import (
	"flag"
	"fmt"
)

func main() {

	wordPtr := flag.String("word", "foo", "a string")

	numbPtr := flag.Int("numb", 42, "an int")
	forkPtr := flag.Bool("fork", false, "a bool")

	var svar string
	flag.StringVar(&svar, "svar", "bar", "a string var")

	flag.Parse()

	fmt.Println("word:", *wordPtr)
	fmt.Println("numb:", *numbPtr)
	fmt.Println("fork:", *forkPtr)
	fmt.Println("svar:", svar)
	fmt.Println("tail:", flag.Args())
}

/*
PS C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go> ./main.exe --help
Usage of C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go\main.exe:
  -fork
        a bool
  -numb int
        an int (default 42)
  -svar string
        a string var (default "bar")
  -word string
        a string (default "foo")
PS C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go> ./main.exe -fork false -numb 666 -svar love -word two
word: foo
numb: 42
fork: true
svar: bar
tail: [false -numb 666 -svar love -word two]
*/
```

## 命令行子命令

go 和 git 这种命令行工具，都有很多的 子命令 。 并且每个工具都有一套自己的 flag，比如： go build 和 go get 是 go 里面的两个不同的子命令。 flag 包让我们可以轻松的为工具定义简单的子命令。

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {

	//子命令 foo 可选参数 enable name
	fooCmd := flag.NewFlagSet("foo", flag.ExitOnError)
	fooEnable := fooCmd.Bool("enable", false, "enable")
	fooName := fooCmd.String("name", "", "name")

	//子命令 bar 可选参数 level
	barCmd := flag.NewFlagSet("bar", flag.ExitOnError)
	barLevel := barCmd.Int("level", 0, "level")

	if len(os.Args) < 2 {
		fmt.Println("expected 'foo' or 'bar' subcommands")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "foo":
		fooCmd.Parse(os.Args[2:])
		fmt.Println("subcommand 'foo'")
		fmt.Println("  enable:", *fooEnable)
		fmt.Println("  name:", *fooName)
		fmt.Println("  tail:", fooCmd.Args())
	case "bar":
		barCmd.Parse(os.Args[2:])
		fmt.Println("subcommand 'bar'")
		fmt.Println("  level:", *barLevel)
		fmt.Println("  tail:", barCmd.Args())
	default:
		fmt.Println("expected 'foo' or 'bar' subcommands")
		os.Exit(1)
	}
}

/*
PS C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go> ./main.exe foo
subcommand 'foo'
  enable: false
  name:
  tail: []
PS C:\Users\gaowanlu\Desktop\MyProject\note\testcode\go> ./main.exe bar -level 12
subcommand 'bar'
  level: 12
  tail: []
*/
```

## 环境变量

环境变量 是一种向 Unix 程序传递配置信息的常见方式。 让我们来看看如何设置、获取以及列出环境变量。

```go
package main

import (
	"fmt"
	"os"
	"strings"
)

// 默认只在本程序运行期间有效
func main() {
	os.Setenv("FOO", "1")
	fmt.Println("FOO:", os.Getenv("FOO")) //FOO: 1
	fmt.Println("BAR", os.Getenv("BAR"))  //BAR
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		fmt.Println(pair[0], "=", pair[1])
	}
}
```

## HTTP 客户端

Go 标准库的 net/http 包为 HTTP 客户端和服务端提供了出色的支持。

```go
package main

import (
	"bufio"
	"fmt"
	"net/http"
)

func main() {
	resp, err := http.Get("http://gobyexample.com")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	//Response status: 200 OK
	fmt.Println("Response status:", resp.Status)
	scanner := bufio.NewScanner(resp.Body)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		panic(err)
	}
}

/*
Response status: 200 OK
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Go by Example</title>
	...
*/
```

## HTTP 服务端

使用 net/http 包，我们可以轻松实现一个简单的 HTTP 服务器。

```go
package main

import (
	"fmt"
	"net/http"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func headers(w http.ResponseWriter, req *http.Request) {
	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

func main() {
	http.HandleFunc("/hello", hello)
	http.HandleFunc("/headers", headers)
	http.ListenAndServe(":8090", nil)
}
```

## Context

Go 语言的 context 包是用于在 Go 应用程序中传递取消信号、截止时间和跟踪请求范围的重要工具。context 包提供了一种可用于协调多个 goroutine 的方法，以便它们能够协同工作并共享信息，例如取消信号、超时、截止时间以及上下文值等。

context 包中最常用的类型是 context.Context，它是一个接口，用于包含与请求相关的信息。context.Context 类型可以通过
context.Background()或 context.TODO()来创建，通常用作根上下文。

1. 创建上下文

- context.Background()：创建一个空的上下文，通常用作根上下文
- context.TODO()：创建一个类似于 Background()的上下文，表示未来可能会添加更多的上下文信息。

2. 传递上下文

上下文可以在 goroutine 之间传递，以便它们能够共享上下文的信息，包括取消信号、截止时间和上下文值。

3. 上下文的取消

通过 context.WithCancel()、context.WithTimeout()和 context.WithDeadline()等方法，可以创建一个带有取消信号的新上下文。当调用上下文的 cancel()函数时，所有依赖于该上下文的 goroutine 都会收到取消信号。

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel() // 始终确保在不再需要时调用cancel
```

4. 设置截止时间

可以使用 context.WithTimeout()和 context.WithDeadline()来为上下文设置截止时间。当截止时间到达时，上下文将被自动取消。

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()
```

5. 上下文值

可以使用 context.WithValue()来为上下文添加键值对形式的上下文值。这些值可以在 goroutine 之间传递，但应谨慎使用，以避免滥用上下文来传递状态。

```go
ctx := context.WithValue(context.Background(), key, value)
```

6. 检查取消信号

在 goroutine 内，可以使用 ctx.Done()通道来检查取消信号，以确定是否应该退出。

```go
select {
case <-ctx.Done():
    // 上下文已取消，执行清理工作并退出
}
```

7. 传递上下文

当启动新的 goroutine 时，通常将上下文作为参数传递给该 goroutine，以确保它们可以访问相同的上下文信息。

```go
go func(ctx context.Context) {
    // 在这里使用ctx
}(ctx)
```

context 包的主要目的是协调多个 goroutine 之间的行为，特别是在取消操作和截止时间方面。使用 context 可以帮助管理资源、避免资源泄漏以及实现更可靠的并发控制。在编写 Go 应用程序时，特别是涉及网络请求、并发任务或长时间运行的任务时，context 包是非常有用的工具。

```go
package main

import (
	"fmt"
	"net/http"
	"time"
)

func hello(w http.ResponseWriter, req *http.Request) {
	ctx := req.Context()
	fmt.Println("server: hello handler started")
	defer fmt.Println("server: hello handler ended")

	select {
	case <-time.After(10 * time.Second):
		fmt.Fprintf(w, "hello\n") //请求10s后才会客户端内容
	case <-ctx.Done():
		//在10s内http请求取消了
		err := ctx.Err()
		fmt.Println("server:", err)
		internalError := http.StatusInternalServerError
		http.Error(w, err.Error(), internalError)
	}
}

func main() {
	http.HandleFunc("/", hello)
	http.ListenAndServe(":8080", nil)
}

/*
server: hello handler started
server: context canceled
server: hello handler ended
*/
```

其他例子

```go
package main

import (
	"context"
	"fmt"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
		defer cancel() // 确保在函数退出时取消上下文

		// 使用通道来传递结果
		resultChan := make(chan string)

		go func() {
			// 模拟长时间运行的任务
			time.Sleep(5 * time.Second)
			resultChan <- "Task completed successfully"
		}()

		select {
		case <-ctx.Done():
			// 上下文已取消，返回错误信息
			http.Error(w, "Request canceled or timed out", http.StatusRequestTimeout)
			return
		case result := <-resultChan:
			// 长时间运行的任务已完成
			fmt.Fprintln(w, result)
		}
	})

	http.ListenAndServe(":8080", nil)
}
```

## 生成进程

有时，我们的 Go 程序需要生成其他的、非 Go 的进程。

```go
package main

import (
	"fmt"
	"io"
	"os/exec"
)

func main() {
	dateCmd := exec.Command("cmd", "/C", "dir") //运行date
	dateOut, err := dateCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println(string(dateOut))

	//使用生成进程的标准输入与输出
	myCmd := exec.Command("cmd", "/C", "dir")
	In, _ := myCmd.StdinPipe()
	Out, _ := myCmd.StdoutPipe()
	myCmd.Start()
	In.Write([]byte(""))
	Out.Close()
	resBytes, _ := io.ReadAll(Out)
	myCmd.Wait()
	fmt.Println(string(resBytes))

	/*
		在生成命令时，我们需要提供一个明确描述命令和参数的数组，而不能只传递一个命令行字符串。
		如果你想使用一个字符串生成一个完整的命令，那么你可以使用 bash 命令的 -c 选项：
	*/
	lsCmd := exec.Command("bash", "-c", "ls -a -l -h")
	lsOut, err := lsCmd.Output()
	if err != nil {
		panic(err)
	}
	fmt.Println("> ls -a -l -h")
	fmt.Println(string(lsOut))
}
```

## 执行进程

只想用其它（也许是非 Go）的进程，来完全替代当前的 Go 进程。 这时，我们可以使用经典的 exec 函数的 Go 的实现。

Go 没有提供 Unix 经典的 fork 函数。一般来说，这没有问题，因为启动协程、生成进程和执行进程， 已经涵盖了 fork 的大多数使用场景。

```go
package main

import (
	"os"
	"os/exec"
	"syscall"
)

func main() {

	binary, lookErr := exec.LookPath("ls") //应该是 /bin/ls
	if lookErr != nil {
		panic(lookErr)
	}

	args := []string{"ls", "-a", "-l", "-h"}

	env := os.Environ()

	//如果这个调用成功，那么我们的进程将在这里结束，并被 /bin/ls -a -l -h 进程代替。 如果存在错误，那么我们将会得到一个返回值。
	execErr := syscall.Exec(binary, args, env)
	if execErr != nil {
		panic(execErr)
	}
}
```

## 信号

有时候，我们希望 Go 可以智能的处理 Unix 信号。 例如，我们希望当服务器接收到一个 SIGTERM 信号时，能够优雅退出， 或者一个命令行工具在接收到一个 SIGINT 信号时停止处理输入信息。 我们这里讲的就是在 Go 中如何使用通道来处理信号。

确实比 Linux C++处理信号优雅太多了，加上协程和通道的加持太棒了。

```go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

func main() {

	sigs := make(chan os.Signal, 1)

	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	done := make(chan bool, 1)

	go func() {

		sig := <-sigs
		fmt.Println()
		fmt.Println(sig)
		done <- true
	}()

	fmt.Println("awaiting signal")
	<-done
	fmt.Println("exiting")
}
```

## 退出

使用 os.Exit 可以立即以给定的状态退出程序。C 中也有 exit。

不像例如 C 语言，Go 不使用在 main 中返回一个整数来指明退出状态。 如果你想以非零状态退出，那么你就要使用 os.Exit。

程序中的 ! 永远不会被打印出来。

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    //当使用 os.Exit 时 defer 将不会 被执行， 所以这里的 fmt.Println 将永远不会被调用。
	defer fmt.Println("!")
    os.Exit(3)
}
```
