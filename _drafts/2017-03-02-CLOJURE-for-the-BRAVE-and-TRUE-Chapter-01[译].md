---
layout: post
title: CLOJURE-for-the-BRAVE-and-TRUE-Chapter-01[译]
date: 2017-03-02
description: CLOJURE-for-the-BRAVE-and-TRUE-Chapter-01[译]
tags:
 - clojure
excerpt_separator: <!--more-->
---

# Building, Running, and the REPL

这一章里, 你将花费少量时间使用快速简单的方法, 来熟悉构建和运行一个Clojure程序. 让一个程序真正跑起来感觉很棒. 达到这个目标后, 可以让你去试验以及分享自己的工作, 并可以在还用着老旧语言的同事们面前装B. 这可以让你保持动力.

同时你也会学习到如何使用REPL(Read-Eval-Print)在一个运行过程中的进程立即执行指定代码, 这让你可以快速的验证你对语言的理解并让学习更加高效. 

但首先, 我将简要介绍Clojure. 接着, 我将介绍Leiningen, 它基本上算是Clojure的标准构建工具. 在本章结束时, 您将学会如何执行以下操作:

* 使用Leiningen创建一个Clojure工程
* 将工程打包成一个可执行的jar文件
* 执行jar文件
* 在Clojure REPL中执行键入的代码

## 首先的首先: 什么是Clojure?

Clojure由Rich Hickey创造, 一个类似于Lisp的函数式编程语言, 美丽而功能强大.(译者:原文的描述太中二, 这里只概括一下大意, 你们懂就行了.) Lisp语系相对于非lisp语系而言, 提供了更强大的表达能力, 他独特的函数式编程思想会迫使你像个程序员一样思考. 此外, Clojure为您提供了更好的工具来解决复杂的领域的问题(如并发编程), 这些问题通常会耗费开发者很长时间.

当我们谈论Clojure是, 区分Clojure语言与Clojure编译器是相当重要的. Clojure语言是一个有着函数式特点的Lisp方言, 其语法以及语义是独立于其任何实现存在的. 而Clojure编译器是一个可执行的jar文件 - clojure.jar, 它会将用Clojure语言编写的代码编译为JVM的字节码. Clojure这个名字我们通常指代编译器和语言, 但记住这是两个不同的东西.

这种区分是必要的, 因为与大多数编程语言(如Ruby, Python, C和其他语言)不同, Clojure是一种托管语言.

我们稍后将探讨Clojure和JVM之间的关系，但是现在你需要理解的主要概念是这些:

* JVM进程执行Java字节码
* 通常, Java字节码是由Java源码通过Java编译器编译而成
* Jar文件是一个java字节码的集合
* Java程序通常被发布成Jar文件
* Java程序clojure.jar读取Clojure源代码并生成Java字节码
* 编译出来的Java字节码会在clojure.jar同个JVM进程中执行

Clojure在持续快速的更新, 在写这篇文章时, 它的版本是1.7.0. 如果你在读这本书时, Clojure有更高的版本号, 不要担心!
这本书涵盖了Clojure的基础知识, 不太可能在版本更替中过时.

既然你已经知道CLojure是什么了, 接下来该弄个CLojure程序出来了.

## Leiningen

近来, 大多数Clojure开发者使用Leiningen构建和管理他们的工程. 你可以在附录A中得到Leiningen的完整描述, 但现在我们将专注于使用它来完成四个任务:

1. 创建一个Clojure工程
2. 运行这个工程
3. 编译这个工程
4. 使用REPL

在继续之前, 请确保已安装Java 1.6或更高版本. 您可以通过在终端中运行java -version来检查您的版本, 并从<http://www.oracle.com/technetwork/java/javase/downloads/index.html>下载最新的Java运行时环境(JRE). 然后, 使用Leiningen主页<http://leiningen.org/>上的说明安装Leiningen(Windows用户，请注意有一个Windows安装程序). 当你安装Leiningen时, 它会自动下载Clojure编译器clojure.jar.
(上段为机翻)

### 创建一个Clojure工程

