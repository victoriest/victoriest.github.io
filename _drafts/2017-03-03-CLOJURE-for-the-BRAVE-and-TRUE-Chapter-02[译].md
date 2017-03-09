---
layout: post
title: CLOJURE-for-the-BRAVE-and-TRUE-Chapter-02[译]
date: 2017-03-03
description: CLOJURE-for-the-BRAVE-and-TRUE-Chapter-02[译]
tags:
 - clojure
excerpt_separator: <!--more-->
---

# 搞事情 : Clojure急速教程

是时候学着用Clojure搞些事情了! 虽然你肯定知道Clojure的并发支持和其他的一些特性很叼, 但Clojure的最突出的特性是: 它是个Lisp. 本章中, 你将探索关于Lisp的核心元素:语法, 函数和数据(syntax, functions, and data). 它们会为你使用Clojure提供坚实的基础.

在打下基础后, 你将会开始写一些超关键的代码. 本章的最后一节中, 你将运用你学到的所有知识来创建一个hobbit的模型( a model of a hobbit)并提供一个随机点击的函数. 

当读完本章后, 我建议你在REPL中实践这些示例. 学习一门新的语言就像骑车游泳一样, 你必须自己去实践. 

## 语法

Clojure的语法很简单. 像所有其他的Lisp方言一样, 它们有统一的结构, 少量的特殊操作符, 以及无尽的圆括号...

### Forms

所有的Clojure代码由两种结构组成:

* 数据(numbers, strings, maps, and vectors)
* 操作符

我们使用术语**form**来指代有效的代码. 有时, 我们也使用**expression**来引用**form**. Clojure会计算(**evaluates **)每个**form**的值. 以下是一些有效**form**的例子:

```clojure
1
"a string"
["a" "vector" "of" "strings"]
```

你的代码很少会单独出现类似于上面的数据, 因为, 它们单独存在是并不能有什么作用. 所以, 你需要使用操作符(operations). **Operations**告诉你具体搞什么事情. 所有操作有以下形式:

```clojure
(operator operand1 operand2 ... operandn)
```

需注意的是, operator之间是没有逗号的, Clojure使用空格来隔开它们, 并且会把逗号视为空格. 示例如下:

```clojure
(+ 1 2 3)
; => 6

(str "It was the panda " "in the library " "with a dust buster")
; => "It was the panda in the library with a dust buster"
```

第一个form, 将运算符`+`会依次对运算数`1`, `2`, `3`做加法运算. 第二个form, 函数`str`拼接三个字符串构成新字符串. 它们都是有效的form. 下面的这个不是一个有效的form, 因为它没有右括号：

```clojure
(+
```

Clojure的语法结构可能让你有点不适. 其他的语言里, 不同的操作符的操作数可能不相同. 比如如下的js代码, 用中缀记法来表达`+`, 用`.`和圆括号来表达函数调用:

```js
1 + 2 + 3
"It was the panda ".concat("in the library ", "with a dust buster")
```

Clojure的语法结构非常简单且统一, 不管什么操作, 它的结构都是统一的. 

### 控制流

我们先从3个基本的控制流操作符开始 : `if`, `do`, `when`. 

#### if

下面是一个`if`表达式的基本结构:

```clojure
(if boolean-form
  then-form
  optional-else-form)
```

一个**boolean-form**是一个只会返回`true`或`false`的form. 下一节里你会学到关于真值和假值的知识. 下面是几个关于`if`的例子:

```clojure
(if true
  "By Zeus's hammer!"
  "By Aquaman's trident!")
; => "By Zeus's hammer!"

(if false
  "By Zeus's hammer!"
  "By Aquaman's trident!")
; => "By Aquaman's trident!"
```
第一个例子会返回`"By Zeus's hammer!"`, 因为boolean-form的计算结果是`true`; 第二个例子则相反, boolean-form的计算结果是`false`, 所以它返回`"By Aquaman's trident!"`.

你可以忽略`else`语句分支, 但如果boolean-form的计算结果是`false`, 则会返回`nil`. 像这样:

```clojure
(if false
  "By Odin's Elbow!")
; => nil
```

需要注意与大多数语言不通的是, **then-form**和**else-form**分别只能有一个表达式(form). 比如在ruby中你可以这样写:

```ruby
if true
  doer.do_thing(1)
  doer.do_thing(2)
else
  other_doer.do_thing(1)
  other_doer.do_thing(2)
end
```
但在Clojure中, 想要`if`分支或者`else`分支中有多个表达式的话, 则需要运算符`do`.

#### do

运算符`do`允许你执行括号内的多个form:

```clojure
(if true
  (do (println "Success!")
      "By Zeus's hammer!")
  (do (println "Failure!")
      "By Aquaman's trident!"))
; => Success!
; => "By Zeus's hammer!"
```

#### when

`when`就像`if`和`do`的组合, 但是它没有else分支, 例:

```clojure
(when true
  (println "Success!")
  "abra cadabra")
; => Success!
; => "abra cadabra"
```

如果`when`判断结果为`false`, 则表达式返回`nil`. 

#### nil, true, false, Truthiness, Equality, and Boolean Expressions

Clojure中 真值, 假值, 空值分别以`true`,`false`,`nil`表示. 可用使用函数`nil?`判断一个值是否为空:

```clojure
(nil? 1)
; => false

(nil? nil)
; => true
```

逻辑计算中, `nil`和`false`都为假, 其他值为真. 例:

```clojure
(if "bears eat beets"
  "bears beets Battlestar Galactica")
; => "bears beets Battlestar Galactica"

(if nil
  "This won't be the result because nil is falsey"
  "nil is falsey")
; => "nil is falsey"
```

Clojure中表达式是否相等的比较运算符用`=`表示:

```clojure
(= 1 1)
; => true

(= nil nil)
; => true

(= 1 2)
; => false
```

一些其他的语言可能会使用不同的比较运算符来对应不同的数据结构, 比如可能使用特定的比较函数来比较字符串. 但在Clojure中, 你不必担心这个问题, clojure的内建数据结构都会使用同一的比较运算符. 

Clojure提供运算符`or`, `and`; `or`返回form中第一个真值或最后一个值; `and`返回第一个假值或最后一个值:

```clojure
(or false nil :large_I_mean_venti :why_cant_I_just_say_large)
; => :large_I_mean_venti

(or (= 0 1) (= "yes" "no"))
; => false

(or nil)
; => nil

(and :free_wifi :hot_coffee)
; => :hot_coffee

(and :feelin_super_cool nil false)
; => nil
```

#### 用`def`给value起名字

```clojure
(def failed-protagonist-names
  ["Larry Potter" "Doreen the Explorer" "The Incredible Bulk"])

failed-protagonist-names
; => ["Larry Potter" "Doreen the Explorer" "The Incredible Bulk"]
```

上例中, 我们给一个含有3个字符串的vector绑定到名称`failed-protagonist-names`上. (vector后面会讲到)

