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

<!--more-->

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

Clojure也可以定义一个不定参数的函数. 不定参数列表之前以`&`标注, 如下例➊处:

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

如你所见, 不定参数会表现为list形式. 普通参数与不定参数都存在的参数列表中, 不定参数必须最后:

```clojure
(defn favorite-things
  [name & things]
  (str "Hi, " name ", here are my favorite things: "
       (clojure.string/join ", " things)))

(favorite-things "Doreen" "gum" "shoes" "kara-te")
; => "Hi, Doreen, here are my favorite things: gum, shoes, kara-te"
```

Clojure还有一种更加复杂的参数定义方法, 称为解构(destructuring). 

#### Destructuring

解构的基本意图是给一个集合中的多个元素绑定名称. 

```clojure
;; Return the first element of a collection
(defn my-first
  [[first-thing]] ; Notice that first-thing is within a vector
  first-thing)

(my-first ["oven" "bike" "war-axe"])
; => "oven"
```
`my-first`函数中的`first-thing`与传入的vector中的第一个元素绑定. 

那个向量就像一个巨大的标志，对Clojure说: "嘿! 此函数将接收列表或向量作为参数. 通过拆开我的参数结构, 并将有意义的名称与参数的不同部分相关联, 使我的生活更容易! "当解构矢量或列表时, 可以命名任意多的元素, 并使用rest参数(以下为机翻):

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

上例中, 不定参数`unimportant-choices`用来处理剩下的vector中除了前两个元素的其余元素.

你还可以解构map:

```clojure
(defn announce-treasure-location
➊   [{lat :lat lng :lng}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))

(announce-treasure-location {:lat 28.22 :lng 81.33})
; => Treasure lat: 28.22
; => Treasure lng: 81.33
```

看看➊行. `lat`为map中`:lat`所代表的值, `lng`为map中`:lng`所代表的值.

通常我们只是想在map中获取值忽略键, 所以下面是简化的写法:

```clojure
(defn announce-treasure-location
  [{:keys [lat lng]}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))
```

你可以使用`:as`关键字来保留经过解构后的map的原本的数据:

```clojure
(defn receive-treasure-location
  [{:keys [lat lng] :as treasure-location}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng))

  ;; One would assume that this would put in new coordinates for your ship
  (steer-ship! treasure-location))
```

#### 函数体

函数体是可以包含任何form的, 并且返回最后一个form的计算结果. 如下例:

```clojure
(defn illustrative-function
  []
  (+ 1 304)
  30
  "joe")

(illustrative-function)
; => "joe"
```

下面是另外一个使用`if`的例子:

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

#### 所有函数都是平等的

最后, Clojure没有特殊的的函数. `+`是个函数, `-`是个函数, `inc`和`map`也都是只是个函数. 与你所定义的函数是一样的. 

这也佐证了Clojure的简单性. 某种程度上, Clojure很蠢, 当你调用一个函数, Clojure只会认为"map? 我才不管呢, 我只是继续执行它而已."  所以你不必担心有没有特殊的函数, 它的规则会不会与其他函数不同.  在Clojure里, 他们都用相同的方式工作. 

#### 匿名函数

Clojure中, 可以不给函数命名. 这样的函数称为匿名函数. 创建一个匿名函数有两种途径, 其中之一为使用`fn`:

```clojure
(fn [param-list]
  function body)
```

看起来很像`defn`, 再看看其他的下面的例子:

```clojure
(map (fn [name] (str "Hi, " name))
     ["Darth Vader" "Mr. Magoo"])
; => ("Hi, Darth Vader" "Hi, Mr. Magoo")

((fn [x] (* x 3)) 8)
; => 24
```

你使用`fn`的方式几乎和`defn`相同. 参数列表, 函数体的工作方式近乎相同, 也可以使用解构, 和不定参数. 你甚至可以为你的匿名函数起个名字!

```clojure
(def my-special-multiplier (fn [x] (* x 3)))
(my-special-multiplier 12)
; => 36
```

Clojure提供另一种更加简洁的方式定义一个匿名函数. 如下:

