# MySQL 与 C++

## 简介

较好的文档https://www.tutorialspoint.com/mysql/index.htm,好的书籍《高性能MySQL》

## 在 C++使用

常用的函数

```cpp
mysql_affected_rows()：获取上一次 INSERT、UPDATE 或 DELETE 操作影响的行数。

mysql_autocommit()：开启或关闭 MySQL 连接的自动提交模式。

mysql_change_user()：修改 MySQL 连接的用户和密码。

mysql_character_set_name()：获取 MySQL 连接当前字符集的名称。

mysql_close()：关闭 MySQL 连接。

mysql_commit()：提交当前 MySQL 连接上的事务。

mysql_connect()：建立一个到 MySQL 数据库的连接。

mysql_create_db()：创建 MySQL 数据库。

mysql_data_seek()：将结果集的指针移动到指定的行号。

mysql_debug()：启用或禁用 MySQL 调试模式。

mysql_drop_db()：删除 MySQL 数据库。

mysql_dump_debug_info()：生成 MySQL 服务器的调试信息。

mysql_errno()：获取最近一次 MySQL 操作的错误码。

mysql_error()：获取最近一次 MySQL 操作的错误信息。

mysql_escape_string()：转义字符串以在 MySQL 查询中使用。

mysql_fetch_field()：获取结果集中的字段信息。

mysql_fetch_field_direct()：获取结果集中的指定字段信息。

mysql_fetch_fields()：获取结果集中的所有字段信息。

mysql_fetch_lengths()：获取结果集中的所有行的字段长度。

mysql_fetch_row()：获取结果集中的下一行数据。

mysql_field_count()：获取结果集中的字段数目。

mysql_field_seek()：将结果集的字段指针移动到指定位置。

mysql_field_tell()：获取结果集当前字段的位置。

mysql_free_result()：释放 MySQL 查询结果集。

mysql_get_character_set_info()：获取 MySQL 服务器支持的所有字符集。

mysql_get_client_info()：获取 MySQL 客户端的版本信息。

mysql_get_client_version()：获取 MySQL 客户端的版本号。

mysql_get_host_info()：获取 MySQL 服务器的主机名和连接信息。

mysql_get_proto_info()：获取 MySQL 服务器支持的协议版本。

mysql_get_server_info()：获取 MySQL 服务器的版本信息。

mysql_get_server_version()：获取 MySQL 服务器的版本号。

mysql_hex_string()：将二进制数据转换为十六进制字符串。

mysql_info()：获取上一次操作的额外信息。

mysql_init()：初始化 MYSQL 结构体。

mysql_insert_id()：获取上一次插入操作生成的 AUTO_INCREMENT 值。

mysql_kill()：关闭 MySQL 服务器上指定连接的进程。

mysql_library_end()：释放 MySQL 库资源。

mysql_library_init()：初始化 MySQL 库。

mysql_list_dbs()：获取 MySQL 服务器上所有的数据库。

mysql_list_fields()：获取表中所有的字段信息。

mysql_list_processes()：获取 MySQL 服务器上的所有进程信息。

mysql_list_tables()：获取 MySQL 数据库中所有表的名称。

mysql_load_plugin()：动态加载 MySQL 插件。

mysql_local_infile_end()：停止使用本地文件作为数据源。

mysql_load_plugin()：动态加载 MySQL 插件。

mysql_local_infile_end()：停止使用本地文件作为数据源。

mysql_local_infile_init()：开启使用本地文件作为数据源。

mysql_local_infile_read()：从本地文件中读取数据。

mysql_more_results()：检查是否还有多个结果集。

mysql_next_result()：获取下一个结果集。

mysql_num_fields()：获取结果集中的字段数。

mysql_num_rows()：获取结果集中的行数。

mysql_options()：设置 MySQL 连接选项。

mysql_ping()：检查 MySQL 连接是否仍然活动。

mysql_query()：执行 MySQL 查询。

mysql_real_connect()：建立一个到 MySQL 数据库的连接。

mysql_real_escape_string()：转义字符串以在 MySQL 查询中使用。

mysql_real_query()：执行 MySQL 查询。

mysql_refresh()：刷新 MySQL 缓存。

mysql_reload()：重新加载 MySQL 配置文件。

mysql_rollback()：撤销当前 MySQL 连接上的事务。

mysql_row_seek()：将结果集的行指针移动到指定位置。

mysql_row_tell()：获取结果集当前行的位置。

mysql_select_db()：选择 MySQL 数据库。

mysql_set_character_set()：设置 MySQL 连接的字符集。

mysql_set_local_infile_default()：设置本地文件作为默认数据源。

mysql_set_local_infile_handler()：设置本地文件数据源的处理程序。

mysql_shutdown()：关闭 MySQL 服务器。

mysql_sqlstate()：获取最近一次 MySQL 操作的 SQLSTATE。

mysql_ssl_set()：设置 MySQL 连接的 SSL 配置。

mysql_stat()：获取 MySQL 服务器的状态信息。

mysql_store_result()：获取查询结果集。

mysql_thread_id()：获取当前 MySQL 连接的线程 ID。

mysql_use_result()：获取结果集。

mysql_warning_count()：获取最近一次操作的警告数目。
```

## SQL

### 1、检索数据

```sql
USE sql_store;#使用表 sql_store
SELECT first_name#从 customers 表中检索所有列
FROM customers;
# 检索多个列
SELECT DISTINCT first_name,last_name#使用 DISTINCT 避免列数据重复
FROM customers
LIMIT 5 OFFSET 5;# 只检索从第 5 行开始的 5 行
# 从 customers 表中检索所有列
SELECT *
FROM customers;
-- WHERE customer_id = 1;# 注释可以使用--
# 检索 customer_id 的那一行
# 总结:选择符合要求的列，选择符合要求的行
#SQL 语句中的注释
#使用# -- /**/
```

### 2、排序检索数据

