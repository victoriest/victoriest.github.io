---
layout: post
title: "VictoriEST的Clojure学习笔记 - 03"
date: 2015-11-18
description: VictoriEST的Clojure学习笔记 - 03
tags:
 - clojure
excerpt_separator: <!--more-->
---

##### 序列
clojure中, 所有聚合数据结构都被称为序列. 之前也了解了一些序列的函数:

- first : 得到一个序列的第一个元素, 序列如果为空序列, 返回nil
```clojure
user=> (first '(1 2 3))
1
user=> (first #{1 2 3})
1
user=> (first [])
nil
```

- next : 得到除序列的第一个元素外组成的序列, 如果没有其他元素, 返回nil
```clojure
user=> (next [1 2 3])
(2 3)
user=> (next '(1 2 3))
(2 3)
user=> (next [])
nil
user=> (next nil)
nil
```

- last : 得到序列最后一个元素, 如果序列为空序列, 返回nil
```clojure
user=> (last [1 2 3])
3
user=> (last [])
nil
```

<!--more-->

- rest : 得到除序列的第一个元素外组成的序列, 如果没有其他元素, 返回一个空序列
```clojure
user=> (rest [1 2 3])
(2 3)
user=> (rest [])
()
```

- seq : 返回一个序列, 源自任何一个可序列化的其他容器, 包括string, java集合, 如果序列为空, 返回nil

- cons : [x coll] 返回一个新序列, 以x为头一个元素coll为剩余的. coll必须为一个序列

- sorted-set, sorted-map : 会创建一个排序好的(map按照key排序)的 set/mep

- into : [to from] 将容器里里的所有元素添加至另一个容器
```clojure
user=> (into [1 2 3] '(1 2 3))
[1 2 3 1 2 3]
user=> (into '(1 2 3) '(1 2 3))
(3 2 1 1 2 3)
; 与conj不同的是
user=> (conj [1 2 3] '(1 2 3))
[1 2 3 (1 2 3)]
```

##### 创建序列
- range : [start? end step?] 生成一个从start开始到end结束, 步长为step的序列

- repeat : [n x] 重复x元素n次
```clojure
user=> (take 10 (repeat [1 2]))
([1 2] [1 2] [1 2] [1 2] [1 2] [1 2] [1 2] [1 2] [1 2] [1 2])
user=> (take 10 (repeat 2))
(2 2 2 2 2 2 2 2 2 2)
```

- iterate : [f x] 起始于x, 持续的对每个值用f计算
```clojure
user=> (take 10 (iterate #(* % 2) 2))
(2 4 8 16 32 64 128 256 512 1024)
```

- take : 返回一个容器前n项

- cycle : 重复容器中的元素
```clojure
user=> (take 10 (cycle [1 2 3]))
(1 2 3 1 2 3 1 2 3 1)
```

- interleave
```clojure
user=> (interleave [1 2 3 4 5] [:a :b :c :d :e :f])
(1 :a 2 :b 3 :c 4 :d 5 :e)
```

- interpose : [sep coll] 将序列用sep分割
```clojure
user=> (interpose [:o 0] {:a 1 :b 2 :c 3 :d 4})
([:c 3] [:o 0] [:b 2] [:o 0] [:d 4] [:o 0] [:a 1])
(apply str (interpose "." ["victoriest" "est"])) ;同 clojure.string/join
```

- list,vector,hash-set,hash-map
```clojure
user=> (list 1 2 3 4)
(1 2 3 4)
user=> (vector 1 2 3 4)
[1 2 3 4]
user=> (hash-set 1 2 3 4)
#{1 4 3 2}
user=> (hash-map 1 2 3 4)
{1 2, 3 4}
```

- set
```clojure
user=> (set [1 2 3])
#{1 3 2}
user=> (set '(1 2 3))
#{1 3 2}
```

- vec
```clojure
user=> (vec [1 2 3] )
[1 2 3]
user=> (vec '(1 2 3) )
[1 2 3]
user=> (vec {:a 1 :b 2} )
[[:b 2] [:a 1]]
```