```clojure
#(* % 3)

(#(* % 3) 8)
; => 24
```

这里有一个将匿名函数作为参数传递给map的例子:

```clojure
(map #(str "Hi, " %)
     ["Darth Vader" "Mr. Magoo"])
; => ("Hi, Darth Vader" "Hi, Mr. Magoo")
```

这种奇怪的编写匿名函数的风格是通过一个名为reader macros的功能实现的. 你将学习第7章中的所有内容. 现在, 可以学习如何使用这些匿名函数. 

你可以看到, 这种语法肯定更紧凑, 但它也有点奇怪. 它看起来很像一个函数调用, 除了开头的`#`外:

```clojure
;; Function call
(* 8 3)

;; Anonymous function
#(* % 3)
```

这样的结构可以使匿名函数可以更清晰的解析出匿名函数. `%`是表示传递给函数的参数. 如果有多个参数需要传递, 则可以这样:%1, %2, %3

```clojure
(#(str %1 " and " %2) "cornbread" "butter beans")
; => "cornbread and butter beans"
```

等效于`%&`:

```clojure
(#(identity %&) 1 "blarg" :yip)
; => (1 "blarg" :yip)
```

在这种情况下, identity函数使用了不定参数列表. Identity返回它给出的参数而不改变它. Rest参数存储为列表, 因此函数应用程序返回所有参数的列表. 

如果你需要写一个简单的匿名函数, 使用这种风格是最好的, 因为它在视觉上紧凑. 另一方面, 如果你正在写一个更长, 更复杂的函数, 它很容易变得不可读. 如果是这样, 请使用fn

#### Returning Functions

到目前为止, 你已经看到函数可以返回其他函数. 返回的函数是闭包, 这意味着它们可以访问创建函数时在作用域中的所有变量.

```clojure
(defn inc-maker
  "Create a custom incrementor"
  [inc-by]
  #(+ % inc-by))

(def inc3 (inc-maker 3))

(inc3 7)
; => 10
```

### Pulling It All Together

现在可以利用新所学的知识实现一些功能了: 做一个打地鼠的游戏(原文为打霍比特人! 我不知道霍比特人招谁惹谁了). 首先, 你需要创建一个模型用来描述地鼠的身体的各个部分. 每个身体部位包含了部位大小以及被击中的可能性等参数. 为了尽可能的重用, 地鼠的模型将仅包含左脚, 左耳等属性. 所以, 你需要一个函数来创建右脚, 右耳等属性. 最后, 你还需要创建一个函数, 它会遍历身体的每个部分并随机选择一个并hit it. 此外, 你将学习一些新的Clojure知识点: `let`表达式, 循环以及正则表达式. 

#### The Shire’s Next Top Model

下面就是我们的地鼠的模型(霍比特人!):

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
                             {:name "left-forearm" :size 3}d
                             {:name "abdomen" :size 6}
                             {:name "left-kidney" :size 1}
                             {:name "left-hand" :size 2}
                             {:name "left-knee" :size 2}
                             {:name "left-thigh" :size 4}
                             {:name "left-lower-leg" :size 3}
                             {:name "left-achilles" :size 1}
                             {:name "left-foot" :size 2}])
```

这是包含map的数组(vector). 每个map有关于身体部位的描述以及其大小. 

我们只定义了身体的左边部分, 而忽略了右边的(如右眼, 右耳之类的), 我们来完成它. 下面这段代码是你迄今为止见过的最复杂的, 并且引入了一些新的概念. 让我们一句一句的看看:

```clojure
;; 3-1. The matching-part and symmetrize-body-parts functions
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
当我们调用函数`symmetrize-body-parts`并把`asym-hobbit-body-parts`作为参数传入后, 我们就会获得一个完整的(包含左右躯体的)地鼠对象:

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

我们开始啃代码:

#### let

在上面的代码中你会发现有一个以关键字let开始的表单, 我们先举个例子弄懂这个let, 再去管上面代码的其他的部分.

`let`是将值绑定到一个名字的方法, 如:

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