```sql
USE sql_store;
SELECT *
FROM customers;
#使用 ORDER BY 进行排序（应该保证 ORDER BY 放在语句的最后面）
USE sql_inventory;
SELECT *
FROM products
ORDER BY quantity_in_stock;
#按照多个列进行行排序
USE sql_inventory;
SELECT *
FROM products
ORDER BY quantity_in_stock,unit_price;# 先按照 quantity_in_stock 排序再按照 unit_price 排序
#不用指定列的名字，指定是第几列
USE sql_inventory;
SELECT *
FROM products
ORDER BY 3,4;# quantity_in_stock 为第 3 行,unit_price 为第 4 行 alter
#先按照第三列排序在按照第四列排序
#指定排序的方向是升序还是降序
USE sql_inventory;
SELECT *
FROM products
ORDER BY 3 DESC;# quantity_in_stock 为第 3 行
#想为多个列进行排序指定排序方向必须为每个列指定 DESC
USE sql_inventory;
SELECT *
FROM products
ORDER BY 3 DESC,4 DESC;
#使用计算字段在 ORDER BY
SELECT *
FROM products
ORDER BY quantity_in_stock * unit_price DESC;
```

### 3、where 子句

```sql
# WHERE 子句
USE sql_inventory;
SELECT *
FROM products
WHERE unit_price = 1.21;
# WHERE 子句操作符
/* 符号 说明
= 等于
<> 不等于
 != 不等于
 < 小于
 <= 小于等于
 !< 不小于
 > 大于
 >= 大于等于
 !> 不大于
 BETWEEN A AND B 在指定的 A B 之间
IS NULL 为 NULL 值
*/
```

### 4、高级数据过滤

```sql
USE sql_inventory;
SELECT *
FROM products;
# AND 操作符
SELECT *
FROM products
WHERE product_id>=5 AND quantity_in_stock>=70;
# OR 操作符
SELECT *
FROM products
WHERE product_id>=5 OR quantity_in_stock>=70;
# AND 与 OR 组合(AND 优先级大于 OR)
SELECT *
FROM products
WHERE (product_id>=5 OR quantity_in_stock>=70) AND unit_price>=2;
# IN 操作符
SELECT *
FROM products
WHERE quantity_in_stock IN (98,26,6);
# 等价于 quantity_in_stock==98 OR ...==26 OR ...==6
# NOT 操作符
SELECT *
FROM products
WHERE NOT (quantity_in_stock IN (98,26,6));
# BETWEEN AND 操作符
SELECT *
FROM products
WHERE quantity_in_stock BETWEEN 6 AND 90;
# IS NULL | IS NOT NULL
SELECT *
FROM products
WHERE quantity_in_stock IS NOT NULL;-- 同理 IS NULL
```

### 5、使用通配符与正则表达式

```sql
USE sql_inventory;
SELECT *
FROM products
WHERE name LIKE '%b%';#使用通配符%
SELECT *
FROM products
WHERE name LIKE '_o%';#_只匹配一个字符
-- 正则表达式 REGEXP
SELECT *
FROM products
WHERE name REGEXP 'filed';-- name 中含有 filed 的数据
SELECT *
FROM products
WHERE name REGEXP '^filed';-- name 以 filed 开头的数据
SELECT *
FROM products
WHERE name REGEXP 'filed$';-- name 以 filed 结尾的数据
SELECT *
FROM products
WHERE name REGEXP 'filed|mac|rose';-- name 中含有 filed 或 mac 或 rose 的数据
SELECT *
FROM products
WHERE name REGEXP '[gio]c';-- name 中含有 gc 或 ic 或 oc 的数据,同理可以 c[iod]
SELECT *
FROM products
WHERE name REGEXP '[a-z]c';-- ac bc dc ..........zc

```

### 6、创建计算字段

```sql
# 复习上一节，使用通配符
USE sql_inventory;
6
SELECT *
FROM products
WHERE unit_price<=5 AND ( name LIKE '%t%');
#这一节学习的是创建计算字段
#拼接字段（不同地数据库管理系统中的 SQL 语句语法有所不同）
SELECT concat('name: ',name,' price: ',unit_price)
FROM products
ORDER BY unit_price DESC;
#RTRIM()、LTRIM()、TRIM()函数
#函数功能:去掉值右边的空格、去掉值左边的空格、去掉值左边和右边的空格
SELECT concat(trim(name),trim(unit_price))
FROM products;
SELECT concat(rtrim(name),rtrim(unit_price))
FROM products;
#使用别名（或者称导出列）
SELECT concat(trim(name)) AS ProductName
FROM products;
#执行算数计算
SELECT name,quantity_in_stock*unit_price AS quantity_in_stockmulunit_price
FROM products;
#SQL 算数操作符 加+ 减- 乘* 除/
SELECT curdate(),name,quantity_in_stock/unit_price AS quantity_in_stockdivunit_price
FROM products;
```

### 7、使用函数处理数据

```sql
USE sql_inventory;
SELECT *
FROM products;
# UPPER()函数-字符全部变大写
SELECT upper(name) AS UPPERNAME
FROM products;
#常用的文本处理函数
/*
LEFT() 返回字符串左边的字符
7
LENGTH() 返回字符串的长度
LOWER() 将字符串换为小写
LTRIM() 去掉字符串左边的空格
RTRIM() 去掉字符串右边的空格
RIGHT() 返回字符串右边的字符
SUBSTR() 提取字符串的组成成分
SOUNDEX() 返回字符串的 SOUNEDx 值 alter （对英文友好）
UPPER() 将字符串转换为大写
*/
# 日期与时间处理函数
# MySQL 使用 YEAR() 函数从日期中提取年份
USE sql_invoicing;
SELECT *
FROM invoices
WHERE YEAR(invoice_date) != 2019;
USE sql_invoicing;
SELECT *
FROM invoices
WHERE YEAR(invoice_date) = 2019;
#数值处理函数
/*
ABS() 返回一个数的绝对值
COS() 返回一个角度的余弦
EXP() 返回一个数的指数值
PI() 返回圆周率
SIN() 返回一个角度的正弦
SQRT() 返回一个数的平方根
TAN() 返回一个角度的正切
*/
#获得当前时间
/*
NOW()
*/
--内建函数非常多，我们遇见问题时去搜索就好了
```

### 8、汇总数据

```sql
USE sql_invoicing;
SELECT *
FROM invoices;
8
# 聚集函数
# 对某些行运行的函数，计算并返回一个值
/*
AVG() 返回某列的平均值
COUNT() 返回某列的行数
MAX() 返回某列的最大值
MIN() 返回某列的最小值
SUM() 返回某列值之和
*/
# 使用样例
SELECT
AVG(invoice_total) AS avg,
COUNT(*) AS count,
MAX(invoice_total) AS max,
MIN(invoice_total) AS min,
SUM(invoice_total) AS sum
FROM invoices
WHERE invoice_total>110;
#添加 WHERE 子句，是先执行 WHERE 条件，然后再进行 SELECT 语句里函数计算
#聚集不同值
#DISTINCT 与 ALL（ALL 是默认的）
SELECT AVG(ALL client_id) AS avg_client_id
FROM invoices;
SELECT AVG(DISTINCT client_id) AS avg_client_id
FROM invoices;
```