创建一个新的Clojure项目非常简单. 单个Leiningen命令创建项目骨架. 稍后, 您将学习如何执行诸如合并Clojure库等任务, 但现在, 这些指令将使您能够执行您编写的代码.

继续，通过在终端中键入以下内容创建你的第一个Clojure项目: 

```
lein new app clojure-noob
```

该命令会创建一个类似于如下的目录结构(可能会有些差异, 但不必在意):

```
| .gitignore
| doc
| | intro.md
➊ | project.clj
| README.md
➋ | resources
| src
| | clojure_noob
➌ | | | core.clj
➍ | test
| | clojure_noob
| | | core_test.clj
```

这个结构并不是Clojure的约束或规定, 这只是Leiningen的一个约定的目录结构而已. 你将使用Leiningen来构建和运行Clojure应用程序, Leiningen希望你的应用程序具有这种结构. ➊处的文件就是Leiningen的配置文件. 它告诉Leiningen: "这个项目有什么依赖项?"或者"这个Clojure程序的入口函数是什么?". 通常, 源代码保存在src/[project_name]目录下. 这里, 接下来你会在➌ 处的src/clojure_noob/core.clj文件写一些代码. ➍ 是存放测试代码的地方, 而➋ 存放你的资源文件. 

### 运行Clojure工程

现在我们来让这个工程跑起来. 用你顺手的编辑器打开src/clojure_noob/core.clj, 你会看到:

```clojure
➊ (ns clojure-noob.core
  (:gen-class))

➋ (defn -main
  "I don't do a whole lot...yet."
  [& args]
➌   (println "Hello, World!"))
```

在➊的行声明一个命名空间, 你现在先别管它.  在➋ 处的-main方法是该程序的入口,  附录A中有一个话题会提到它. 现在, 将 ➌处的"Hello, world!" 替换为"I'm a little teapot!". 整行内容将会是 (println "I'm a little teapot!")).

接下来, 在终端下进入目录clojure_noob并输入以下命令:

```
lein run
```

你将会看到输出一句"I'm a little teapot!". 那么恭喜, 你成功执行了一个Clojure程序.

你将在接下来的章节里会了解更多的的时候更多地了解程序中发生了什么，但是现在你需要知道的是，你创建了一个函数-main，当你在命令行执行lein run时运行该函数.

### 编译Clojure工程

使用`lein run`可以很好的测试你的代码, 但你想在没有安装Leiningen的机器上分享运行你的程序, 你可以创建一个任何安装了JVM都可以执行的可执行jar文件. 以下是创建命令:

```
lein uberjar
```

此命令会创建一个文件在如下位置`target/uberjar/clojure-noob-0.1.0-SNAPSHOT-standalone.jar`. 你可以通过java命令运行它:

```
java -jar target/uberjar/clojure-noob-0.1.0-SNAPSHOT-standalone.jar
```

看吧! 这个jar文件是一个可以再几乎任何平台上运行的Clojure程序.

现在你有了构建, 运行和发布Clojure程序所需的所有基础知识. 再后面的章节中, 你会深入了解到Leiningen的一些命令的细节, 从而全面了解Clojure与JVM的关系以及如何运行代码的.

在开始第二章的Emacs学习之前, 先看看一个非常重要的工具:REPL. (译者: 遗憾的是, 我并不打算翻译第二章)

### 使用REPL

REPL是一个用于试验代码的工具, 它允许你与正在运行的程序交互, 并快速尝试你的想法. 他接受你的输入, 执行它, 打印结果, 循环往复. 

这个REPL过程可以迅速的反馈结果, 而其他大多数语言中, 是无法实现的. 我强烈建议你经常使用它来快速检查你对Clojure的学习过程中的理解是否正确. 此外, REPL是一个Lisp开发过程中的重要部分, 如果不用真的是你的一大损失.

打开一个REPL, 在命令行中执行:

```
lein repl
```

给你的反馈会像下面这样:

