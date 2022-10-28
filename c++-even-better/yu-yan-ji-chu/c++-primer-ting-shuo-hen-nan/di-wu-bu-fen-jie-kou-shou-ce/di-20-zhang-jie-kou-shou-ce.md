---
cover: >-
  https://images.unsplash.com/photo-1657682041053-cf8f17f96c86?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NjAwNjA2OTg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚴 第20章 接口手册

## 第20章 接口手册

### 标准库名字和头文件

A

```cpp
abort    <cstdlib>
accumulate    <numeric>
allocator    <memory>
array    <array>
auto_ptr    <memory>
```

B

```cpp
back_inserter    <iterator>
bad_alloc    <new>
bad_array_new_length    <new>
bad_cast    <typeinfo>
begin    <iterator>
bernoulli_distribution    <random>
bind    <functional>
bitset    <bitset>
boolalpha    <iostream>
```

C

```cpp
cerr    <iostream>
cin    <iostream>
cmatch    <regex>
copy    <algorithm>
count    <algorithm>
count_if    <algorithm>
cout    <iostream>
cref    <functional>
csub_match    <regex>
```

D

```cpp
dec    <iostream>
default_float_engine    <iostream>
default_random_engine    <random>
deque    <deque>
domain_error    <stdexcept>
```

E

```cpp
end    <iterator>
endl    <iostream>
ends    <iostream>
equal_range    <algorithm>
exception    <exception>
```

F

```cpp
fill    <algorithm>
fill_n    <algorithm>
find    <algorithm>
find_end    <algorithm>
find_first_of    <algorithm>
find_if    <algorithm>
fixed    <iostream>
flush    <iostream>
for_each    <algorithm>
forward    <utility>
forward_list    <forward_list>
free    <cstdlib>
front_inserter    <iterator>
fstream    <fstream>
function    <functional>
```

G

```cpp
get    <tuple>
getline    <string>
greater    <functional>
```

H

```cpp
hash    <functional>
hex    <iostream>
hexfloat    <iostream>
```

I

```cpp
ifstream    <fstream>
initializer_list    <initializer_list>
inserter    <iterator>
internal    <iostream>
ios_base    <iosbase>
isalpha    <cctype>
islower    <cctype>
isprint    <cctype>
ispunct    <cctype>
isspace    <cctype>
istream    <iostream>
istream_iterator    <iterator>
istringstream    <sstream>
isupper    <cctype>
```

L

```cpp
left    <iostream>
less    <functional>
less_equal    <functional>
list    <list>
logic_error    <stdexcept>
lower_bound    <algorithm>
lround    <cmath>
```

M

```cpp
make_move_iterator    <iterator>
make_pair    <utility>
make_shared    <memory>
make_tuple    <tuple>
malloc    <cstdlib>
map    <map>
max    <algorithm>
max_element    <algorithm>
mem_fn    <functional>
min    <algorithm>
move    <utility>
multimap    <map>
multiset    <set>
```

```cpp
negate    <functional>
noboolalpha    <iostream>
normal_distribution    <random>
noshowbase    <iostream>
noshowpoint    <iostream>
noskipws    <iostream>
not1    <functional>
nothrow    <new>
nothrow_t    <new>
nounitbuf    <iostream>
nouppercase    <iostream>
nth_element    <algorithm>
```

O

```cpp
oct    <iostream>
ofstream    <fstream>
ostream    <iostream>
ostream_iterator    <iterator>
ostringstream    <sstream>
out_of_range    <stdexcept>
```

P

```cpp
pair    <utility>
partial_sort    <algorithm>
placeholders    <functional>
placeholders::_1    <functional>
plus    <functional>
priority_queue    <queue>
ptrdiff_t    <cstddef>
```

Q

```cpp
queue    <queue>
```

R

