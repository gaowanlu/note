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