注意, 我们使用术语**绑定**(bind), 在其他语言中被称为赋值给一个变量, 因为通常在其他语言里变量可以多次赋值的. (译者: 不变性, 是函数式语言的主要特点之一)

在ruby中, 你可以为一个变量多次赋值:

```ruby
severity = :mild
error_message = "OH GOD! IT'S A DISASTER! WE'RE "
if severity == :mild
  error_message = error_message + "MILDLY INCONVENIENCED!"
else
  error_message = error_message + "DOOOOOOOMED!"
end
```
你可以在Clojure中做类似的事情:

```clojure
(def severity :mild)
(def error-message "OH GOD! IT'S A DISASTER! WE'RE ")
(if (= severity :mild)
  (def error-message (str error-message "MILDLY INCONVENIENCED!"))
  (def error-message (str error-message "DOOOOOOOMED!")))
```

更改一个名称所关联的值, 会使程序的变得难以理解. 虽然Clojure提供了一系列的工具来处理类似于变量的东西, 但随着你深入学习, 你会发现你很少需要改变一个名字所代表的的值. 这里提供一个上例中比较好的解决方法:

```clojure
(defn error-message
  [severity]
  (str "OH GOD! IT'S A DISASTER! WE'RE "
       (if (= severity :mild)
         "MILDLY INCONVENIENCED!"
         "DOOOOOOOMED!")))

(error-message :mild)
; => "OH GOD! IT'S A DISASTER! WE'RE MILDLY INCONVENIENCED!"
```

这里, 我们创建了一个名为`error-message`的函数, 它接受单个参数`severity`, 并用这个参数判断返回哪个字符串. 后面你会学到如何创建一个函数, 这里你需要知道`def`是用来定义常量的. 接下来的几章里, 你会学到如何利用函数式编程的特性来取代变量. 

### 数据结构

Clojure提供了几个最常用的数据结构. 如果你有过面向对象编程语言的背景, 你会惊讶于这些看似简单的结构能够做如此多的事情. 

所有的Clojure的数据结构都是不可变的, 下面是个ruby的例子, 它修改数组下表为0的元素的值:

```ruby
failed_protagonist_names = [
  "Larry Potter",
  "Doreen the Explorer",
  "The Incredible Bulk"
]
failed_protagonist_names[0] = "Gary Potter"

failed_protagonist_names
# => [
#   "Gary Potter",
#   "Doreen the Explorer",
#   "The Incredible Bulk"
# ]
```

Clojure中没有等效的表达, 你会在第10章中知道在clojure中如何实现上述功能. 

#### 数字

Clojure对数字有复杂的支持, 我们不会花时间在它的技术系节里, 因为这会影响我们"搞事情". 如果你对这些细节感兴趣, 看看文档<http://clojure.org/data_structures#Data%20Structures-Numbers>. 所以你只要知道Clojure会给你正确的结果就够了. 比如下面, 整数, 浮点数, 以及比率:

```clojure
93
1.2
1/5
```

#### 字符串

字符串你懂的, 这个名字来自古老的腓尼基人; 下面是几个例子:

```clojure
"Lord Voldemort"
"\"He who must not be named\""
"\"Great cow of Moscow!\" - Hermes Conrad"
```

Clojure值允许使用双引号来代表字符串. 如`'Lord Voldemort'`并不是一个合法的字符串. 而且Clojure中没有插入字符串的方法, 只有拼接字符串的方法`str`:

```clojure
(def name "Chewbacca")
(str "\"Uggllglglglglglglglll\" - " name)
; => "Uggllglglglglglglglll" - Chewbacca
```

#### Maps

Maps类似于其他语言的字典(dictionaries)或哈希(hashes). 他是关联两个值的方式之一. Clojure有两种Map : hash map和sorted map. 下面是个空的map:

```clojure
{}
```

下例中,  `:first-name` and `:last-name` 是关键字:

```clojure
{:first-name "Charlie"
 :last-name "McFishwich"}
 ```

我们可以将`"string-key"`和运算符`+`关联起来:

```clojure
{"string-key" +}
```

Map可以嵌套:

```clojure
{:name {:first "John" :middle "Jacob" :last "Jingleheimerschmidt"}}
```
map的值中可以是任何类型(strings, numbers, maps, vectors, even functions). 

除了使用`{}`, 你还可以用`hash-map`函数来创建一个map:

```clojure
(hash-map :a 1 :b 2)
; => {:a 1 :b 2}
```

用`get`方法在map中获取一个元素的值:

```clojure
(get {:a 0 :b 1} :b)
; => 1

(get {:a 0 :b {:c "ho hum"}} :b)
; => {:c "ho hum"}
```

如果没有指定的键`get`方法返回`nil`, 或者你可以指定一个默认值 如下例中的`"unicorns?"`:

```clojure
(get {:a 0 :b 1} :c)
; => nil

(get {:a 0 :b 1} :c "unicorns?")
; => "unicorns?"
```

`get-in`函数可以获取嵌套Map的值:

```clojure
(get-in {:a 0 :b {:c "ho hum"}} [:b :c])
; => "ho hum"
```

下面是另一种从Map取值的方式:

```clojure
({:name "The Human Coffeepot"} :name)
; => "The Human Coffeepot"
```

你可以使用关键字作为函数来查找他们的值. 

#### 关键字

如你所见关键字就是看起来如下这样. 它主要用作为key在map中:

```clojure
:a
:rumplestiltsken
:34
:_?
```

关键字可以作为查找数据结构中对应的值的函数. 如下例, `a`可以查找map中的值:

```clojure
(:a {:a 1 :b 2 :c 3})
; => 1
```

等效于:

```clojure
(get {:a 1 :b 2 :c 3} :a)
; => 1
```

像使用`get`一样, 你可以给一个默认值, 当它找不到相应键的时候会返回默认值:

```clojure
(:d {:a 1 :b 2 :c 3} "No gnome knows homes like Noah knows")
; => "No gnome knows homes like Noah knows"
```

把关键字当做函数在Clojure开发者中非常常见, 你也应该加入他们. 

#### Vectors

vector非常像数组, 下标从0开始. 如下例:

```clojure
[3 2 1]
```

我们返回vector中下标0的元素可以用`get`:

```clojure
(get [3 2 1] 0)
; => 3
```

另外的一些例子:

```clojure
(get ["a" {:name "Pugsley Winterbottom"} "c"] 1)
; => {:name "Pugsley Winterbottom"}
```
vector中的元素可以是任何类型, 并且不同的类型可以混到一个vector里. 并且我们同样使用`get`函数来查找数组中的元素. 

使用`vector`函数来创建一个vector:

```clojure
(vector "creepy" "full" "moon")
; => ["creepy" "full" "moon"]
```

使用`conj`函数来向vector中添加元素到vector的末尾: 

```clojure
(conj [1 2 3] 4)
; => [1 2 3 4]
```

除了vector, list也是Clojure用来储存序列的数据结构.