### 9、分组数据

```sql
#复习上一节内容（汇总数据）ＡＶＧ ＳＵＭ ＭＩＮ ＭＡＸ ＣＯＵＮT 函数的使用
USE sql_invoicing;
SELECT AVG(distinct
client_id),SUM(payment_total),MIN(payment_total),MAX(payment_total),COUNT(*)
FROM invoices;
#本节内容
SELECT COUNT(*) AS client_idCOUNT#输出 17
FROM invoices;
SELECT COUNT(*) AS client_idCOUNT#输出 6,统计 client_id=5 的行共有 6 个
FROM invoices
WHERE client_id=5;
SELECT *#输出 17
9
FROM invoices;
#创建分组 GROUP BY 子句
#GROUP BY 子句的位置必须在 WHERE 子句之后 ORDER BY 子句之前
SELECT client_id,payment_total,COUNT(*) AS num
FROM invoices
GROUP BY client_id,payment_total;
/*
num client_id
5 1 即 client_id 为 3 的行有 5 个，为 5 的有 6 个
1 2
5 3
6 5
GROUP BY 子句更像是
SELECT COUNT(*) AS num
FROM
WHERE alient_id=something
的加强版
*/
SELECT client_id,payment_total,COUNT(*) AS num
FROM invoices
GROUP BY client_id,payment_total;#像 ORDER BY 一样也可以使用数字来指定列
#将会按照 client_id、payment_total 依次分组
#HAVING 过滤分组（HAVING 放在 GROUP 之后 ORDER BY 之前）
#例如只要组内数量超过一定数量的信息
SELECT client_id,payment_total,COUNT(*) AS num
FROM invoices
GROUP BY client_id,payment_total
HAVING COUNT(*)>=2#HAVING 以组为单位进行操作：则 COUNT(*)则是统计组内有多少行
ORDER BY num,payment_total,client_id;#分组后过滤然后排序输出
/*
下列语句顺序级大致用途
SELECT 返回的列或者表达式
FROM 从中检索数据的表
WHERE 行级过滤
GROUP BY 分组过滤
HAVING 组级过滤
ORDER BY 输出排序顺序
*/
--WITH ROLLUP
10
SELECT client_id,SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;
client_id total_sales
1 802.89
2 101.79
3 705.90
5 980.02
 2590.60

-- ALL KEYWORD
SELECT *
FROM invoices
WHERE invoice_total>(
 SELECT MAX(invoice_total)
 FROM invoices
 WHERE client_id=3
);
SELECT *
FROM invoices
WHERE invoice_total>ALL(
 SELECT invoice_total
 FROM invoices
 WHERE client_id=2;
);
-- ANY
SELECT *
FROM invoices
WHERE invoice_total>ANY(
 SELECT invoice_total
 FROM invoices
 WHERE client_id=2;
);
--EXISTS
SELECT *
FROM clients c
WHERE EXISTS(
 SELECT client_id
 FROM invoices
 WHERE client_id=c.client_id
11
);
```

### 10、使用子查询

```sql
# 子查询的两种主要使用目的
# 1、利用子句查询进行过滤
# 2、作为计算字段使用子查询
USE sql_invoicing;
SELECT *
FROM invoices;
# 利用子句查询进行过滤
SELECT invoice_total
FROM invoices
WHERE invoice_total>=170;#输出列 invoice_total:[175.32 189.12 172.17 180.17]
SELECT client_id
FROM invoices
WHERE invoice_total IN (#等于将子查询返回的一列作为筛选项使用
SELECT invoice_total
FROM invoices
WHERE invoice_total>=170
);
# 输出列 client_id[ 5 1 5 5]
#注意：可以多层嵌套，每个 SELECT 可以查询不同的表
#每个子查询返回的必须是一列，是多列会报错
# 作为计算字段使用子查询
USE sakila;
SELECT COUNT(*) AS SUM
FROM film
WHERE rental_duration>=6;
/*输出列:SUM [ 32 ]*/
#统计了 rental_duration>=6 的共有多少行
SELECT film_id,title,(SELECT description FROM film WHERE film.film_id = film_text.film_id)
AS film_description
FROM film_text;
/*分析:
从表 film_text 拿 title 与 film_id 在表 film 中拿 film_text 每行的 film_id 对应的 description
*/
# IF()
SELECT
12
IF (COUNT(*)>2,'yes','no') AS u;
#CASE WHEN
SELECT
CASE WHEN COUNT(*)>100 THEN '>100'
 WHEN COUNT(*)<10 THEN '<10'
 ELSE 'NULL'
END
AS judge;
--FROM 中的子查询
SELECT *
FROM(
 SELECT client_id,name,...
 FROM ..
) AS kkk
WHERE kkk.......
```

### 11、联结表与为表起别名