```cpp
rand    <random>
random_device    <random>
range_error    <stdexcept>
ref    <functional>
regex    <regex>
regex_constants    <regex>
regex_error    <regex>
regex_match    <regex>
regex_replace    <regex>
regex_search    <regex>
remove_pointer    <type_traits>
remove_reference    <type_traits>
replace    <algorithm>
replace_copy    <algorithm>
reverse_iterator    <iterator>
right    <iostream>
runtime_error    <stdexcept>
```

S

```cpp
scientific    <iostream>
set    <set>
set_difference    <algorithm>
set_intersection    <algorithm>
set_union    <algorithm>
setfill    <iomanip>
setprecision    <iomanip>
setw    <iomanip>
shared_ptr    <memory>
showbase    <iostream>
showpoint    <iostream>
size_t    <cstddef>
skipws    <iostream>
smatch    <regex>
sort    <algorithm>
sqrt    <cmath>
sregex_iterator    <regex>
ssub_match    <regex>
stable_sort    <algorithm>
stack    <stack>
stoi    <string>
strcmp    <cstring>
strcpy    <cstring>
string    <string>
stringstream    <sstream>
strlen    <cstring>
strncpy    <cstring>
strtod    <string>
swap    <utility>
```

T

```cpp
terminate    <exception>
time    <ctime>
tolower    <cctype>
toupper    <cctype>
transform    <algorithm>
tuple    <tuple>
tuple_element    <tuple>
tuple_size    <tuple>
type_info    <typeinfo>
```

U

```cpp
unexpected    <exception>
uniform_int_distribution    <random>
uniform_real_distribution    <random>
uninitialized_copy    <memory>
uninitialized_fill    <memory>
unique    <algorithm>
unique_copy    <algorithm>
unique_ptr    <memory>
unitbuf    <iostream>
unordered_map    <unordered_map>
unordered_multimap    <unordered_map>
unordered_multiset    <unordered_set>
unordered_set    <unordered_set>
upper_bound    <algorithm>
uppercase    <iostream>
```

V

```cpp
vector    <vector>
```

W

```cpp
weak_ptr    <memory>
```

### 算法接口

在泛型编程中我们接触到了标准库中的算法，指示了解了算法的特性，并没有对其接口深入了解，下面是常见算法的使用方式及其接口

1、beg和end表示元素范围的迭代器，算法对一个由beg和end表示的序列进行操作\
2、beg2，end2是表示第二个输入序列开始和末尾位置的迭代器如果没有end2则表示第二个序列和第一个序列长度相同。beg和beg2的类型可以不匹配，但需要保证对两个序列中的元素都可以执行特定操作或调用给定的可调用对象。\
3、dest表示目的序列的迭代器。对于给定输入序列，算法需要生成多少元素，目的序列必须保证能保存相同多的元素。\
4、unaryPred和binaryPred是一元和二元谓词，分别接收一个和两个参数，都是来自输入序列的元素，两个谓词都可以返回可作用条件的类型\
5、comp是一个二元谓词，满足关联容器对关键字虚的要求\
6、unaryOp和binaryOp是可调用对象，可分别适用来自输入序列的一个和两个实参来调用

### 查找对象的算法

每个算法都提供两个重载，一个版本适用相等运算符比较，第二版本适用提供的unaryPred和binaryPred比较元素

### 简单查找算法 find、find\_if、find\_if\_not、count、count\_if、all\_of、any\_of、none\_of

![简单查找算法](<../../../../.gitbook/assets/屏幕截图 2022-08-08 180101 (1).jpg>)

### 查找重复值的算法 adjacent\_find、search\_n

![查找重复值的算法](<../../../../.gitbook/assets/屏幕截图 2022-08-08 180222.jpg>)

### 查找子序列的算法 search、find\_first\_of、find\_end

![查找子序列的算法](<../../../../.gitbook/assets/屏幕截图 2022-08-08 180443.jpg>)

### for\_each、mismatch、equal

