---
layout: post
title: "VictoriEST的Clojure学习笔记 - 01"
date: 2015-11-18
description: VictoriEST的Clojure学习笔记 - 01
tags:
 - clojure
---


## 写在最开始的总结
一直想学习一门函数式编程语言, 最后从众多选择中挑选出clojure. 也买了书, 装了环境, 下了文档, 工作之余照着书敲一下代码, 坚持不到一个来星期就忘记了. 然后反反复复了很多次.

求其原因, 工作略忙; 传统的软件开发与函数式编程还是又一定的差距; 加之其与目前工作没有什么重合点, 用少了于是学习起来也就很吃力.

然而, 我又是如此的希望了解一门函数式编程语言. 为了督促与自我监督, 便有了此系列文, 注意我在打标题的时候有个序号"01", 这也是一种督促. 因为, 我看到过太多的类似学习笔记之类的文章, 都是烂尾, 如: "XXX学习笔记 - 第一章 概述", "第二章 安装", 然后就没有然后了, 我对此类文章以及坐着总是嗤之以鼻. 这也提醒着我, 不要成为那样的人.

这里之所以叫最开始的总结, 是因为之前我也反反复复的学了一些clojure的基本知识. 所以, clojure的安装, 环境的配置之类的我也不打算浪费笔墨. (clojure可以在其[官网](http://clojure.org/)下载最新版本, [Leiningen](http://leiningen.org)一定也是你用得到的工具), 我只在这里总结一下, 我还记得关于clojure的一些零碎片段. 之后, 在进行另一次的学习, 希望是最后一次.

## 目标
目标就是, 为了自我鞭策自己, 将clojure学习下去, 最终, 能够**使用clojure进行实际的开发**, 能够**编写, 测试, 发布clojure模块, 将coljure模块嵌入已有的java项目**, **开发web项目**(?)

## 我目前还没忘记的
下面是一些之前学习的仍然记得的皮毛:
- 安装配置完成环境后, 可以使用`lein repl`命令进入clojure的REPL环境.([什么是REPL](https://zh.wikipedia.org/wiki/%E8%AF%BB%E5%8F%96%EF%B9%A3%E6%B1%82%E5%80%BC%EF%B9%A3%E8%BE%93%E5%87%BA%E5%BE%AA%E7%8E%AF))
- 在clojure代码中, 最基本的语法单位是一对圆括号"()", 其中的函数的调用采用前缀记法, 如 4 + 5 在clojure中会写为(+ 4 5)
- 用defn来定义一个函数, 大概的形式如: `(defn [参数列表...] (表达式))`
- defn是一个基于fn和def的宏, 用于简化定义函数

看吧, 我能记得并讲清楚的就这, 少得可怜. 还有一些莫能两可的讲不清楚的, 我也不想在这里误人子弟. 就让我们在接下来的啃书本中, 慢慢的把它弄清楚吧.

##参考书目
这一轮学习, 主要学习路径是以[Clojure程序设计](http://www.amazon.cn/gp/product/B00BN5N7R4/ref=pd_lpo_sbs_dp_ss_2?pf_rd_p=238071972&pf_rd_s=lpo-top-stripe&pf_rd_t=201&pf_rd_i=B00G6T9BB8&pf_rd_m=A1AJ19PSB66TGU&pf_rd_r=1E5NE3CWP240A4A8WMP5)为顺序的, 再参考一些其他的文档来学习的, 如:
- [Clojure编程乐趣](http://www.ituring.com.cn/book/1458), 另外一本书
- [Clojure 的洞穴](http://wangjinquan.me/show/Clojure%20%E7%9A%84%E6%B4%9E%E7%A9%B4), 这是 Steve Losh的Clojure教程系列“The Caves of Clojure”的中译文
- [Clojure入门教程: Clojure – Functional Programming for the JVM中文版 ](http://xumingming.sinaapp.com/302/clojure-functional-programming-for-the-jvm-clojure-tutorial/)
- [Clojure Handbook](http://qiujj.com/static/clojure-handbook.html)
- [http://www.4clojure.com/](http://www.4clojure.com/), 这是一个clojure的在线练习的网站

那么, 学习开始, 接下来的一段时间, 我会慢慢更新学习进程的.