```sql
#等值联结
SELECT vend_name,Vendors.prod_name,Products.prod_price
FROM Cendors,Products
WHERE Vendors.vend_id=Products.vend_id;
# 在联结两个表时，实际要做的是将表中的每一行与其他表的每一行进行配对
# 但会出现，在变的 id 有另一个没有，也就是可能会出现不能一一匹配
#内联结
SELECT vend_name,prod_name,prod_price
FROM Vendors
INNER JOIN Products ON Vendors.vend_id=Products.vend_id;-- 不写 INNER 则默认 INNER
JOIN
#联结多个表
SELECT prod_name,vend_name,prod_price,quantity
FROM OrderItems,Products,Vendors
WHERE Products.vend_id=Vendors.vend_id
AND OrderItems.prod_id=Products.prod_id
 AND order_num=20007;
#先联结，后 order_num=20007 过滤行
13
#为表起别名（只是举例）
SELECT *
FROM order_items o
JOIN products p
ON o.name = p.name;
# 跨库联结
-- 例
-- 需要在表的前面加库名 lib4.testtable 代理 lib4 库下的 testtable 表
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
ON oi.product_id=p.product_id;
#自联结
SELECT *
FROM order_items oi
JOIN order_items e
ON oi.product_id=e.product_id;-- 没有意义,应在具体情况下使用
-- 库.表.列
#联结多张表
SELECT *
FROM atable a
JOIN btable b ON a.name=b.name
JOIN ctable ON a.id=c.id;
#多条联结条件
SELECT *
FROM atable a
JOIN btable b ON a.id=b.id AND a.name=b.name;
#外联结-OUTER JOIN
# |-左联结 LEFT OUTER JOIN 可缩写为 LEFT JOIN
# |-右联结 RIGHT OUTER JOIN 可缩写为 RIGHT JOIN
#多张表 外连接 自我外联结 （自我）左外联结 （自我）右外联结 略 与内联结差不多少
#MySQL USING
SELECT *
FROM a
14
JOIN b
USING(name,id);-- 等价于 ON a.name=b.name AND a.id=b.id
#自然联结
SELECT *
FROM orders o
NATURAL JOIN customers c;
#交叉联结
SELECT *
FROM atable a
CROSS btable b;
#集合交 UNION
# MySQL 貌似不支持 intersect except(但可以使用嵌套查询)
SELECT name
FROM a
WHERE age>10;
UNION
SELECT name
FROM b
WHERE age<6;
```

### 12、创建高级表联结

```sql
USE sql_invoicing;
SELECT *
FROM clients;
SELECT *
FROM customers;
# 使用表别名
SELECT *
FROM clients AS A_TABLE,customers AS B_TABLE;
#使用不同类型的联结
#自联结(self-join)
SELECT c1.cust_id,c1.cust_name,c1.cust_contact
FROM customers AS c1,customers AS c2
15
WHERE c1.cust_name=c2.cust_name AND c2.cust_contact="Jim Jones";
#自然联结
SELECT C.cust_id,B.*
FROM customers AS C, clients AS B
WHERE C.cust_id=B.client_id+10000;
#左外联结
SELECT *
FROM customers
LEFT OUTER JOIN clients ON customers.cust_id=clients.client_id+10000;
#选中 OUTER JOIN 左边的表的全部行,哪怕没有关联行
#右外联结
SELECT *
FROM customers
RIGHT OUTER JOIN clients ON customers.cust_id=clients.client_id+10000;
#选中 OUTER JOIN 左边的表的全部行，哪怕没有关联行
#使用带聚集函数的联结
SELECT customers.cust_id,COUNT(clients.name) AS num
FROM customers
INNER JOIN clients ON customers.cust_id=clients.client_id+10000
GROUP BY customers.cust_id;
SELECT customers.cust_id,COUNT(clients.name) AS num
FROM customers
LEFT OUTER JOIN clients ON customers.cust_id=clients.client_id+10000
GROUP BY customers.cust_id;
#先联结，在分组，再 SELECT 统计计算等等
```

### 13、组合查询

```sql
USE sql_invoicing;
SELECT *
FROM clients;
# 使用 UNION ALL 不去掉重复的
SELECT *
FROM clients
WHERE clients.client_id<=3
UNION ALL
SELECT *
16
FROM clients
WHERE clients.client_id>=3;
# 使用 UNION 默认去掉重复的
SELECT *
FROM clients
WHERE clients.client_id<=3
UNION
SELECT *
FROM clients
WHERE clients.client_id>=3;
```

### 14、插入数据

```sql
USE sql_invoicing;
SELECT *
FROM clients;
# 插入完整的行
#INSERT INTO clients
#VALUES(10,"刘微","china","anyang","CN","133-456-8956");
#更规范的写法
#INSERT INTO clients(client_id,name,address,city,state,phone)
#VALUES
#(11,"刘微","china","anyang",DEFAULT,NULL),
#(13,"刘","china","anyang",DEFAULT,NULL);
#插入部分行
#只需要使用上面更规范的写法，进而可以指定哪些插入值
#插入检索出的数据
#INSERT INTO clients(client_id,name,address,city,state,phone)
#SELECT client_id,name,address,city,state,phone
#FROM clients;
#从一个表复制到另一个表
CREATE TABLE custcpoy AS SELECT * FROM clients;
SELECT *
FROM custcpoy;
```

### 15、更新和删除数据

```sql
#添加行
17
INSERT INTO clients
VALUES(6,"刘微","china","anyang","CN","133-456-8956");
USE sql_invoicing;
SELECT *
FROM clients;
#更新数据 UPDATE SET
UPDATE clients
SET name="HELLO WORLD",address="USA"
WHERE client_id>=6;
USE sql_invoicing;
SELECT *
FROM clients;
#删除行
DELETE FROM clients
WHERE client_id>=6;
USE sql_invoicing;
SELECT *
FROM clients;
USE sql_invoicing;
#删除表
DROP TABLE Orders1;
#创建表
CREATE TABLE Orders1
(
order_num INTEGER NOT NULL DEFAULT 1,
 order_date DATETIME NOT NULL,
 cust_id CHAR(10) NULL
);
#使用 DEFAULT 指定默认值
# 不允许 NULL 值的列不接受没有列值的行，换句话说，在插入或更新行时，该列必须有值
# NOT NULL,NULL（默认值为 NULL）
INSERT INTO Orders1
VALUE(1,current_date(),"HELLO");
INSERT INTO Orders1
VALUE(2,current_date(),"HELLO");
SELECT *
FROM Orders1;
#更新表
18
#为表添加新的列
ALTER TABLE Orders1
ADD name CHAR(20) NULL DEFAULT "高万禄";
SELECT *
FROM Orders1;
#为表删除列
ALTER TABLE Orders1
DROP COLUMN cust_id;
SELECT *
FROM Orders1;
#表重命名
#RENAME Orders1 TO Orders;
#新版 MySQL 已经不支持 RENAME
```

### 16、使用视图