在第一个例子中, 我们将值`3`绑定到`x`上. 第二个例子, 将会把`(take 2 dalmatian-list)`的计算结果作为值绑定到`dalmatians`上. 来看看let的作用域:

```clojure
(def x 0)
(let [x 1] x)
; => 1
```

首先, 我们使用`def`将`x`绑定值为`0`. 接着, 使用`let`绑定值为`1`(在一个新的作用域里). 所谓作用域, 类似于上下文的名称含义. For example, 在短语"please clean up these butts", "butts" 这个词, 在你身处一个产科病房和在香烟库房的时候意义是不同的. 这段代码中, `x`在全局的值为`0`, 在let表达式内的值为`1`. (译者: 其实罗里吧嗦就是个局部变量的概念)

你可以将一个已有的绑定名称应用到新的绑定中:

```clojure
(def x 0)
(let [x (inc x)] x)
; => 1
```

本例中, `(inc x)`中的`x`是指的`(def x 0)`中定义的`x`. 所以计算结果为1. 在`let`的作用域内 `x`的值为1而不是0.

`let`中, 一样可以使用后不定参数:

```clojure
(let [[pongo & dalmatians] dalmatian-list]
  [pongo dalmatians])
; => ["Pongo" ("Perdita" "Puppy 1" "Puppy 2")]
```
注意, `let`form的值是最后一个被计算的表达式的值. let form 遵从所有的解构规则. 本例中, [pongo & dalmatians] 是 `dalmatian-list`的解构, 将"Pongo"绑定到`pongo`上,`dalmatian-list`其他值绑定到`dalmatians`上. 因为`[pongo dalmatians]`是`let`的最后一个表达式, 所以let form的值就是`[pongo dalmatians]`.

let forms have two main uses. First, they provide clarity by allowing you to name things. Second, they allow you to evaluate an expression only once and reuse the result. This is especially important when you need to reuse the result of an expensive function call, like a network API call. It’s also important when the expression has side effects.

来看看代码3-1中的`let`form到底起到什么作用:

```clojure
(let [[part & remaining] remaining-asym-parts]
  (recur remaining
         (into final-body-parts
               (set [part (matching-part part)]))))    
```

这段代码告诉Clojure, 创建一个新的作用域, 在此作用域里, 将`remaining-asym-parts`的第一个元素命名为`part`, 剩余元素命名为`remaining`. 函数体中的`recur`后文会讲. 

```clojure
(into final-body-parts
  (set [part (matching-part part)]))
```

`set`函数创建一个set结构用来储存`part`. 然后, `into`是将生成的set添加到`final-body-parts`中去. 这里使用set是为了用来排除`part`和`(matching-part part)`中的重复元素, 下面是个关于`into`的例子:

```clojure
(into []  (set [:a :a]))
; => [:a]
```

首先, `(set [:a :a])`返回set`#{:a}`, 然后`(into [] #{:a})`计算的`[:a]`.

说回到`let`: `part`在函数体里使用了多次, 如果不用let, 代码将变得难以读懂:

```clojure
(recur (rest remaining-asym-parts)
       (into final-body-parts
             (set [(first remaining-asym-parts) (matching-part (first remaining-asym-parts))])))
```

所以, `let`是个通过引入局部变量, 使代码变得易读的有效方法.

#### loop

在函数`symmetrize-body-parts`中我们使用到了`loop`, `loop`提供了一种递归循环的实现方式. 看看下例:

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
第一行中, `loop [iteration 0]`, 初始化值并开始循环. 第一次循环中, `iteration`的值为0. 然后第二行, 会有一个打印输出. 第三行, 检查`iteration`的值是否大于3, 如果大于3就跳出循环. 如果不大于3, 就重复这个过程. 这很像`loop`创建了一个参数是`iteration`的匿名函数, 而`recur`则像把值`(inc iteration)`作为参数传给这个匿名函数并调用它. 

你可以通过使用普通的函数定义来完成同样的事情:

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