#### Lists

list与vector类似. 但也有不同. 比如, 你不用使用`get`方法获取list的中的元素. 在一对圆括号前加上`'`, 他就是个list了:

```clojure
'(1 2 3 4)
; => (1 2 3 4)
```

REPL中, list的输出不包含`'`. 这个第七章的时候讲. 如果你想获取list中的某个元素, 可以使用`nth`函数:

```clojure
(nth '(:a :b :c) 0)
; => :a

(nth '(:a :b :c) 2)
; => :c
```

在你熟悉一门语言之前, 我是不会去谈论一些性能细节的, 没必要. 但你最好知道, 从一个vector中使用`get`获取元素要比list中使用'nth'获取元素速度要快一些. 因为list需要遍历n个元素, 而vector只需要获取下标的索引.

list的元素可以是任何类型, 使用`list`函数可以创建一个list:

```clojure
(list 1 "two" {3 4})
; => (1 "two" {3 4})
```

用`conj`添加元素到list中, 会添加到list的头, 而不是尾:

```clojure
(conj '(1 2 3) 4)
; => (4 1 2 3)
```

那么, 什么时候改使用list而什么是偶使用vector呢? 如果你需要方便的将元素添加到一个序列的开头, 或者你正在编写一个宏, 你需要的是list. 其他情况, 则用vector. 随着学习的深入, 你自然而然就知道该用啥了. 

#### Sets

set是一种序列对象, 序列中每个值都是唯一的, 不重复. 有两种set: hash set 和 sorted set. 先来关注下我们最常用的hash set:

```clojure
#{"kurt vonnegut" 20 :icicle}
```

同样, 使用`hash-set`也可以来创建一个set:

```clojure
(hash-set 1 1 2 2)
; => #{1 2}
```

set中的值是唯一的, 所以上例中, 只有一个`1`和一个`2`. 如果你添加重复的元素, 会忽略重复的元素:

```clojure
(conj #{:a :b} :b)
; => #{:a :b}
```

你可以通过`set`函数从已有的vector或list创建一个set:

```clojure
(set [3 3 3 4 4])
; => #{3 4}
```

使用`contains?`函数判断一个元素是否在集合中存在:

```clojure
(contains? #{:a :b} :a)
; => true

(contains? #{:a :b} 3)
; => false

(contains? #{nil} nil)
; => true
```

set使用关键字的例子:

```clojure
(:a #{:a :b})
; => :a
```

使用`get`的例子:

```clojure
(get #{:a :b} :a)
; => :a

(get #{:a nil} nil)
; => nil

(get #{:a :b} "kurt vonnegut")
; => nil
```

注意，使用`get`来查看set是否包含nil将总是返回nil，这是令人困惑的. `contains?`可能是更好的选择.

#### Simplicity

你可能注意到了迄今为止讲到的的所有数据类型中, 没有提到关于如何创建一个新类型或者class. 因为, Clojure世界中会鼓励你去优先使用内建对象. 

如果你之前是有OO背景的开发者, 你可能觉得很怪. 然而, 数据和数据类型的分离可是使其更加方便和易懂. 下面的话正代表了CLojure的哲学:

```
It is better to have 100 functions operate on one data structure than 10 functions on 10 data structures.
—Alan Perlis
```
你会慢慢的了解到更多的Clojure的哲学. 现在你知道了, 使用基本的数据结构可以使你的代码变得可重用. 

到此为止就是所有的Clojure的数据结构了. 接下来该学着如何使用它们了. 

### Functions

许多人坚持使用Lisp语系语言的原因之一, 就是它的主要构件模块function很简单, 但却能建立复杂的程序. 本节会介绍关于lisp函数的如下方面:

* 调用函数
* 函数与宏(macros)和特殊表单(special forms)的区别
* 定义函数
* 匿名函数
* 返回一个函数

#### Calling Functions

迄今为止我们已经看过不少函数调用的示例了:

```clojure
(+ 1 2 3 4)
(* 1 2 3 4)
(first [1 2 3 4])
```

记住所有的Clojure命令都有相同的语法:`(operator operands1 ...)`. 函数的调用只是把**operator**换成了函数, 或者函数表达式(返回值是一个函数的表达式). 

这让我们可以写一些非常有意思的代码. 如下是个返回`+`函数的一个函数表达式(function expresssion):

```clojure
(or + -)
; => #<core$_PLUS_ clojure.core$_PLUS_@76dace31>
```

这个返回值是`+`函数的字符串形式的描述. 你还可以使用这个表达式作为另一个表达式的运算符:

```clojure
((or + -) 1 2 3)
; => 6
```

`(or + -)` 返回 `+`, 所以这个表达式的结果是把 `1`, `2`, `3`相加, 返回6. 

下面是一些其他的合法调用:

```clojure
((and (= 1 1) +) 1 2 3)
; => 6

((first [+ 0]) 1 2 3)
; => 6
```

数字和字符串不能作为函数, 以下是些非法示例:

```clojure
(1 2 3 4)
("test" 1 2 3)
```

如果你在REPL中执行它们, 会返回类似于这样的东西:

ClassCastException java.lang.String cannot be cast to clojure.lang.IFn
```clojure
user/eval728 (NO_SOURCE_FILE:1)
```

你在今后可能会经常看到类似的提示: <x> cannot be cast to clojure.lang.IFn, 意思就是你把一个不是函数的东西当做函数来用了.


函数的灵活性并不仅仅只是函数表达式! 在语法意义上，函数可以将任何表达式作为参数 - 包括其他函数. 可以将函数作为参数或返回函数这样的函数被称为高阶函数(higher-order functions). 具有高阶函数的编程语言被称为first-class functions, 这些语言可以用与操作数字和vector一样的方式去操作函数. 

`map`函数(别与数据结构map搞混了)会分别对集合内的每个对象求值并返回一根新的list. 如下例, 对vector里的每个元素+1:

```clojure
(inc 1.1)
; => 2.1

(map inc [0 1 2 3])
; => (1 2 3 4)
```

注意及时你参数传入一个vector, `map`也不会返回一个vector, 细节将在第4章里讲到. 

Clojure将函数作为一等公民, 这为clojure带来在相较其他语言里更强大的抽象能力. Those unfamiliar with this kind of programming think of functions as allowing you to generalize operations over data instances. For example, the `+` function abstracts addition over any specific numbers.

By contrast, Clojure (and all Lisps) allows you to create functions that generalize over processes. `map` allows you to generalize the process of transforming a collection by applying a function—any function—over any collection.

另外有个细节, Clojure的函数调用会递归的计算每个函数参数内表达式的值:

```clojure
(+ (inc 199) (/ 100 (- 7 2)))
(+ 200 (/ 100 (- 7 2))) ; evaluated "(inc 199)"
(+ 200 (/ 100 5)) ; evaluated (- 7 2)
(+ 200 20) ; evaluated (/ 100 5)
220 ; final evaluation
```
函数调用启动了计算, 并且会计算每个子表达式的值. 

