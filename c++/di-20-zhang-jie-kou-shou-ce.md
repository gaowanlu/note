---
cover: >-
  https://images.unsplash.com/photo-1657682041053-cf8f17f96c86?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NjAwNjA2OTg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚴 第 20 章 接口手册

## 第 20 章 接口手册

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

1、beg 和 end 表示元素范围的迭代器，算法对一个由 beg 和 end 表示的序列进行操作\
2、beg2，end2 是表示第二个输入序列开始和末尾位置的迭代器如果没有 end2 则表示第二个序列和第一个序列长度相同。beg 和 beg2 的类型可以不匹配，但需要保证对两个序列中的元素都可以执行特定操作或调用给定的可调用对象。\
3、dest 表示目的序列的迭代器。对于给定输入序列，算法需要生成多少元素，目的序列必须保证能保存相同多的元素。\
4、unaryPred 和 binaryPred 是一元和二元谓词，分别接收一个和两个参数，都是来自输入序列的元素，两个谓词都可以返回可作用条件的类型\
5、comp 是一个二元谓词，满足关联容器对关键字虚的要求\
6、unaryOp 和 binaryOp 是可调用对象，可分别适用来自输入序列的一个和两个实参来调用

### 查找对象的算法

每个算法都提供两个重载，一个版本适用相等运算符比较，第二版本适用提供的 unaryPred 和 binaryPred 比较元素

### 简单查找算法 find、find_if、find_if_not、count、count_if、all_of、any_of、none_of

![简单查找算法](<../.gitbook/assets/屏幕截图 2022-08-08 180101 (1).jpg>)

### 查找重复值的算法 adjacent_find、search_n

![查找重复值的算法](<../.gitbook/assets/屏幕截图 2022-08-08 180222.jpg>)

### 查找子序列的算法 search、find_first_of、find_end

![查找子序列的算法](<../.gitbook/assets/屏幕截图 2022-08-08 180443.jpg>)

### for_each、mismatch、equal

![for_each、mismatch、equal](<../.gitbook/assets/屏幕截图 2022-08-08 181227.jpg>)

### 二分操作算法 lower_bound、upper_bound、equal_range、binary_search

![二分操作算法](<../.gitbook/assets/屏幕截图 2022-08-09 230547.jpg>)

### 只写不读的算法 fill、fill_n、generate、generate_n

![只写不读的算法](<../.gitbook/assets/屏幕截图 2022-08-09 230832.jpg>)

### 使用输入迭代器的写算法 copy、copy_if、copy_n、move、transform、replace_copy、replace_copy_if、merge

![使用输入迭代器的写算法](<../.gitbook/assets/屏幕截图 2022-08-09 231046.jpg>)

### 使用向前迭代器的写算法 iter_swap、swap_ranges、replace、replace_if

![使用向前迭代器的写算法](<../.gitbook/assets/屏幕截图 2022-08-09 231141.jpg>)

### 使用双向迭代器的写算法 copy_backward、move_backward、inplace_merge

![使用双向迭代器的写算法](<../.gitbook/assets/屏幕截图 2022-08-09 231228.jpg>)

### 划分与排序算法

对于序列中的元素进行排序，排序和划分算法都提供了多种策略，每个排序和划分算法都提供了稳定和不稳定的版本

### 划分算法 is_partitioned、partition_copy、partition_point、stable_partition、partition

![划分算法](<../.gitbook/assets/屏幕截图 2022-08-09 231525.jpg>)

### 排序算法 sort、stable_sort、is_sorted、is_sorted_until、partial_sort、partial_sort_copy、nth_element

![排序算法](<../.gitbook/assets/屏幕截图 2022-08-09 231913.jpg>)

### 使用前向迭代器的重排算法 remove、remove_if、remove_copy、remove_copy_if、unique、unique_copy、rotate、rotate_copy

![使用向前迭代器的重排算法](<../.gitbook/assets/屏幕截图 2022-08-09 232333.jpg>)

### 使用双向迭代器的重排算法 reverse、reverse_copy

![使用双向迭代器的重排算法](<../.gitbook/assets/屏幕截图 2022-08-09 232519.jpg>)

### 使用随机访问迭代器的重排算法 random_shuffle、random_shuffle、shuffle

![使用随机访问迭代器的重排算法](<../.gitbook/assets/屏幕截图 2022-08-09 232647.jpg>)

### 排列算法 is_permutation、next_permutation、prev_permutation

![排列算法](<../.gitbook/assets/屏幕截图 2022-08-09 232900.jpg>)

### 有序序列的集合算法 includes、set_union、set_intersection、set_difference、set_symmetric_difference

![有序序列的集合算法](<../.gitbook/assets/屏幕截图 2022-08-09 233117.jpg>)

### 最小值和最大值 min、max、minmax、min_element、max_element、minmax_element

![最小值和最大值](<../.gitbook/assets/屏幕截图 2022-08-09 233431.jpg>)

### 字典序比较 lexicographical_compare

![字典序比较](<../.gitbook/assets/屏幕截图 2022-08-09 233614.jpg>)

### 数值算法 accumulate、inner_product、partial_sum、adjacent_difference、iota

![数值算法](<../.gitbook/assets/屏幕截图 2022-08-09 233906.jpg>)

### 随机数分布

![随机数分布](<../.gitbook/assets/屏幕截图 2022-08-09 234058.jpg>)

### 均匀分布 uniform_int_distribution、uniform_real_distribution

![均匀分布](<../.gitbook/assets/屏幕截图 2022-08-09 234218.jpg>)

### 伯努利分布 bernoulli_distribution、geometric_distribution、negative_binomial_distribution

![伯努利分布](<../.gitbook/assets/屏幕截图 2022-08-09 234408.jpg>)

### 泊松分布 poisson_distribution、exponential_distribution、gamma_distribution、weibull_distribution、extreme_value_distribution

![泊松分布](<../.gitbook/assets/屏幕截图 2022-08-09 234442.jpg>)

### 正态分布 normal_distribution、lognormal_distribution、chi_squared_distribution、cauchy_distribution、fisher_f_distribution、student_t_distribution

![正态分布](<../.gitbook/assets/屏幕截图 2022-08-09 234513.jpg>)

### 抽样分布 discrete_distribution、piecewise_constant_distribution、piecewise_linear_distribution

![抽样分布](<../.gitbook/assets/屏幕截图 2022-08-09 234544.jpg>)

### 随机数引擎 default_random_engine、linear_congruential_engine、mersenne_twister_engine、subtract_with_carry_engine、discard_block_engine、independent_bits_engine、shuffle_order_engin

![随机数引擎](<../.gitbook/assets/屏幕截图 2022-08-09 235012.jpg>)