如你所见, 这样的实现使代码看起来更加冗长. 而且, loop的性能更好. In our symmetrizing function, we’ll use loop to go through each element in the asymmetrical list of body parts.

#### 正则表达式

正则表达式是用于对文本模式匹配的工具. 它的表示方法如下:

```clojure
#"regular-expression"
```

代码3-1中, `clojure.string/replace`函数调用中, 为了将"left-"替换为"right-", 使用正则表达式`#"^left-"`来匹配以"left-"开头的字符串. `^`符号是正则表达式用来匹配只有字符串开头的, 也就是只有以"left-"开头的字符串才会被匹配到. 您可以使用`re-find`函数来测试这一点, 它检查字符串是否与正则表达式描述的模式匹配, 如果没有匹配则返回nil:

```clojure
(re-find #"^left-" "left-eye")
; => "left-"

(re-find #"^left-" "cleft-chin")
; => nil

(re-find #"^left-" "wongleblart")
; => nil
```

下面是使用正则表达式将“left-”替换为“right-”的几个示例:

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

#### 让地鼠模型对称起来

让我们回到填充地鼠模型的方法的细节中去:

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

函数`symmetrize-body-parts`(➊处)采用了在指令式编程中常用的方法. 就是不断的使用尾递归的方式把一个集合从第一个元素开始一个一个的处理.

循环是从➋处开始的. 集合的剩余部分被绑定到了`remaining-asym-parts`上. `remaining-asym-parts`的初始值为`asym-body-parts`, 另外一个用来输出结果的集合`final-body-parts`初始值为一个空的vector.

➌处, 如果`remaining-asym-parts`为空了, 就意味着可以返回一个`final-body-parts`的最终结果了. 否则, 就把remaining-asym-parts拆成两部分: 头和剩余的部分. 

➎处, 吧remaining作为下一次循环的remaining-asym-parts的值, into表达式中则处理final-body-parts的结果. 

如果你是从未接触过函数式编程, 这段代码可能需要一些时间来理解. 坚持下去! 一旦你了理解了, 你会觉得像中了百万元的彩票一样兴奋.

#### 使用reduce优化

这种吧每一次迭代的结果作为下一次迭代的参数是一种很常见的模式, 在clojure中有一个内置函数`reduce`实现了这种模式:

```clojure
;; sum with reduce
(reduce + [1 2 3 4])
; => 10
```

等效于:

```clojure
(+ (+ (+ 1 2) 3) 4)
```

`reduce`函数会按照下面的步骤工作:

将前两个元素作为给定函数的参数计算. 上例中就是`(+ 1 2)`. 然后将计算的结果和序列中的下一个函数作为参数传入给定的函数. 上例中`(+ 1 2)`结果为3, 然后第三个元素为3, 于是等效于`(+ 3 3)`. 依此类推, 直到序列的最后一个元素. reduce还可以有一个可选参数 - 初始值:

```clojure
(reduce + 15 [1 2 3 4])
```
如果提供了初始值, 则reduce通过将给定函数应用于初始值和序列的第一个元素而不是序列的前两个元素来开始. 

这有一个细节, 本例中, reduce接受一个集合`[1 2 3 4]`并返回一个数字. 虽然这种传入一个集合返回一个单独的值的情况非常常见, 但也可以返回一个比传入的集合更大的集合. reduce的意义在于"处理一个集合并构建一个结果", 但这个结果的类型可以是任何类型. 下面是一段解释reduce如何工作的代码:

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

我们可以重构我们的symmetrize-body-parts函数:

```clojure
(defn better-symmetrize-body-parts
  "Expects a seq of maps that have a :name and :size"
  [asym-body-parts]
  (reduce (fn [final-body-parts part]
            (into final-body-parts (set [part (matching-part part)])))
          []
          asym-body-parts))
```

使用reduce优化后的代码, 代码量明显减少. 你传给reduce的匿名函数只用去关心集合中的需要处理的单独元素并构建出结果. reduce的则帮你隐去了到底是要返回最终结果或是继续迭代的细节判断. 