#### Function Calls, Macro Calls, and Special Forms

上一节里, 你了解了函数调用以及将函数表达式作为操作符的形式的函数调用. 另外两种表达式为宏调用和特殊form. 其实你已经见过了一些特殊form: 定义 和 `if`表达式. 

第7章中, 你会学习所有关于宏调用和特殊form的知识. 而特殊form相较于函数调用的最主要的特殊之处在于, **特殊form并不总是计算所有的子表达式**. 

用`if`作为例子, 他的一般形式是这样的:

```clojure
(if boolean-form
  then-form
  optional-else-form)
```

假如你写了一个如下的`if`语句:

```clojure
(if good-mood
  (tweet walking-on-sunshine-lyrics)
  (tweet mopey-country-song-lyrics))
```

显然, 这个`if`表达式中我们希望Clojure只计算两个选择分支中的一个分支的内容. 如果Clojure执行所有的两个分支, 关注你Twitter人会懵逼. 

另一个特殊form的特征: 不能将他们作为函数的参数. 通常, 特殊form实现了函数不能实现的Clojure的核心功能. (译者: 下面又是对Clojure的惊叹, 不翻译了)

宏与特殊form类似, 不能作为函数参数传入. 

#### Defining Functions

函数定义有5部分:

* defn关键字
* 函数名
* 描述函数的文档字符串（可选）
* 参数列表
* 函数体

下面是个函数定义以及调用这个函数的例子:

```clojure
➊ (defn too-enthusiastic
➋   "Return a cheer that might be a bit too enthusiastic"
➌   [name]
➍   (str "OH. MY. GOD! " name " YOU ARE MOST DEFINITELY LIKE THE BEST "
  "MAN SLASH WOMAN EVER I LOVE YOU AND WE SHOULD RUN AWAY SOMEWHERE"))

(too-enthusiastic "Zelda")
; => "OH. MY. GOD! Zelda YOU ARE MOST DEFINITELY LIKE THE BEST MAN SLASH WOMAN EVER I LOVE YOU AND WE SHOULD RUN AWAY SOMEWHERE"
```
第➊行, `too-enthusiastic`是这个函数的名字, ➋是函数的描述文档. ➌是函数的参数列表, ➍为函数体. 下面我们深入到每个部分看一下. 

#### 描述函数的文档

描述文档是以一个给你的函数添加文档的好方法, 在REPL里 使用`doc`函数来查看某个函数的描述文档. 比如`(doc map)`, 可以查看函数`map`的文档. 

#### Parameters and Arity

Clojure函数可以定义零到多个参数, 参数的可以是任意的数据类型的. 下面是些例子:

```clojure
(defn no-params
  []
  "I take no parameters!")
(defn one-param
  [x]
  (str "I take one parameter: " x))
(defn two-params
  [x y]
  (str "Two parameters! That's nothing! Pah! I will smoosh them "
  "together to spite you! " x y))
  ```

Functions also support arity overloading. This means that you can define a function so a different function body will run depending on the arity. Here’s the general form of a multiple-arity function definition. Notice that each arity definition is enclosed in parentheses and has an argument list:

函数支持参数重载, 意味着你可以根据参数数量不同定义不同的函数实现. 如下例:

```clojure
(defn multi-arity
  ;; 3-arity arguments and body
  ([first-arg second-arg third-arg]
     (do-things first-arg second-arg third-arg))
  ;; 2-arity arguments and body
  ([first-arg second-arg]
     (do-things first-arg second-arg))
  ;; 1-arity arguments and body
  ([first-arg]
     (do-things first-arg)))
     ```


参数重载是一种为参数提供默认值的方法. 如下例, "karate"是参数`chop-type`的默认值:

```clojure
(defn x-chop
  "Describe the kind of chop you're inflicting on someone"
  ([name chop-type]
     (str "I " chop-type " chop " name "! Take that!"))
  ([name]
     (x-chop name "karate")))
     ```

如果你传入两个参数, 函数就会忽略默认值"karate":

```clojure
(x-chop "Kanye West" "slap")
; => "I slap chop Kanye West! Take that!"

```

如果你只传入一个参数:

```clojure
(x-chop "Kanye East")
; => "I karate chop Kanye East! Take that!"
```

你也可以让每个参数重载的函数体做完全不一样的事情:

```clojure
(defn weird-arity
  ([]
     "Destiny dressed you this morning, my friend, and now Fear is
     trying to pull off your pants. If you give up, if you give in,
     you're gonna end up naked with Fear just standing there laughing
     at your dangling unmentionables! - the Tick")
  ([number]
     (inc number)))
     ```

Clojure also allows you to define variable-arity functions by including a rest parameter, as in “put the rest of these arguments in a list with the following name.” The rest parameter is indicated by an ampersand (&), as shown at ➊:


```clojure
(defn codger-communication
  [whippersnapper]
  (str "Get off my lawn, " whippersnapper "!!!"))

(defn codger
➊   [& whippersnappers]
  (map codger-communication whippersnappers))

(codger "Billy" "Anne-Marie" "The Incredible Bulk")
; => ("Get off my lawn, Billy!!!"
      "Get off my lawn, Anne-Marie!!!"
      "Get off my lawn, The Incredible Bulk!!!")
      ```

As you can see, when you provide arguments to variable-arity functions, the arguments are treated as a list. You can mix rest parameters with normal parameters, but the rest parameter has to come last:

```clojure
(defn favorite-things
  [name & things]
  (str "Hi, " name ", here are my favorite things: "
       (clojure.string/join ", " things)))

(favorite-things "Doreen" "gum" "shoes" "kara-te")
; => "Hi, Doreen, here are my favorite things: gum, shoes, kara-te"
```

Finally, Clojure has a more sophisticated way of defining parameters, called destructuring, which deserves its own subsection.

#### Destructuring

The basic idea behind destructuring is that it lets you concisely bind names to values within a collection. Let’s look at a basic example:

```clojure
;; Return the first element of a collection
(defn my-first
  [[first-thing]] ; Notice that first-thing is within a vector
  first-thing)

(my-first ["oven" "bike" "war-axe"])
; => "oven"
```

Here, the `my-first` function associates the symbol `first-thing` with the first element of the vector that was passed in as an argument. You tell `my-first` to do this by placing the symbol `first-thing` within a vector.

That vector is like a huge sign held up to Clojure that says, “Hey! This function is going to receive a list or a vector as an argument. Make my life easier by taking apart the argument’s structure for me and associating meaningful names with different parts of the argument!” When destructuring a vector or list, you can name as many elements as you want and also use rest parameters:

