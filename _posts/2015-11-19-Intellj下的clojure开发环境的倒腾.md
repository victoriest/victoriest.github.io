---
layout: post
title: "IntelliJ IDEA 下的clojure 开发环境配置笔记"
date: 2015-11-19
description: IntelliJ IDEA 下的clojure 开发环境配置笔记
tags:
 - clojure
 - IntelliJ
 - Leiningen
---


### 系统环境
* MacOS 10.11.1
* IntelliJ IDEA 14.1

### 安装Leiningen

mac下, 可以使用```brew install leiningen```安装, 很简单; 当然, 你也可以访问[Leiningen官网安装引导界面](http://leiningen.org/#install), 下载一个lein.sh文件, 并按照网页上描述的方式下载并安装Leiningen

### 安装Cursive插件

首先, 你要有IntelliJ, 在[Cursive的安装引导页面](https://cursive-ide.com/userguide/index.html)有详细安装引导.

### 新建/导入Leiningen项目到IntelliJ

目前的Cursive版本不支持直接在IDEA里创建leiningen的clojure项目, 所以, 你只能在外面创建好项目后, 导入到IDEA:

* 在终端使用```lein new 项目名称```命令来创建一个leiningen项目
* 在IDEA中, File -> New -> Project from Exisitng Sources... 选中刚刚创建的lein项目

更多信息, 参考[https://cursive-ide.com/userguide/leiningen.html](https://cursive-ide.com/userguide/leiningen.html)

### 在IntelliJ中配置Repl

* 在IDEA中, Run -> Edit Configurations... 点击弹出的窗口左上的加号, 选择local Clojure REPL.
* 选择Run with Leiningen 起个名字, OK
* 然后就可以在绿色的开始图标中启动Leiningen的Repl环境了

更多信息, 参考[https://cursive-ide.com/userguide/repl.html](https://cursive-ide.com/userguide/repl.html)

### 运行clojure环境

### 调试clojure环境

### 打包发布clojure程序
