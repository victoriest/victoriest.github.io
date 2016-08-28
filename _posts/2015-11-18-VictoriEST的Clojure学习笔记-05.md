---
layout: post
title: "VictoriEST的Clojure学习笔记 - 05"
date: 2015-11-18
description: VictoriEST的Clojure学习笔记 - 05
tags:
 - clojure
excerpt_separator: <!--more-->
---

函数式编程概念

- 纯函数
没有副作用的函数, 不依赖于除参数意外的任何其他东西, 对外界影响的唯一途径, 就是返回值.
副作用, 就是除了返回值之外其他影响外界的东西.

##### 用各种方法实现一个菲波那切数列
* 递归
```clojure
(defn  fibo1 [x]
(cond (= x 0) 0
	  (= x 1) 1
	  :else (+ (fibo1 (- x 2)) (fibo1 (- x 1)))
	  ))
```

* 尾递归
```clojure
(defn fibo2 [x]
	(letfn [(fibo [current next x]
			 (if zero? x)
			 	current
			 	(fibo next (+ current next) (dec x)))]
	(fibo 0N 1N x)))
```

<!--more-->

* 自递归
```clojure
(defn fibo3 [x]
	(letfn [(fibo [current next x]
			 (if zero? x)
			 	current
			 	(recur next (+ current next) (dec x)))]
	(fibo 0N 1N x)))
```

* 惰性序列
```clojure
(defn fibo4
	([]
	(concat [0 1] (fibo4 0N 1N)))
	([a b]
	(let [n (+ a b)]
		(lazy-seq
			(cons n (fibo4 b n))))))
```

* 使用序列库中的函数
```clojure
(defn fibo5 []
	(map first (iterate (fn [[a b]] [b (+ a b)]) [0N 1N] )))
```

##### 杂记

**defn-** 定义一个私有函数 只能在它的命名空间中可见

**comp** 用于组合多个函数 用自己的参数依次调用最右端的函数
```clojure
user=> ((comp #(+ % 1) #(+ % 0.1)) 1)
2.1
```

**partial** 对一个函数进行部分调用 即 柯里化
```clojure
user=> (defn plus [n] ((partial + 1 2) n))
#'user/plus
user=> (plus 3)
6
user=> (def add-3 (partial + 3))
#'user/add-3
user=> (add-3 7)
10
```

##### 互递归(mutual recursion)
```clojure
user=> (declare my-odd? my-even?)
#'user/my-even?
user=> (defn my-odd? [n]
  #_=> (if (= n 0)
  #_=> false
  #_=> (my-even? (dec n))))
#'user/my-odd?
user=> (defn my-even? [n]
  #_=> (if (= n 0)
  #_=> true
  #_=> (my-odd? (dec n))))
#'user/my-even?
user=> (map my-even? (range 10))
(true false true false true false true false true false)
```

互递归非常消耗内存 解决办法
* 自递归
```clojure
(defn parity [n]
	(loop [n n par 0]
		(if (= n 0)
		par
			(recur (dec n) (- 1 par)))))
(map parity (range 10))
-> (0 1 0 1 0 1 0 1 0 1 0 1)
(defn my-even? [n] (= 0 (parity n)))
(defn my-odd? [n] (= 1 (parity n)))
```

* Trampolining
可以优化互递归, 使其不会SOF