```clojure
(defn chooser
  [[first-choice second-choice & unimportant-choices]]
  (println (str "Your first choice is: " first-choice))
  (println (str "Your second choice is: " second-choice))
  (println (str "We're ignoring the rest of your choices. "
                "Here they are in case you need to cry over them: "
                (clojure.string/join ", " unimportant-choices))))

(chooser ["Marmalade", "Handsome Jack", "Pigpen", "Aquaman"])
; => Your first choice is: Marmalade
; => Your second choice is: Handsome Jack
; => We're ignoring the rest of your choices. Here they are in case \
     you need to cry over them: Pigpen, Aquaman
     ```

Here, the rest parameter `unimportant-choices` handles any number of additional choices from the user after the first and second.

You can also destructure maps. In the same way that you tell Clojure to destructure a vector or list by providing a vector as a parameter, you destructure maps by providing a map as a parameter:

```clojure
(defn announce-treasure-location
➊   [{lat :lat lng :lng}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))

(announce-treasure-location {:lat 28.22 :lng 81.33})
; => Treasure lat: 100
; => Treasure lng: 50
```

Let’s look at the line at ➊ in more detail. This is like telling Clojure, “Yo! Clojure! Do me a flava and associate the name lat with the value corresponding to the key `:lat`. Do the same thing with `lng` and `:lng`, okay?”

We often want to just break keywords out of a map, so there’s a shorter syntax for that. This has the same result as the previous example:

```clojure
(defn announce-treasure-location
  [{:keys [lat lng]}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))
  ```

You can retain access to the original map argument by using the `:as` keyword. In the following example, the original map is accessed with `treasure-location`:

```clojure
(defn receive-treasure-location
  [{:keys [lat lng] :as treasure-location}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng))

  ;; One would assume that this would put in new coordinates for your ship
  (steer-ship! treasure-location))
  ```

In general, you can think of destructuring as instructing Clojure on how to associate names with values in a list, map, set, or vector. Now, on to the part of the function that actually does something: the function body!

#### Function Body

The function body can contain forms of any kind. Clojure automatically returns the last form evaluated. This function body contains just three forms, and when you call the function, it spits out the last form, `"joe"`:

```clojure
(defn illustrative-function
  []
  (+ 1 304)
  30
  "joe")

(illustrative-function)
; => "joe"
```

Here’s another function body, which uses an `if` expression:

```clojure
(defn number-comment
  [x]
  (if (> x 6)
    "Oh my gosh! What a big number!"
    "That number's OK, I guess"))

(number-comment 5)
; => "That number's OK, I guess"

(number-comment 7)
; => "Oh my gosh! What a big number!"
```

#### All Functions Are Created Equal

One final note: Clojure has no privileged functions. `+` is just a function, `-` is just a function, and `inc` and `map` are just functions. They’re no better than the functions you define yourself. So don’t let them give you any lip!

More important, this fact helps demonstrate Clojure’s underlying simplicity. In a way, Clojure is very dumb. When you make a function call, Clojure just says, “map? Sure, whatever! I’ll just apply this and move on.” It doesn’t care what the function is or where it came from; it treats all functions the same. At its core, Clojure doesn’t give two burger flips about addition, multiplication, or mapping. It just cares about applying functions.

As you continue to program with Clojure, you’ll see that this simplicity is ideal. You don’t have to worry about special rules or syntax for working with different functions. They all work the same!

#### Anonymous Functions

In Clojure, functions don’t need to have names. In fact, you’ll use anonymous functions all the time. How mysterious! You create anonymous functions in two ways. The first is to use the `fn` form:

```clojure
(fn [param-list]
  function body)
  ```

Looks a lot like defn, doesn’t it? Let’s try a couple of examples:

```clojure
(map (fn [name] (str "Hi, " name))
     ["Darth Vader" "Mr. Magoo"])
; => ("Hi, Darth Vader" "Hi, Mr. Magoo")

((fn [x] (* x 3)) 8)
; => 24
```

You can treat fn nearly identically to the way you treat defn. The parameter lists and function bodies work exactly the same. You can use argument destructuring, rest parameters, and so on. You could even associate your anonymous function with a name, which shouldn’t come as a surprise (if that does come as a surprise, then . . . Surprise!):

```clojure
(def my-special-multiplier (fn [x] (* x 3)))
(my-special-multiplier 12)
; => 36
```

Clojure also offers another, more compact way to create anonymous functions. Here’s what an anonymous function looks like:

```clojure
#(* % 3)
```

Whoa, that looks weird. Go ahead and apply that weird-looking function:

```clojure
(#(* % 3) 8)
; => 24
```

Here’s an example of passing an anonymous function as an argument to map:

```clojure
(map #(str "Hi, " %)
     ["Darth Vader" "Mr. Magoo"])
; => ("Hi, Darth Vader" "Hi, Mr. Magoo")
```

This strange-looking style of writing anonymous functions is made possible by a feature called reader macros. You’ll learn all about those in Chapter 7. Right now, it’s okay to learn how to use just these anonymous functions.

You can see that this syntax is definitely more compact, but it’s also a little odd. Let’s break it down. This kind of anonymous function looks a lot like a function call, except that it’s preceded by a hash mark, `#`:

```clojure
;; Function call
(* 8 3)

;; Anonymous function
#(* % 3)
```

This similarity allows you to more quickly see what will happen when this anonymous function is applied. “Oh,” you can say to yourself, “this is going to multiply its argument by three.”

As you may have guessed by now, the percent sign, `%`, indicates the argument passed to the function. If your anonymous function takes multiple arguments, you can distinguish them like this: %1, %2, %3, and so on. % is equivalent to %1:

```clojure
(#(str %1 " and " %2) "cornbread" "butter beans")
; => "cornbread and butter beans"
```

You can also pass a rest parameter with `%&`:

```clojure
(#(identity %&) 1 "blarg" :yip)
; => (1 "blarg" :yip)
```

In this case, you applied the identity function to the rest argument. Identity returns the argument it’s given without altering it. Rest arguments are stored as lists, so the function application returns a list of all the arguments.

If you need to write a simple anonymous function, using this style is best because it’s visually compact. On the other hand, it can easily become unreadable if you’re writing a longer, more complex function. If that’s the case, use `fn`.

#### Returning Functions

By now you’ve seen that functions can return other functions. The returned functions are closures, which means that they can access all the variables that were in scope when the function was created. Here’s a standard example:

```clojure
(defn inc-maker
  "Create a custom incrementor"
  [inc-by]
  #(+ % inc-by))

(def inc3 (inc-maker 3))

(inc3 7)
; => 10
```

Here, `inc-by` is in scope, so the returned function has access to it even when the returned function is used outside `inc-maker`.

### Pulling It All Together

Okay! It's time to use your newfound knowledge for a noble purpose: smacking around hobbits! To hit a hobbit, you’ll first model its body parts. Each body part will include its relative size to indicate how likely it is that that part will be hit. To avoid repetition, the hobbit model will include only entries for left foot, left ear, and so on. Therefore, you’ll need a function to fully symmetrize the model, creating right foot, right ear, and so forth. Finally, you’ll create a function that iterates over the body parts and randomly chooses the one hit. Along the way, you’ll learn about a few new Clojure tools: `let` expressions, loops, and regular expressions. Fun!