```sql
USE sql_invoicing;
SELECT *
FROM clients;
#删除表
DROP TABLE new_table;
#创建表
CREATE TABLE new_table
(
order_num CHAR(10) NOT NULL DEFAULT 1,
 order_date CHAR(10) NOT NULL,
 cust_id CHAR(10) NULL
);
#插入行
INSERT INTO new_table
VALUE("123","ddi","HELLO");
#显示表
SELECT *
FROM new_table;
#删除视图
19
#-覆盖(或更新)视图，必须先删除它，然后再重新创建
DROP VIEW new_table_view;
#创建视图（视图是在 SQL 解析时定义的虚拟的表，视图并不存在数据库,但对视图的数据修改会同步操
作表，视图像接口减少耦合）
CREATE VIEW new_table_view AS
SELECT *
FROM new_table;
#使用视图
SELECT *
FROM new_table_view;
#用视图重新格式化检索出的数据
DROP VIEW temp_view;
CREATE VIEW temp_view AS
SELECT concat(RTRIM(order_num),RTRIM(order_date),RTRIM(cust_id)) AS data
FROM new_table;
SELECT *
FROM temp_view;
```

### 17、使用存储过程与函数

```sql
DELIMITER //
#删除存储过程
DROP procedure test;
#参数种类
#IN 输入参数：表示调用者向过程传入值（传入值可以是字面量或变量）
#OUT 输出参数：表示过程向调用者传出值(可以返回多个值)（传出值只能是变量）
#INOUT 输入输出参数：既表示调用者向过程传入值，又表示过程向调用者传出值（值只能是变量）
#创建存储过程
DELIMITER $$
create procedure test(in a integer,in b integer,OUT num INTEGER)
BEGIN
SELECT *
 FROM clients;
 set a=2*a;
 SELECT @a;#用户变量
 SELECT a+b;
 num=a+b;
END$$
20
DELIMITER ;
SET @num=0;
CALL test(1,2,@num);
SELECT @num;
#删除存储过程
DROP PROCEDURE IF EXISTS test;
#IF THEN ELSE END IF
DELIMITER $$
create procedure test(in a integer,in b integer)
BEGIN
 IF a IS NULL THEN
 SET a=2;
 ELSE
 SET b=100;
 END IF;
SELECT *
 FROM clients;
 set a=2*a;
 SELECT @a;#用户变量
 SELECT a+b;
END$$
DELIMITER ;
#删除存储过程
DROP PROCEDURE IF EXISTS test;
#使用 SIGNAL 抛出异常
BEGIN
 IF pay<=0 THEN
 SIGNAL SQLSTATE '22003'
 SET MESSAGE_TEXT='Invalid pay amount';
 END IF;
END
#变量
-- |-User or Session variables
-- |SET @num=10;set @a=20;
-- |-Local variable
-- |DECLARE risk FLOAT4 DEFAULT 0;
-- SELECT COUNT(*),SUM(invoice_total)
-- INTO @num,@a
-- FROM invoices;
#局部变量的声明一定放在存储过程的开始
#DECLARE variable_name [,variable_name...] datatype [DEFAULT value];
21
#形如 MySQL 的数据类型，如: int, float, date,varchar(length)
#DECLARE l_varchar varchar(255) DEFAULT 'This will not be padded';
#变量赋值
#SET 变量名 = 表达式值 [,variable_name = expression ...]
#用户变量有全局性，有点像全局变量
#通常以@开头
#调用存储过程
set @a=2;
call test(2,2);
#if-then-else-endif 语句
#if __ then
# todo
#else
# todo
#end if;
#case 语句
# -> case var
# -> when 0 then
# -> insert into t values(17);
# -> when 1 then
# -> insert into t values(18);
# -> else
# -> insert into t values(19);
# -> end case;
#循环语句
# -> while var<6 do
# -> insert into t values(var);
# -> set var=var+1;
# -> end while;
#do while 语句
# -> repeat
# -> insert into t values(v);
22
# -> set v=v+1;
# -> until v>=5
# -> end repeat;
#loop 循环不需要初始条件，这点和 while 循环相似，同时和 repeat 循环一样不需要结束条件,
leave 语句的意义是离开循环。
# -> LOOP_LABLE:loop
# -> insert into t values(v);
# -> set v=v+1;
# -> if v >=5 then
# -> leave LOOP_LABLE;
# -> end if;
# -> end loop;
# ITERATE 迭代
#ITERATE 通过引用复合语句的标号,来从新开始复合语句:
# -> LOOP_LABLE:loop
# -> if v=3 then
# -> set v=v+1;
# -> ITERATE LOOP_LABLE;
# -> end if;
# -> insert into t values(v);
# -> set v=v+1;
# -> if v>=5 then
# -> leave LOOP_LABLE;
# -> end if;
# -> end loop;
-- FUNCTIONS
-- 建立自己的函数：像聚集函数一样例如 MIN MAX SUM 等
-- 函数与存储过程很像，但是区别就是，函数只能返回单一的值
-- 与存储过程不同，函数不能返回有行有列的结果集
CREATE FUNCTION get_risk_factor_for_client
(
 client_id INT
)
RETURNS INTEGER
--DETERMINISTIC
READS SQL DATA
MODIFIES SQL DATA
BEGIN
23
 RETURN 1;
END
--删除函数
DROP FUNCTION IF EXISTS get_risk_factor_for_client;
#创建触发器:例
DELIMITER $$
CREATE TRIGGER payments_after_insert
 AFTER--BEFORE
 DELETE-- INSERT UPDATE
 ON payments
 FOR EACH ROW-- 加入插入了 5 行，每行都会执行，否则执行一次
BEGIN
 UPDATE invoices
 SET payment_total=payment_total+NEW.amount
 WHERE invoice_id=NEW.invoice_id;
END$$
DELIMITER ;
-- NEW:新行元组 OLD:老行元组
-- 查看触发器
SHOW TRIGGERS LIKE 'payments%';
--删除触发器
DROP TRIGGER IF EXISTS payments_after_insert;
--事件 Events
--定时执行
SHOW VARIABLES;--mysql 中的环境变量
--开启事件
SHOW VARIABLES LIKE 'event%';
--event_scheduler ON
SET GLOBAL event_scheduler=ON--OFF
#创建事件
DELIMITER $$
CREATE EVENT yearly_delete_audit_rows
ON SCHEDULE
 AT '2021-05-26'
 --EVERY 1 HOUR-- 2 DAY --2 YEAR
24
 --EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01'
DO BEGIN
 DELETE FROM payments_audit
 WHERE action_date<NOW()-INTERVAL 1 YEAR;
END $$
DELIMITER ;
-- 查看事件
SHOW EVENTS;
-- 删除事件
DROP EVENT IF EXISTS yearly_delete_audit_rows;
--修改事件
DELIMITER $$
ALTER EVENT yearly_delete_audit_rows
ON SCHEDULE
 AT '2021-05-28'
 --EVERY 1 HOUR-- 2 DAY --2 YEAR
 --EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01'
DO BEGIN
 DELETE FROM payments_audit
 WHERE action_date<NOW()-INTERVAL 1 YEAR;
END $$
DELIMITER ;
--启动事件
ALTER EVENT yearly_delete_audit_rows ENABLE;
--关闭事件
ALTER EVENT yearly_delete_audit_rows DISABLE;
```