```
nREPL server started on port 28925
REPL-y 0.1.10
Clojure 1.7.0
    Exit: Control+D or (exit) or (quit)
Commands: (user/help)
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
          (user/sourcery function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
Examples from clojuredocs.org: [clojuredocs or cdoc]
          (user/clojuredocs name-here)
          (user/clojuredocs "ns-here" "name-here")
clojure-noob.core=>
```

最后一行`clojure-noob.core=>`告诉我们, 我们当前在一个叫`clojure-noob.core`的名空间下. 稍后咱们会学到名空间, 现在我们只需要知道命名空间基本上与您的src/clojure_noob/core.clj文件的名称相匹配. 另外, REPL显示版本为Clojure 1.7.0, 但如前所述, 无论你使用哪个版本, 都不会有太大出入. 

它还提示你的代码已加载到REPL中, 你可以执行已定义的函数. 我们现在只定义了一个函数-main. 执行它:

```clojure
clojure-noob.core=> (-main)
I'm a little teapot!
nil
```

做得好! 你刚刚使用了REPL来调用函数. 接下来试下别的Clojure函数:

```clojure
clojure-noob.core=> (+ 1 2 3 4)
10
clojure-noob.core=> (* 1 2 3 4)
24
clojure-noob.core=> (first [1 2 3 4])
1
```

阔以! 你做了个加法, 做了个乘法, 取了一个向量(vector)中的第一个元素. 并且第一次遇到了古怪的Lisp语法. 你也有你第一次遇到古怪的Lisp语法! 
所有Lisp方言，包括Clojure，采用前置表达式(prefix notation). 如果你不知道这是什么意思, 不要担心, 你会很快学到关于Clojure的语法. 

在概念上, REPL类似于Shell(SSH). Shell可以与远程服务器交互类似, Clojure REPL允许你与运行中的Clojure进程交互. 此功能可以非常强大, 因为您甚至可以将REPL附加到实时生产应用程序, 并在运行时修改程序. 从现在开始, 你将使用REPL来学习Clojure的语法和语义. 

注意: 现在起, 本书的代码不会显示REPL的提示符, 请动手练习. 如下:

```clojure
(do (println "no prompt here!")
   (+ 1 3))
; => no prompt here!
; => 4
```

当你看到这样的代码片段, 以`; =>`开头的行, 表示代码的输出. 上例中, 代码的返回值为4. 

## Clojure编辑器

(译者: 这里作者提到了Emacs, 和一些替代Emacs的推荐):

* 油管视频, 使用sublime text搭建clojure开发环境 <http://www.youtube.com/watch?v=wBl0rYXQdGg/>
* Vim的clojure开发环境搭建教程 <http://mybuddymichael.com/writings/writing-clojure-with-vim-in-2013.html>
* Eclipse的插件 <https://github.com/laurentpetit/ccw/wiki/GoogleCodeHome>
* IntelliJ的插件 <https://cursiveclojure.com/>
* Nightcode - 一个轻便的ClojureIDE <https://github.com/oakes/Nightcode/>

## 总结

(译者: 接写来是作者的幽默感)

I’m so proud of you, little teapot. You’ve run your first Clojure program! Not only that, but you’ve become acquainted with the REPL, one of the most important tools for developing Clojure software. Amazing! It brings to mind the immortal lines from “Long Live” by one of my personal heroes:

```
You held your head like a hero
On a history book page
It was the end of a decade
But the start of an age
—Taylor Swift
```

Bravo!

## 译后文

本文原文链接:<http://www.braveclojure.com/getting-started/>
学习Clojure的计划已经失败了太多次了, 这次又要挑战一回. 突然萌生出, 找本好的不枯燥的入门读物来翻译一下的想法, 边学边翻译. 希望这次能坚持下去. 23333...

书中透露出的作者的冷幽默我就没有照着翻译了, 还有, 我不打算翻译第二章, 因为, 我是vim党. 还有我觉得学习Clojure已经够麻烦了, 没必要再外带学习一个一样麻烦的编辑器. 需要的自己点链接去:<http://www.braveclojure.com/basic-emacs/>

作者的网站:<http://www.braveclojure.com/>

<!--more-->