#### The Shire’s Next Top Model

For our hobbit model, we’ll eschew such hobbit characteristics as joviality and mischievousness and focus only on the hobbit’s tiny body. Here’s the hobbit model:

```clojure
(def asym-hobbit-body-parts [{:name "head" :size 3}
                             {:name "left-eye" :size 1}
                             {:name "left-ear" :size 1}
                             {:name "mouth" :size 1}
                             {:name "nose" :size 1}
                             {:name "neck" :size 2}
                             {:name "left-shoulder" :size 3}
                             {:name "left-upper-arm" :size 3}
                             {:name "chest" :size 10}
                             {:name "back" :size 10}
                             {:name "left-forearm" :size 3}
                             {:name "abdomen" :size 6}
                             {:name "left-kidney" :size 1}
                             {:name "left-hand" :size 2}
                             {:name "left-knee" :size 2}
                             {:name "left-thigh" :size 4}
                             {:name "left-lower-leg" :size 3}
                             {:name "left-achilles" :size 1}
                             {:name "left-foot" :size 2}])
```

This is a vector of maps. Each map has the name of the body part and relative size of the body part. (I know that only anime characters have eyes one-third the size of their head, but just go with it, okay?)

Conspicuously missing is the hobbit’s right side. Let’s fix that. Listing 3-1 is the most complex code you’ve seen so far, and it introduces some new ideas. But don’t worry, because we’ll examine it in great detail.

```clojure
(defn matching-part
  [part]
  {:name (clojure.string/replace (:name part) #"^left-" "right-")
   :size (:size part)})

(defn symmetrize-body-parts
  "Expects a seq of maps that have a :name and :size"
  [asym-body-parts]
  (loop [remaining-asym-parts asym-body-parts
         final-body-parts []]
    (if (empty? remaining-asym-parts)
      final-body-parts
      (let [[part & remaining] remaining-asym-parts]
        (recur remaining
               (into final-body-parts
                     (set [part (matching-part part)])))))))
                     ```
3-1. The matching-part and symmetrize-body-parts functions

When we call the function `symmetrize-body-parts` on `asym-hobbit-body-parts`, we get a fully symmetrical hobbit:

```clojure
(symmetrize-body-parts asym-hobbit-body-parts)
; => [{:name "head", :size 3}
      {:name "left-eye", :size 1}
      {:name "right-eye", :size 1}
      {:name "left-ear", :size 1}
      {:name "right-ear", :size 1}
      {:name "mouth", :size 1}
      {:name "nose", :size 1}
      {:name "neck", :size 2}
      {:name "left-shoulder", :size 3}
      {:name "right-shoulder", :size 3}
      {:name "left-upper-arm", :size 3}
      {:name "right-upper-arm", :size 3}
      {:name "chest", :size 10}
      {:name "back", :size 10}
      {:name "left-forearm", :size 3}
      {:name "right-forearm", :size 3}
      {:name "abdomen", :size 6}
      {:name "left-kidney", :size 1}
      {:name "right-kidney", :size 1}
      {:name "left-hand", :size 2}
      {:name "right-hand", :size 2}
      {:name "left-knee", :size 2}
      {:name "right-knee", :size 2}
      {:name "left-thigh", :size 4}
      {:name "right-thigh", :size 4}
      {:name "left-lower-leg", :size 3}
      {:name "right-lower-leg", :size 3}
      {:name "left-achilles", :size 1}
      {:name "right-achilles", :size 1}
      {:name "left-foot", :size 2}
      {:name "right-foot", :size 2}]
      ```

Let’s break down this code!

#### let

In the mass of craziness in Listing 3-1, you can see a form of the structure `(let ...)`. Let’s build up an understanding of `let` one example at a time, and then examine the full example from the program once we’re familiar with all the pieces.

`let` binds names to values. You can think of `let` as short for let it be, which is also a beautiful Beatles song about programming. Here’s an example:

```clojure
(let [x 3]
  x)
; => 3

(def dalmatian-list
  ["Pongo" "Perdita" "Puppy 1" "Puppy 2"])
(let [dalmatians (take 2 dalmatian-list)]
  dalmatians)
; => ("Pongo" "Perdita")
```

In the first example, you bind the name x to the value 3. In the second, you bind the name dalmatians to the result of the expression (take 2 dalmatian-list), which was the list ("Pongo" "Perdita"). let also introduces a new scope:

```clojure
(def x 0)
(let [x 1] x)
; => 1
```

Here, you first bind the name x to the value 0 using def. Then, let creates a new scope in which the name x is bound to the value 1. I think of scope as the context for what something refers to. For example, in the phrase “please clean up these butts,” butts means something different depending on whether you’re working in a maternity ward or on the custodial staff of a cigarette manufacturers convention. In this code snippet, you’re saying, “I want x to be 0 in the global context, but within the context of this let expression, it should be 1.”

You can reference existing bindings in your let binding:

```clojure
(def x 0)
(let [x (inc x)] x)
; => 1
```

In this example, the x in (inc x) refers to the binding created by (def x 0). The resulting value is 1, which is then bound to the name x within a new scope created by let. Within the confines of the let form, x refers to 1, not 0.

You can also use rest parameters in let, just like you can in functions:

```clojure
(let [[pongo & dalmatians] dalmatian-list]
  [pongo dalmatians])
; => ["Pongo" ("Perdita" "Puppy 1" "Puppy 2")]
```

Notice that the value of a let form is the last form in its body that is evaluated. let forms follow all the destructuring rules introduced in “Calling Functions” on page 48. In this case, [pongo & dalmatians] destructured dalmatian-list, binding the string "Pongo" to the name pongo and the list of the rest of the dalmatians to dalmatians. The vector [pongo dalmatians] is the last expression in let, so it’s the value of the let form.

let forms have two main uses. First, they provide clarity by allowing you to name things. Second, they allow you to evaluate an expression only once and reuse the result. This is especially important when you need to reuse the result of an expensive function call, like a network API call. It’s also important when the expression has side effects.

Let’s have another look at the let form in our symmetrizing function so we can understand exactly what’s going on:

```clojure
(let [[part & remaining] remaining-asym-parts]
  (recur remaining
         (into final-body-parts
               (set [part (matching-part part)]))))    
               ```

This code tells Clojure, “Create a new scope. Within it, associate part with the first element of remaining-asym-parts. Associate remaining with the rest of the elements in remaining-asym-parts.”

As for the body of the let expression, you’ll learn about the meaning of recur in the next section. The function call

```clojure
(into final-body-parts
  (set [part (matching-part part)]))
  ```

first tells Clojure, “Use the set function to create a set consisting of part and its matching part. Then use the function into to add the elements of that set to the vector final-body-parts.” You create a set here to ensure you’re adding unique elements to final-body-parts because part and (matching-part part) are sometimes the same thing, as you’ll see in the upcoming section on regular expressions. Here’s a simplified example:

