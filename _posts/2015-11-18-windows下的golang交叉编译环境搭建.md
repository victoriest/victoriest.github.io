---
layout: post
title: "windows下的golang交叉编译环境搭建"
date: 2015-11-18
description: windows下的golang交叉编译环境搭建
tags:
 - golang
excerpt_separator: <!--more-->
---

1. 下载[mingw](http://sourceforge.net/projects/mingw/files/)

2. 下载安装完成后, MinGW/bin添加到系统环境变量 PATH 中

3. 在GO\src的目录下 执行如下批处理

>     rm -rf ../bin ../pkg
>     set CGO_ENABLED=0
>     ::x86块
>     set GOARCH=386
>     set GOOS=windows
>     call make.bat --no-clean
>     set GOOS=linux
>     call make.bat --no-clean
>     set GOOS=freebsd
>     call make.bat --no-clean
>     set GOOS=darwin
>     call make.bat --no-clean
>     ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
>     ::x64块
>     set GOARCH=amd64
>     set GOOS=linux
>     call make.bat --no-clean
>     :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
>     ::arm块
>     set GOARCH=arm
>     set GOOS=linux
>     call make.bat --no-clean
>     ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
>     set GOARCH=386
>     set GOOS=windows
>     go get github.com/nsf/gocode
>     pause

运行完毕将会产生交叉编译环境列表如下(不完全，请根据自己需要修改)

<!--more-->

x86的windows/linux/darwin(mac os)/freebsd

x64的linux

arm的linux(android)

另外还将安装gocode用于代码提示


将如下批处理文件放置到你的.go源文件所在目录下运行，即可产生对应平台的可执行文件

>     set GOPATH=你的工程目录
>     set GOARCH=386
>     set GOOS=linux
>     go build
>     pause