使用reduce也更具表现力. 如果你的代码的读者遇到循环, 他们将不能确定循环正在做什么, 除非阅读所有的代码. 但是如果他们看到reduce, 他们会立即知道代码的目的是处理集合的元素以构建结果. 

最后, 通过将reduce过程抽象为另一个函数作为参数的函数(高阶函数), 你的程序变得更加可复用. 您可以将reduce函数作为参数传递给其他函数, 比如symmetrize-body-parts. 可以扩展成实现生成指定数量的眼睛耳朵的模型的函数. 

#### 运行

来调用我们写好的代码吧, 下面就是一段正真开始"打"地鼠的代码:

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
➊处用于通过`asym-body-parts`构建完成的地鼠模型, 然后 ➋处, 用来把身体尺寸总大小计算出来. 一旦我们计算出来这个, 我们就可以根据一个数字来代表身体的一个部分了. 

![hobbit-hit-line.png]({{ site.url | append:site.baseurl }}/images/hobbit-hit-line.png)

图3-1：身体部位对应于数字范围, 如果目标位于该范围内, 则命中. 最后, 随机选择这些数字中的一个, 然后使用➌处的循环来找到并返回与数字对应的身体部位. 循环通过跟踪我们检查的部分的累积大小并检查累积大小是否大于目标来执行此操作. 

下面是一些运行的示例:

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

这一章给你一个关于CLojure的快速浏览. 现在你知道如何使用字符串,数字，地图, 关键字, vector, list和set来表示信息, 以及如何使用def和let来命名这些他们. 您已经了解了函数以及如何创建他们. 此外, 你也了解了Clojure的简单哲学, 包括其简单并一致性的语法和偏向于在原始数据类型上进行数据加工. 

第4章将详细介绍Clojure的核心功能, 第5章解释函数式编程思维. 本章是告诉你如何写Clojure代码, 下两章这是教你如何写的漂亮.

我推荐你开始用Clojure写代码, 熟悉Clojure的方式中, 没有比这更好的了. The Clojure Cheat Sheet (<http://clojure.org/api/cheatsheet>)列出了本章所说的数据结构和内置函数, 是个很好的参考手册. 

接下来是些练习. 如果你想获得更多的练习题, 看看这两个网站<http://www.projecteuler.net/>, <http://www.4clojure.com/problems/>. 

## 练习

这些练习可以用一种有趣的方式来测试你的Clojure知识并了解更多Clojure函数. 前三个可以仅使用本章中提供的信息完成, 但最后三个将要求您使用迄今尚未涵盖的功能. 解决最后三个, 如果你真的很想编写更多的代码和探索Clojure的标准库. 如果你觉得练习太难了, 请在阅读第4章和第5章之后重新阅读, 你会发现它们更容易. 

* 练习使用str, vector, list, hash-map, hash-set 函数.

* 写一个函数, 接受一个数字给这个数字加100并返回.

* 写一个名为dec-maker的函数, 让它看起来像inc-maker的减法版:
```clojure
(def dec9 (dec-maker 9))
(dec9 10)
; => 1
```

* 写一个名为mapset的函数, 使其工作起来像函数map, 只是返回值为一个set:
```clojure
(mapset inc [1 1 2 2])
; => #{2 3}
```

* 创建一个类似于`symmetrize-body-parts`的函数, 使地鼠模型有5只眼睛, 耳朵和手臂等. 

* 泛化上一题, 让眼睛耳朵的个数可以作为参数传入.

> 译后续
>
> 本文原文链接:<http://www.braveclojure.com/do-things/>
> 学习Clojure的计划已经失败了太多次了, 这次又要挑战一回. 突然萌生出, 找本好的不枯燥的入门读物来翻译一下的想法, 边学边翻译. 希望这次能坚持下去. 23333...
>
> 开始这一章翻译的时候, 才知道看懂E文和翻译出来完全不是一回事, 现在读一遍自己的译文是在是太生硬了, 而且还有几段文字实在不知道咋翻译. 不过好歹大体上弄出来了, 如果有谁看不爽了请轻拍. 
>
> 作者的网站:<http://www.braveclojure.com/>