```clojure
(into [] (set [:a :a]))
; => [:a]
```

First, (set [:a :a]) returns the set #{:a}, because sets don’t contain duplicate elements. Then (into [] #{:a}) returns the vector [:a].

Back to let: notice that part is used multiple times in the body of the let. If we used the original expressions instead of using the names part and remaining, it would be a mess! Here’s an example:

```clojure
(recur (rest remaining-asym-parts)
       (into final-body-parts
             (set [(first remaining-asym-parts) (matching-part (first remaining-asym-parts))])))
             ```

So, let is a handy way to introduce local names for values, which helps simplify the code.

#### loop

In our symmetrize-body-parts function we use loop, which provides another way to do recursion in Clojure. Let’s look at a simple example:

```clojure
(loop [iteration 0]
  (println (str "Iteration " iteration))
  (if (> iteration 3)
    (println "Goodbye!")
    (recur (inc iteration))))
; => Iteration 0
; => Iteration 1
; => Iteration 2
; => Iteration 3
; => Iteration 4
; => Goodbye!
```

The first line, loop [iteration 0], begins the loop and introduces a binding with an initial value. On the first pass through the loop, iteration has a value of 0. Next, it prints a short message. Then, it checks the value of iteration. If the value is greater than 3, it’s time to say Goodbye. Otherwise, we recur. It’s as if loop creates an anonymous function with a parameter named iteration, and recur allows you to call the function from within itself, passing the argument (inc iteration).

You could in fact accomplish the same thing by just using a normal function definition:

```clojure
(defn recursive-printer
  ([]
     (recursive-printer 0))
  ([iteration]
     (println iteration)
     (if (> iteration 3)
       (println "Goodbye!")
       (recursive-printer (inc iteration)))))
(recursive-printer)
; => Iteration 0
; => Iteration 1
; => Iteration 2
; => Iteration 3
; => Iteration 4
; => Goodbye!
```

But as you can see, this is a bit more verbose. Also, loop has much better performance. In our symmetrizing function, we’ll use loop to go through each element in the asymmetrical list of body parts.

#### Regular Expressions

Regular expressions are tools for performing pattern matching on text. The literal notation for a regular expression is to place the expression in quotes after a hash mark:

```clojure
#"regular-expression"
```

In the function matching-part in Listing 3-1, clojure.string/replace uses the regular expression #"^left-" to match strings starting with "left-" in order to replace "left-" with "right-". The carat, ^, is how the regular expression signals that it will match the text "left-" only if it’s at the beginning of the string, which ensures that something like "cleft-chin" won’t match. You can test this with re-find, which checks whether a string matches the pattern described by a regular expression, returning the matched text or nil if there is no match:

```clojure
(re-find #"^left-" "left-eye")
; => "left-"

(re-find #"^left-" "cleft-chin")
; => nil

(re-find #"^left-" "wongleblart")
; => nil
```

Here are a couple of examples of matching-part using a regex to replace "left-" with "right-":

```clojure
(defn matching-part
  [part]
  {:name (clojure.string/replace (:name part) #"^left-" "right-")
   :size (:size part)})
(matching-part {:name "left-eye" :size 1})
; => {:name "right-eye" :size 1}]

(matching-part {:name "head" :size 3})
; => {:name "head" :size 3}]
```

Notice that the name "head" is returned as is.

#### Symmetrizer

Now let’s go back to the full symmetrizer and analyze it in more detail:

```clojure
(def asym-hobbit-body-parts [{:name "head" :size 3}
                             {:name "left-eye" :size 1}
                             {:name "left-ear" :size 1}
                             {:name "mouth" :size 1}
                             {:name "nose" :size 1}
                             {:name "neck" :size 2}
                             {:name "left-shoulder" :size 3}
                             {:name "left-upper-arm" :size 3}
                             {:name "chest" :size 10}
                             {:name "back" :size 10}
                             {:name "left-forearm" :size 3}
                             {:name "abdomen" :size 6}
                             {:name "left-kidney" :size 1}
                             {:name "left-hand" :size 2}
                             {:name "left-knee" :size 2}
                             {:name "left-thigh" :size 4}
                             {:name "left-lower-leg" :size 3}
                             {:name "left-achilles" :size 1}
                             {:name "left-foot" :size 2}])


(defn matching-part
  [part]
  {:name (clojure.string/replace (:name part) #"^left-" "right-")
   :size (:size part)})

➊ (defn symmetrize-body-parts
  "Expects a seq of maps that have a :name and :size"
  [asym-body-parts]
➋   (loop [remaining-asym-parts asym-body-parts 
         final-body-parts []]
➌     (if (empty? remaining-asym-parts) 
      final-body-parts
➍       (let [[part & remaining] remaining-asym-parts] 
➎         (recur remaining 
               (into final-body-parts
                     (set [part (matching-part part)]))
                    ```

The symmetrize-body-parts function (starting at ➊) employs a general strategy that is common in functional programming. Given a sequence (in this case, a vector of body parts and their sizes), the function continuously splits the sequence into a head and a tail. Then it processes the head, adds it to some result, and uses recursion to continue the process with the tail.

We begin looping over the body parts at ➋. The tail of the sequence will be bound to remaining-asym-parts. Initially, it’s bound to the full sequence passed to the function: asym-body-parts. We also create a result sequence, final-body-parts; its initial value is an empty vector.

If remaining-asym-parts is empty at ➌, that means we’ve processed the entire sequence and can return the result, final-body-parts. Otherwise, at ➍ we split the list into a head, part, and tail, remaining.

At ➎, we recur with remaining, a list that gets shorter by one element on each iteration of the loop, and the (into) expression, which builds our vector of symmetrized body parts.

If you’re new to this kind of programming, this code might take some time to puzzle out. Stick with it! Once you understand what’s happening, you’ll feel like a million bucks!

#### Better Symmetrizer with reduce

The pattern of process each element in a sequence and build a result is so common that there’s a built-in function for it called reduce. Here’s a simple example:

```clojure
;; sum with reduce
(reduce + [1 2 3 4])
; => 10
```

This is like telling Clojure to do this:

```clojure
(+ (+ (+ 1 2) 3) 4)
```

The reduce function works according to the following steps:

Apply the given function to the first two elements of a sequence. That’s where (+ 1 2) comes from.
Apply the given function to the result and the next element of the sequence. In this case, the result of step 1 is 3, and the next element of the sequence is 3 as well. So the final result is (+ 3 3).
Repeat step 2 for every remaining element in the sequence.
reduce also takes an optional initial value. The initial value here is 15:

```clojure
(reduce + 15 [1 2 3 4])
```

If you provide an initial value, reduce starts by applying the given function to the initial value and the first element of the sequence rather than the first two elements of the sequence.