### 18、管理事务处理

```sql
-- 原子性 一致性 隔离性 持久性
25
USE gaowanlu;
#如何利用 COMMIT 和 ROLLBACK 语句管理事务处理;
#事务(transaction)指一组 SQL 语句
#回退(rollback)指撤销指定 SQL 语句的过程
#提交(commit)指将为存储的 SQL 语句结果写入数据库表
#保留点(savepoint)指事务处理中设置的临时占位符(placeholder)
#可以对它发布退回(与回退整个事务处理不同)
#可以回退哪些语句?
/*事务处理用来管理 INSERT UPDATE DELETE 语句。不能回退 SELECT 语句（回退 SELECT 语句也没
有必要）,
也不能回退 CREATE DROP 操作，事务处理中可以使用这些操作，但进行回退时，这些操作也不撤回。
*/
#控制事务处理
START TRANSACTION;
INSERT INTO person VALUE(5,"wangming");
INSERT INTO person VALUE(6,"wangming");
ROLLBACK;#撤销 INSERT UPDATE DELETE 操作
COMMIT; #使用 COMMIT 提交事务处理结果
#使用保留点
START TRANSACTION;
INSERT INTO person VALUE(5,"wangming");
SAVEPOINT addwangming;
INSERT INTO person VALUE(6,"xiao");
ROLLBACK TO addwangming;
COMMIT;
SELECT *
FROM person;
```

### 19、并发与锁定

```sql
如果不同的事务操纵了相同的数据（同时要进行），不可能二这同时进行，谁先执行，会将其上锁，后面
的只能等待解锁，在进行操作
26
-- 并发问题:数据丢失 读脏数据 不可重复读 幻读
-- 事务隔离等级
SHOW VARIABLES LIKE 'transaction_isolation';
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- 也可以在当前的 session 或者连接中修改隔离等级;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- 也可以为所有 session 的所有事务设置全局等级
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
--未提交读取等级:可以读到另一个事务为提交 但已经改变的数据 未提交读取是最低的隔离等级
USE db;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--提交读取等级:解决读脏数据问题 只能读取提交完毕的数据 但可能得到不可重复，或者说不稳定的
读取
USE db;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--可重复读取等级
USE db;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- 幻读用 可重复读取等级 都不能解决
-- 序列化等级
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
27
-- 死锁
A 等待 B B 等待 A
当遇到死锁时一般系统会回滚事务 A 与事务 B
-- MySQL 数据类型
String \Numeric \Date and Time\Blob(二进制数据)\Spatial(存放地理数据)
-- 字符串
CHAR(X) 固定长度
VARCHAR(X) 可变长度 最大的长度是 6 万 5 千多
MUEDIUMTEXT 16MB 最多 1 千 6 百万
LONGTEXT 4GB
TINYTEXT 255 bytes
TEXT 64KB
English 1 byte 中东:2bytes 中日:3byte
-- 整数 INTEGERS
TINYINT 1b [-128,127]
UNSIGNED TINYINT [0,255]
SMALLINT 2b [-32l,32k]
MEDIUMINT 3b[-8M,8M]
INT 4b [-2B,2B]
BIGINT 8b [-9Z,9Z]
-- 小数类型 RATIONALS
DECIMAL(p,s) DECIMAL(9,2)=>1234567.89
DEC
NUMERIC
FIXED
-------------
FLOAT 4b
DOUBLE 8b
28
-- BOOLEANS 类型
BOOL
BOOLEAN
UPDATE posts
SET is_published=TRUE # or FALSE
TRUE<-->1 FALSE<-->0
-- 枚举类型
例:ENUM(1,2,3)
ENUM('a','bb','ccc')
SET(...)
-- DATE/TIME
DATA
TIME
DATETIME 8b
TIMESTAMP 4b --通常使用于 TIMESTAMP 事件戳来记录数据插入和最后修改的时间 最大 2038
YEAR
-- BLOBS 二进制数据
TINYBLOB 255b
BLOB 65KB
MEDIUMBLOB 16MB
LONGBLOB 4GB
-- JSON
JSON-- 具体使用可以进行查询
-- 建立索引成本
COST OF INDEXES
- 增加数据库的大小（它需要和表一起保存）
- 每次增删改数据时，MySQL 会自动更新索引，会影响当前操作的效率
-- 我们只需要给特别重要的查询添加索引(数据量大，但频繁检索)
-- 不要在设计表的时候就创建好索引，不要以表来创建索引、要以查询内容来创建
29
-- 在内部：索引通常是以二叉树的方式保存的
-- 创建索引
#检索时对比了多大的数据量
EXPLAIN SELECT customer_id FROM customers WHERE state='US';
CREATE INDEX idx_state ON customers(state);
EXPLAIN SELECT customer_id FROM customers WHERE state='US';
--查看索引
SHOW INDEXES IN customers;
只要给表添加了主键，引擎自动会对主键加索引、聚合索引(主键索引) clustered INDEX
ANALYZE TABLE customers;
每张表只能有一个聚合索引
其他的索引是，从属索引 secondary indexes
外码也会自动加索引
如果索引的列为 CHAR VARCHAR TEXT BLOB,索引就会占用大量的磁盘空间、并且性能表现也不好
-- 解决方案，对数据部分内容建立索引
CREATE INDEX idx_lastname ON customers (last_name(20))
--怎样挑选一个不错的值
SELECT
COUNT(DISTINCT LEFT(last_name,1)),
COUNT(DISTINCT LEFT(last_name,5)),
COUNT(DISTINCT LEFT(last_name,10))
FROM customers;
-- 全文索引 索引类型
问题
USE sql_blog;
SELECT *
FROM posts
WHERE title LIKE '%rect%' OR body LIKE '%rect%';
数据量大的时候将会非常慢
-- 创建全文索引
CREATE FULLTEXT INDEX idx_title_body ON posts(title,body);
-- 使用全文索引
SELECT *
FROM posts
30
WHERE MATCH(title,body) AGAINST('rect');
-- MATCH(title,body) AGAINST('rect -redux +form' IN BOOLEAN MODE) 含 rect 但不含
redux 含 form
-- 组合索引
EXPLAIN SELECT customer_id FROM customers
WHERE state='CA' AND points>1000;
CREATE INDEX idx_state_points ON customers(state,points);
-- 删除索引
DROP INDEX idx_state ON customers;
--组合索引的顺序问题
-- 将最常用的列放到最前面
--ＵＳＥ ＩＮＤＥＸ
ＳＥＬＥＣＴ ｃｕｓｔｏｍｅｒ＿ｉｄ
ＦＲＯＭ ｃｕｓｔｏｍｅｒｓ
ＵＳＥ ＩＮＤＥＸ（ｉｄｘ＿ｓｔａｔｅ＿ｌａｓｔｎａｍｅ）
ＷＨＥＲＥ ｓｔａｔｅ ＬＩＫＥ ＇Ａ％＇ ＡＮＤ ｌａｓｔ＿ｎａｍｅ ＬＩＫＥ ＇Ａ％＇；
--有时候这样写效率会更好
ＳＥＬＥＣＴ *
ＦＲＯＭ ｃｕｓｔｏｍｅｒｓ
ＷＨＥＲＥ ｓｔａｔｅ ＬＩＫＥ ＇Ａ％＇
UNION
ＳＥＬＥＣＴ *
ＦＲＯＭ ｃｕｓｔｏｍｅｒｓ
WHERE ｌａｓｔ＿ｎａｍｅ ＬＩＫＥ ＇Ａ％＇；
--防止建立相同的索引
(A,B,C) == (A,B,C)
(A,C,B) != (A,B,C)
--防止建立无用索引
建立了(A,B)
再建立(A) (A)为无用索引
```