![for\_each、mismatch、equal](<../../../../.gitbook/assets/屏幕截图 2022-08-08 181227.jpg>)

### 二分操作算法lower\_bound、upper\_bound、equal\_range、binary\_search

![二分操作算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 230547.jpg>)

### 只写不读的算法fill、fill\_n、generate、generate\_n

![只写不读的算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 230832.jpg>)

### 使用输入迭代器的写算法copy、copy\_if、copy\_n、move、transform、replace\_copy、replace\_copy\_if、merge

![使用输入迭代器的写算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 231046.jpg>)

### 使用向前迭代器的写算法iter\_swap、swap\_ranges、replace、replace\_if

![使用向前迭代器的写算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 231141.jpg>)

### 使用双向迭代器的写算法copy\_backward、move\_backward、inplace\_merge

![使用双向迭代器的写算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 231228.jpg>)

### 划分与排序算法

对于序列中的元素进行排序，排序和划分算法都提供了多种策略，每个排序和划分算法都提供了稳定和不稳定的版本

### 划分算法is\_partitioned、partition\_copy、partition\_point、stable\_partition、partition

![划分算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 231525.jpg>)

### 排序算法sort、stable\_sort、is\_sorted、is\_sorted\_until、partial\_sort、partial\_sort\_copy、nth\_element

![排序算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 231913.jpg>)

### 使用前向迭代器的重排算法remove、remove\_if、remove\_copy、remove\_copy\_if、unique、unique\_copy、rotate、rotate\_copy

![使用向前迭代器的重排算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 232333.jpg>)

### 使用双向迭代器的重排算法reverse、reverse\_copy

![使用双向迭代器的重排算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 232519.jpg>)

### 使用随机访问迭代器的重排算法random\_shuffle、random\_shuffle、shuffle

![使用随机访问迭代器的重排算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 232647.jpg>)

### 排列算法is\_permutation、next\_permutation、prev\_permutation

![排列算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 232900.jpg>)

### 有序序列的集合算法includes、set\_union、set\_intersection、set\_difference、set\_symmetric\_difference

![有序序列的集合算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 233117.jpg>)

### 最小值和最大值min、max、minmax、min\_element、max\_element、minmax\_element

![最小值和最大值](<../../../../.gitbook/assets/屏幕截图 2022-08-09 233431.jpg>)

### 字典序比较lexicographical\_compare

![字典序比较](<../../../../.gitbook/assets/屏幕截图 2022-08-09 233614.jpg>)

### 数值算法accumulate、inner\_product、partial\_sum、adjacent\_difference、iota

![数值算法](<../../../../.gitbook/assets/屏幕截图 2022-08-09 233906.jpg>)

### 随机数分布

![随机数分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234058.jpg>)

### 均匀分布uniform\_int\_distribution、uniform\_real\_distribution

![均匀分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234218.jpg>)

### 伯努利分布bernoulli\_distribution、geometric\_distribution、negative\_binomial\_distribution

![伯努利分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234408.jpg>)

### 泊松分布poisson\_distribution、exponential\_distribution、gamma\_distribution、weibull\_distribution、extreme\_value\_distribution

![泊松分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234442.jpg>)

### 正态分布normal\_distribution、lognormal\_distribution、chi\_squared\_distribution、cauchy\_distribution、fisher\_f\_distribution、student\_t\_distribution

![正态分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234513.jpg>)

### 抽样分布discrete\_distribution、piecewise\_constant\_distribution、piecewise\_linear\_distribution

![抽样分布](<../../../../.gitbook/assets/屏幕截图 2022-08-09 234544.jpg>)

### 随机数引擎default\_random\_engine、linear\_congruential\_engine、mersenne\_twister\_engine、subtract\_with\_carry\_engine、discard\_block\_engine、independent\_bits\_engine、shuffle\_order\_engin

![随机数引擎](<../../../../.gitbook/assets/屏幕截图 2022-08-09 235012.jpg>)