One detail to note is that, in these examples, reduce takes a collection of elements, [1 2 3 4], and returns a single number. Although programmers often use reduce this way, you can also use reduce to return an even larger collection than the one you started with, as we’re trying to do with symmetrize-body-parts. reduce abstracts the task “process a collection and build a result,” which is agnostic about the type of result returned. To further understand how reduce works, here’s one way that you could implement it:

```clojure
(defn my-reduce
  ([f initial coll]
   (loop [result initial
          remaining coll]
     (if (empty? remaining)
       result
       (recur (f result (first remaining)) (rest remaining)))))
  ([f [head & tail]]
   (my-reduce f head tail)))
   ```

We could reimplement our symmetrizer as follows:

```clojure
(defn better-symmetrize-body-parts
  "Expects a seq of maps that have a :name and :size"
  [asym-body-parts]
  (reduce (fn [final-body-parts part]
            (into final-body-parts (set [part (matching-part part)])))
          []
          asym-body-parts))
          ```

Groovy! One immediately obvious advantage of using reduce is that you write less code overall. The anonymous function you pass to reduce focuses only on processing an element and building a result. The reason is that reduce handles the lower-level machinery of keeping track of which elements have been processed and deciding whether to return a final result or to recur.

Using reduce is also more expressive. If readers of your code encounter loop, they won’t be sure exactly what the loop is doing without reading all of the code. But if they see reduce, they’ll immediately know that the purpose of the code is to process the elements of a collection to build a result.

Finally, by abstracting the reduce process into a function that takes another function as an argument, your program becomes more composable. You can pass the reduce function as an argument to other functions, for example. You could also create a more generic version of symmetrize-body-parts, say, expand-body-parts. This could take an expander function in addition to a list of body parts and would let you model more than just hobbits. For example, you could have a spider expander that could multiply the numbers of eyes and legs. I’ll leave it up to you to write that because I am evil.

#### Hobbit Violence

My word, this is truly Clojure for the Brave and True! To put the capstone on your work, here’s a function that determines which part of a hobbit is hit:

```clojure
(defn hit
  [asym-body-parts]
  (let [sym-parts (➊better-symmetrize-body-parts asym-body-parts)
        ➋body-part-size-sum (reduce + (map :size sym-parts))
        target (rand body-part-size-sum)]
    ➌(loop [[part & remaining] sym-parts
           accumulated-size (:size part)]
      (if (> accumulated-size target)
        part
        (recur remaining (+ accumulated-size (:size (first remaining))))))))
        ```

hit works by taking a vector of asymmetrical body parts, symmetrizing it at ➊, and then summing the sizes of the parts at ➋. Once we sum the sizes, it’s like each number from 1 through body-part-size-sum corresponds to a body part; 1 might correspond to the left eye, and 2, 3, 4 might correspond to the head. This makes it so when you hit a body part (by choosing a random number in this range), the likelihood that a particular body part is hit will depend on the size of the body part.

[image]

Figure 3-1: Body parts correspond to ranges of numbers and get hit if the target falls within that range.
Finally, one of these numbers is randomly chosen, and then we use loop at ➌ to find and return the body part that corresponds to the number. The loop does this by keeping track of the accumulated sizes of parts that we’ve checked and checking whether the accumulated size is greater than the target. I visualize this process as lining up the body parts with a row of numbered slots. After I line up a body part, I ask myself, “Have I reached the target yet?” If I have, that means the body part I just lined up was the one hit. Otherwise, I just keep lining up those parts.

For example, say that your list of parts is head, left eye, and left hand, like in Figure 3-1. After taking the first part, the head, the accumulated size is 3. The body part is hit when the accumulated sizes exceeds the target, so if the target is less than 3, then the head was hit. Otherwise, you take the next part, the left eye, and increase the accumulated size to 4, yielding a hit if the target is greater than or equal to 3 and less than 4. Similarly, the left hand gets hit if the target is greater than or equal to 4 and less than 6.

Here are some sample runs of the hit function:

```clojure
(hit asym-hobbit-body-parts)
; => {:name "right-upper-arm", :size 3}

(hit asym-hobbit-body-parts)
; => {:name "chest", :size 10}

(hit asym-hobbit-body-parts)
; => {:name "left-eye", :size 1}
```

Oh my god, that poor hobbit! You monster!

## Summary

This chapter gave you a whirlwind tour of how to do stuff in Clojure. You now know how to represent information using strings, numbers, maps, keywords, vectors, lists, and sets, and how to name these representations with def and let. You’ve learned about how flexible functions are and how to create your own functions. Also, you’ve been introduced to Clojure’s philosophy of simplicity, including its uniform syntax and its emphasis on using large libraries of functions on primitive data types.

Chapter 4 will take you through a detailed examination of Clojure’s core functions, and Chapter 5 explains the functional programming mind-set. This chapter has shown you how to write Clojure code—the next two will show you how to write Clojure well.

At this point I recommend, with every fiber of my being, that you start writing code. There is no better way to solidify your Clojure knowledge. The Clojure Cheat Sheet (http://clojure.org/api/cheatsheet) is a great reference that lists all the built-in functions that operate on the data structures covered in this chapter.

The following exercises will really tickle your brain. If you’d like to test your new skills even more, try some Project Euler challenges at http://www.projecteuler.net/. You could also check out 4Clojure (http://www.4clojure.com/problems/), an online set of Clojure problems designed to test your knowledge. Just write something!

## Exercises

These exercises are meant to be a fun way to test your Clojure knowledge and to learn more Clojure functions. The first three can be completed using only the information presented in this chapter, but the last three will require you to use functions that haven’t been covered so far. Tackle the last three if you’re really itching to write more code and explore Clojure’s standard library. If you find the exercises too difficult, revisit them after reading Chapters 4 and 5—you’ll find them much easier.

1. Use the str, vector, list, hash-map, and hash-set functions.
2. Write a function that takes a number and adds 100 to it.
3. Write a function, dec-maker, that works exactly like the function inc-maker except with subtraction:
```clojure
(def dec9 (dec-maker 9))
(dec9 10)
; => 1
```

4. Write a function, mapset, that works like map except the return value is a set:
```clojure
(mapset inc [1 1 2 2])
; => #{2 3}
```

5. Create a function that’s similar to symmetrize-body-parts except that it has to work with weird space aliens with radial symmetry. Instead of two eyes, arms, legs, and so on, they have five.
6. Create a function that generalizes symmetrize-body-parts and the function you created in Exercise 5. The new function should take a collection of body parts and the number of matching body parts to add. If you’re completely new to Lisp languages and functional programming, it probably won’t be obvious how to do this. If you get stuck, just move on to the next chapter and revisit the problem later.## 译后文

本文原文链接:<http://www.braveclojure.com/do-things/>
学习Clojure的计划已经失败了太多次了, 这次又要挑战一回. 突然萌生出, 找本好的不枯燥的入门读物来翻译一下的想法, 边学边翻译. 希望这次能坚持下去. 23333...

作者的网站:<http://www.braveclojure.com/>

<!--more-->