### 20、账户和权限

```sql
-- 创建用户
CREATE USER `john@允许访问的 ip` IDENTIFIED BY '1232nfdb1dvfd3nhng13fdv';
-- 查看用户
SELECT * FROM mysql.user;
--删除用户
DROP USER `john@允许访问的 ip`;
--修改密码
SET PASSWORD FOR `john@允许访问的 ip`='1234frfe';
--为当前登录的用户更改密码
SET PASSWORD ='2324234';
--授予权限
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE
ON sql_store.*
TO `john@允许访问的 ip`；
--授予能够创建表\创建触发器\修改现有表
PRIVILEGES provided by mysql,summary of available PRIVILEGES
GRANT ALL
ON sql_store.* -- *.*
TO `john@允许访问的 ip`;
-- width grant option(不仅允许用户拥有这个权限，还可以将授予的权限再授予给他人)
--查看权限
SHOW GRANTS FOR `john@允许访问的 ip`;
--查看当前用户权限
SHOW GRANTS;
32
--撤销权限
REVOKE CREATE VIEW
ON sql_store.*
FROM `john@允许访问的 ip`;
1、with admin option 用于系统权限授权，with grant option 用于对象授权。
2、给一个用户授予系统权限带上 with admin option 时，此用户可把此系统权限授予其他用户或角
色，
但收回这个用户的系统权限时，这个用户已经授予其他用户或角色的此系统权限不会因传播无效，
如授予 A 系统权限 create session with admin option,然后 A 又把 create session 权限授予 B,
但管理员收回 A 的 create session 权限时，B 依然拥有 create session 的权限，
但管理员可以显式收回 B create session 的权限，即直接 revoke create session from B.
而 with grant option 用于对象授权时，被授予的用户也可把此对象权限授予其他用户或角色，
不同的是但管理员收回用 with grant option 授权的用户对象权限时，权限会因传播而失效，
如：grant select on 表名 to A with grant option;，A 用户把此权限授予 B，但管理员收回 A 的权
限时，
B 的权限也会失效，但管理员不可以直接收回 B 的 SELECT ON TABLE 权限。 执行授权语句报错
（ora-01031，ora-01929）时，可参考一下。
相同点：
- 两个都可以既可以赋予 user 权限时使用，也可以在赋予 role 时用 GRANT CREATE SESSION TO
emi WITH ADMIN OPTION;
GRANT CREATE SESSION TO role WITH ADMIN OPTION; GRANT role1 to role2 WITH
ADMIN OPTION;
 GRANT select ON customers1 TO bob WITH GRANT OPTION; GRANT select ON
customers1 TO hr_manager(role) WITH GRANT OPTION;
 - 两个受赋予者，都可以把权限或者 role 再赋予 other users - 两个 option 都可以对 DBA 和
APP ADMIN 管理带来方便性，但同时，
 都带来不安全的因素
不同点： - with admin option 只能在赋予 system privilege 的时使用 - with grant option 只
能在赋予
object privilege 的时使用
- 撤消带有 admin option 的 system privileges 时，连带的权限将保留
--加 with grant option
A->B
则 B 可->C
但 C！——》A
--REVOKE
33
REVOKE<权限>[,<权限>]...
ON <对象类型><对象名>[,<对象类型><对象名>]...
FROM <用户>[,<用户>]...[CASCADE|RESTRICT]
例:
REVOKE INSERT
ON TABLE SC
FROM U5 CASCADE;
U5->U6->U7
撤销了 U5 同时撤销了 U6 U7
--创建数据库模式的权限
CREATE USER <username> [WITH] [DBA|RESOURCE|CONNECT]
只有超级用户才可以创建一个新的数据库用户
--使用角色
CREATE ROLE <角色名>;
--给角色授予权限
GRANT <权限>,[....]
ON <对象类型>对象名
TO 角色、角色...;
-- 将角色授予其他的角色或用户
GRANT 角色、角色...
TO 角色、用户...
[WITH ADMIN OPTION]
--添加 WITH ADMIN OPTION，则获得某种权限的角色和用户还可以把这种权限授予给其他的角色;
--角色权限的收回
REVOKE 权限、权限
ON <对象类型><对象名>
FROM 角色、角色;
```

### 21、游标

