---
layout: post
title: "VictoriEST的Clojure学习笔记 - 02"
date: 2015-11-18
description: VictoriEST的Clojure学习笔记 - 02
tags:
 - clojure
excerpt_separator: <!--more-->
---

又一次重新开始继续学习clojure, 由于我的重点是clojure本身, 我是不打算折腾工具/环境的. 唯一用的就是上移篇笔记提到的leiningen的repl环境.

##### clojure的加载,引用库和代码
- 用require引入一个clojure库, 使用的话需要其全路径, 可以配合:as, :only, :include, :exclude, :refer, :all使用
```clojure
(require '(clojure.java.io))		; 引用
(clojure.java.io/file "fileName")	; 使用
(requie '[clojure.java.io :as io])	; 引入java io，并指定缩略名为io
```
- 用refer, 将函数绑定到当前的ns中, 其中可以配合:exclude, :only, :rename使用
```clojure
(refer 'clojure.java.io)
(refer 'clojure.java.io :only [file])
```
- use, 是require和refer的结合体
- import, 引入java类
```clojure
(import '(java.io File))	; 引用
(File. "fileName")			; 使用
```
- ns宏, 创建名空间, 并引入其他资源, 可以配合import,require,use进行使用
```clojure
(ns foo.bar
      (:refer-clojure :exclude [ancestors printf])
      (:require [clojure.contrib sql sql.tests])
      (:use [my.lib this that])
      (:import [java.util Date Timer Random]
        (java.sql Connection Statement)))
```
- 参考资料:[Clojure ns require use import](http://ju.outofmemory.cn/entry/143769)

<!--more-->

##### 文档, 帮助
- 查找文档 (doc 文档名), 如果不知道确切的名字, (find-doc 不确切的名字), 还有一个网站http://clojuredocs.org/
- 想看源码, (clojure.repl/source 函数名)
- 查看java的文档javadoc (javadoc java.net.URL)

##### 函数定义
- 具名函数
```clojure
(defn 函数名 函数说明文档.可选 关联到函数对象上的元数据.可选
	[参数列表] 函数体)
```
在参数列表中加&, &后的参数会放入一个序列, 并绑定到&后面的名称上.
元数据:描述代码的文档信息

- 匿名函数`(fn [params] body)`或者更简单`#(body)`参数就是%1 %2
```clojure
((fn [x] (* x x)) 3)	; 输出 9
(#(* % %) 3)			; 同上
```

##### 杂项
- 在repl中, :reload 强制重新加载一个库
- Vector [] 向量, 数组
- List () 列表, 可以只有数据, 也可以用于函数调用
- class 用于看 引用类型 `(class (/ 22 7))`
- quot 取除法的整形部分 `(quot 22 7)`
- rem 取余
- 想要得到浮点值 `(/ 22.0 7)`
- 想要得到任意精度的浮点运算`(/ 0.0000001M 10000000000000000000)` M为BigDecimal
- 同理N为BigInt
- 被称为符号(symbol)的东西: 函数, 操作符, java类, 名空间/java包, 数据结构, 引用类型
- 关键字, 以冒号开头的像符号一样的东西, 与符号的不同: 关键字会解析为他们自身, 而符号会引用某种东西.
- clojure中, 除了false和nil 都是ture

##### 约定参数名:
a - java数组
agt 代办(代理)
coll 容器
expr 表达式
f 函数
idx 索引
r 引用
v 向量
val 值

##### 与java交互
调用java方法`(. toUpperCase "hello")`, 列表中的点"."告知clojure将其视为一个java方法
创建java对象`(new classname)`
也可以用类名末尾加`.`的方式来new一个Java对象`(Date.)`
调用java方法(. 实例 方法名 参数...)
调用静态方法(. 类名 方法名 参数...)
用`/`调用静态方法`(System/currentTimeMillis)`

##### def语法
def一个map, (def my-map {"est" "qwe" "zxc" "asd"})
获取元素 (my-map "est"), 或者(get my-map "est")

##### defrecord记录类型, 很像java bean:
```clojure
(defrecord Book [title author])
(def b (->Book "book name" "victoriest"))
(Book. "book name" "victoriest")
```

##### 读取器宏
; 注释
' 阻止求值 or quote
其他还有很多........
关于变量与符号, var, 读取器宏 #'. 目前理解个大概:
```clojure
(def foo 10)
foo
;= 10
(var foo)
;= #' user/foo
#'foo
;= #' user/foo
```

##### 解构
```clojure
(let [[x _ y] [1 2 3]])
;= [1 3]
(let [[x y :as est] [1 2 3 4 5 6]])
;= [1 2 [1 2 3 4 5 6]]
```

##### 流程控制
do 会依次执行 form 并返回最后一个的值
if语句 : `(if condition (true部分) (false部分))`
when语句 : `(when condition true部分, 隐含do)`
循环结构 :
```clojure
(loop [xxx]
	(if xxx
	 true?
	 (recur exper)))
```

##### 初步接触:

- str函数 用于连接字符串
`(str 1 2 nil 3) -> "123"`

- conj
```clojure
(conj '(1 2 3 4) 5)
;= (5 1 2 3 4)
(conj [1 2 3 4] 5)
:= [1 2 3 4 5]
(conj {:a 1 :b 2 :c 3} [:d 4])
;= {:d 4, :c 3, :b 2, :a 1}
```

- interleave 混合两个字符串?  看起来没啥用
```clojure
clojure.core/interleave
([] [c1] [c1 c2] [c1 c2 & colls])
  Returns a lazy seq of the first item in each coll, then the second etc.
```
例如:
```clojure
(interleave "abc" "123")
;= (\a \1 \b \2 \c \3)
```

- apply
以第一个参数为函数, 之后的参数为参数, 计算调用

- take-nth
返回一个以原序列每隔N个元素的新序列

- 各种谓词, 是否真`true?`, 是否假`false?`, 是否空`nil?`, 是否为零`zero?`

- take
返回序列的头n个元素组成的新序列

- 递增`inc`, 递减`dec`

- reverse, 反序

- iterate
- clojure.core/iterate
```clojure
([f x])
  Returns a lazy sequence of x, (f x), (f (f x)) etc. f must be free of side-effects
```

- drop-last 返回除最后一个元素之外的序列

- range
```clojure
clojure.core/range
([] [end] [start end] [start end step])
  Returns a lazy seq of nums from start (inclusive) to end
  (exclusive), by step, where start defaults to 0, step to 1, and end to
  infinity. When step is equal to 0, returns an infinite sequence of
  start. When start is equal to end, returns empty list.
```

- rest, 返回除了第一个元素之外的其余元素

map-indexed

