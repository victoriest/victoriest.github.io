---
layout: post
title: "VictoriEST的Clojure学习笔记 - 04"
date: 2015-11-18
description: VictoriEST的Clojure学习笔记 - 04
tags:
 - clojure
---

继续说说序列

- filter : 接受一个谓词和一个容器作为参数, 返回一个经过谓词判断为真的元素组成的序列.
```clojure
user=> (filter even? (range 50))
(0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48)
```

- take-while
```clojure
user=> (take-while even? [1 1 1 1 1 3 3 2 3 3 4 ])
()
user=> (take-while odd? [1 1 1 1 1 3 3 2 3 3 4 ])
(1 1 1 1 1 3 3)
```

- drop-while
```clojure
user=> (drop-while odd? [1 1 1 1 1 3 3 2 3 3 4 ])
(2 3 3 4)
```

- split-at, split-with 把一个容器一分为二
```clojure
user=> (split-at 5 (range 10))
[(0 1 2 3 4) (5 6 7 8 9)]
user=> (split-with #(< % 5) (range 10))
[(0 1 2 3 4) (5 6 7 8 9)]
```

- every? : 序列中所有的元素都是谓词判断为真

- some : 返回序列中其中一个谓词为真的值, 如果没有为真的值, 返回nil

- not-every?

- not-any?

- map : [f coll] 将 coll里的每个元素通过f计算得到一个新的序列
```clojure
user=> (map #(+ % 1) [1 2 3 4 5])
(2 3 4 5 6)
```

- reduce
```clojure
user=> (reduce #(+ %1 %2) [1 2 3 4 5])
15
; 等价 (+ (+ (+ (+ 1 2) 3) 4) 5)
```

- sort : 根据自然顺序排序

- sort-by : 根据给定的函数排序

- for : 可以吧map啊 filter啊 看成是for的特殊形式
```clojure
user=> (for [n (range 20)] (* n 1))
(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19)
user=> (for [n (range 20)] (+ n 1))
(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
user=> (for [n (range 20) :when (> n 10)] (+ n 1))
(12 13 14 15 16 17 18 19 20)
user=> (for [n (range 20) :while (> n 10)] (+ n 1))
()
user=> (for [n (range 20) :while (< n 10)] (+ n 1))
(1 2 3 4 5 6 7 8 9 10)
```

- 惰性序列 : 只在需要的时候才求值.
如: (def x (for [i (range 1 3)] (do (println i) i)))
调用x返回的是个惰性序列
并不会执行println
可以使用doall强制求值
(doall x)
另外, dorun也是强制求值, 但他不会吧元素保存在内存内clojure的序列函数也可以对应java的string以及容器.

- 正则 : re-matcher, re-seq
两者的区别是, 前者返回可变的序列, 后者返回不可变的

- 文件
```clojure
user=> (.. (File. ".") listFiles)
#<File[] [Ljava.io.File;@225b8d33>
user=> (seq (.. (File. ".") listFiles))
;= 这下面是列出来的文件
(map #(.. % getName) (seq (.. (File. ".") listFiles)))
;= 下面列出文件名
```

- 打开文件流
```clojure
user=> (clojure.java.io/reader "J:\\est.txt")
#<BufferedReader java.io.BufferedReader@370ff791>
```
这样会导致文件一直处于打开状态 所以 我们用with-open
```
user=> (with-open [rdr (clojure.java.io/reader "J:\\est.txt")]
  #_=> (count (let [x (line-seq rdr)] (println x) x)))
(estest estest)
2
```

- xml解析
clojure.xml/parse

- peek 和 pop
peek等同于first, pop等同于rest, 但pop一个空序列会抛出异常
对于vector, 从末尾处理元素
```clojure
user=> (def coll [1 2 3 4 5])
#'user/coll
user=> (def list-coll '(1 2 3 4 5))
#'user/list-coll
user=> (peek coll)
5
user=> (pop coll)
[1 2 3 4]
user=> (peek list-coll)
1
user=> (pop list-coll)
(2 3 4 5)
```

- 关于vector的函数
get
peek
pop
assoc
subvec
```clojure
user=> (dissoc x :c)
{:b 2, :a 1}
user=> (def v [1 2 3 4 5])
#'user/v
user=> (get v 1)
2
user=> (get v 0)
1
user=> (get v 5)
nil
user=> (assoc v 1 999)
[1 999 3 4 5]
user=> (subvec v 3)
[4 5]
user=> (subvec v 3 4)
[4]
```

- 关于map的函数
keys
vals
get
contains?
assoc
dissoc
select-keys
merge
merge-with
```clojure
user=> (def x {:a 1 :b 2 :c 3})
#'user/x
user=> (keys x)
(:c :b :a)
user=> (vals x)
(3 2 1)
user=> (get x :a)
1
user=> (get x :d)
nil
user=> (get x :d 333)
333
user=> (contains? x :d)
false
user=> (contains? x :c)
true
user=> (assoc x :d 4)
{:c 3, :b 2, :d 4, :a 1}
user=> (assoc x :d 5)
{:c 3, :b 2, :d 5, :a 1}
user=> (assoc x :d 5 :e 6)
{:e 6, :c 3, :b 2, :d 5, :a 1}
user=> (dissoc x :e)
{:c 3, :b 2, :a 1}
user=> (dissoc x :c)
{:b 2, :a 1}
user=> (select-keys x [:a :c])
{:c 3, :a 1}
user=> (merge x {:e 5 :f 6})
{:e 5, :c 3, :b 2, :f 6, :a 1}
user=> (merge x {:e 5 :f 6} {:e 5})
{:e 5, :c 3, :b 2, :f 6, :a 1}
user=> (merge-with x {:e 5 :f 6} {:e 5})
{:e 5, :f 6}
user=> (merge-with + {:e 5 :f 6} {:e 5})
{:e 10, :f 6}
```

- 关于set的函数
union
intersection
difference
select
rename
project
join
```clojure
user=> (def set-1 #{"java" "c" "r" "clojure"})
#'user/set-1
user=> (def set-2 #{"java" "php" "c#"})
#'user/set-2
user=> (use 'clojure.set)
nil
user=> (union set-1 set-2)
#{"c#" "clojure" "java" "php" "r" "c"}
user=> (difference set-1 set-2)
#{"clojure" "r" "c"}
user=> (intersection set-1 set-2)
#{"java"}
user=> (select #(= 1 (.. % length )) set-1)
#{"r" "c"}
```