```sql
1. 游标(cursor)：是一个存储在 MySQL 服务器上的数据库查询，它不是一条 select 语句，而是被该语
句检索出来的结果集。
 游标主要用于交互式应用，其中用户需要滚动屏幕上的数据，并对数据进行浏览或做出更改。
 游标只能用于存储过程和函数。
2. 使用游标的步骤：
 1) 在能够使用游标前，必须声明（定义）它。这个过程实际上没有检索数据，它只是定义要使用的
select 语句。
 2) 一旦声明后，必须打开游标以供使用。这个过程用前面定义的 select 语句把数据实际检索出来。
 3) 对于填有数据的游标，根据需要去除（检索）各行。
 4) 在结束游标使用时，必须关闭游标。
3. 在一个游标被打开后，可以使用 fetch 语句分别访问它的每一行。fetch 指定检索什么数据（所需的
列），检索出来的数据存储在什么地方。它还向前移动游标中的内部指针，使下一条 fetch 语句检索下一
行（不重复读取同一行）。
*/
DROP procedure if exists fun;#永久删除游标
DROP TABLE if exists copy;
create table copy
(
order_num INTEGER NOT NULL,
 cust_id CHAR(10) NOT NULL
);
DELIMITER //
CREATE procedure fun()
BEGIN
DECLARE num INTEGER;
 DECLARE nam_e CHAR(10);
#创建游标
declare cur cursor for SELECT * FROM person;
 open cur;#打开游标
FETCH cur INTO num,nam_e;
 INSERT INTO copy VALUE(num,nam_e);
 close cur;#关闭游标
END;//
DELIMITER ;
call fun();
SELECT *
FROM copy;
#每 fetch 一回就会向下自动迭代一行，类似于 C 语言中的文件读取。
```

### 22、高级 sql 特性

```sql
USE gaowanlu;
#创建表时添加主键
35
#CREATE TABLE data
#(
# table_id INTEGER NOT NULL PRIMARY KEY,
# user_name CHAR(50) NOT NULL,
# user_password CHAR(50) NOT NULL
#);
#修改表时定义主键
#ALTER TABLE data
#ADD CONSTRAINT PRIMARY KEY(table_id);
#翻译-constaint(约束)：管理如何插入或处理数据库数据的原则
#外键:
#是表中的一列，其值必须在另一表的主键中
#也就是 templae 表中的 data_table_id 任意都是 data 中的 table_id
#外键是保证引用完整性的及其重要部分。
#CREATE TABLE template
#(
# table_id INTEGER NOT NULL PRIMARY KEY,
# data_table_id INTEGER NOT NULL REFERENCES data(table_id)
#);
#修改表时定义外键
#ALTER TABLE template
#ADD CONSTRAINT
#FOREIGN KEY (data_table_id) REFERENCES data (table_id);
#唯一约束
#类似于表的主键，但与主键不同的是一个表可以有多个唯一约束
#CREATE TABLE template_1
#(
# id INTEGER NOT NULL PRIMARY KEY,
# name CHAR(20) NOT NULL UNIQUE
#);
#修改表时添加唯一约束
#ALTER TABLE <数据表名> ADD CONSTRAINT <唯一约束名> UNIQUE(<列名>);
#ALTER TABLE template_1
#ADD CONSTRAINT
#unique_name UNIQUE(name);
#删除唯一约束
#ALTER TABLE <表名> DROP INDEX <唯一约束名>;
36
#检查约束
#检查约束能用来保证一列(或一组列)中的数据满足一组指定的条件
# 值大小 范围(如日期) 只允许特定的值
/*
CREATE TABLE template_2
(
id INTEGER NOT NULL PRIMARY KEY,
 num INTEGER NOT NULL CHECK (num>0 AND num<100),
 str CHAR(10) NOT NULL CHECK (str LIKE '[MF]')
);
*/
#str 只包含 M 或 F
#索引
#主键总是有序的，索引就像 hash 表一样快速找到目标
#CREATE INDEX num_ind
#ON template_2(num);
#CREATE INDEX <索引名称> ON <表名>(<列名>)
#触发器
/*
*触发器是特殊的存储过程，它在特定的数据库活动发生时自动执行
*触发器可以与特定表上的 INSERT、UPDATE、DELETE 操作(或组合)相关联
*
* CREATE <触发器名> < BEFORE | AFTER >
* <INSERT | UPDATE | DELETE >
* ON <表名> FOR EACH Row<触发器主体>
*/
#BEFORE 触发器
#mysql> CREATE TRIGGER SumOfSalary
# -> BEFORE INSERT ON tb_emp8
# -> FOR EACH ROW
# -> SET @sum=@sum+NEW.salary;
#AFTER 触发器
#mysql> CREATE TRIGGER double_salary
# -> AFTER INSERT ON tb_emp6
# -> FOR EACH ROW
# -> INSERT INTO tb_emp7
# -> VALUES (NEW.id,NEW.name,deptId,2*NEW.salary);
#序列
#MySQL 序列是一组整数：1, 2, 3, ...，由于一张数据表只能有一个字段自增主键
37
#如果你想实现其他字段也实现自动增加
#使用 AUTO_INCREMENT
#创建了数据表 insect
#insect 表中的 id 无需指定值可实现自动增长
#CREATE TABLE template_3
#(
# id INT unsigned NOT NULL auto_increment,
# primary key(id),
# user_name CHAR(10) NOT NULL
#);
INSERT INTO template_3
VALUES
(NULL,"gao"),
(NULL,"zhang"),
(NULL,"li");
SELECT *
FROM template_3;
-- conceptual-》 logical-》 physical
-- 概念 逻辑 实体
 ER 关系 一张张表
-- ER 图绘制
www.draw.io
-- 1NF
没有重复的行，每条数据可以唯一确定
-- 2NF
满足 1NF
没有依赖任何关系的其他子集的非主键字段
-- 2NF 告诉我们，每张表都应该是单一功能的，换句话说，它仅能表示一个实体类型
-- 这张表的所有字段都是用来描述这个特定的实体的
ORDERS 1NF
order_id date name
1 ... hi
2 ... hi
2NF
ORDERS 1NF
order_id date customer_id
1 ... 1
1 ... 1
CUSTOMERS
customer_id name
1 hi
-- 3NF
满足 2NF
所有表中的字段都只依赖于主键与其他的字段值无关
INVOICES
... invoice_total payment_total balance
 100 40 60(100-40)
blance 依赖于 invoice_total payment_total
-- 不要设想数据库模型将来要应对的情况，一般想出来的情况都不会出现
-- 只会让我们的解决方案变得复杂
-- 只关注眼前的需求找出最佳解法
-- 而不是考虑还没发生的问题
```
