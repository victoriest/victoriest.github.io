---
layout: post
title: "goprotobuf安装与使用"
date: 2015-11-18
description: goprotobuf安装与使用
tags:
 - golang
 - protobuff
---

- 安装 : 

> go get code.google.com/p/goprotobuf/{proto,protoc-gen-go}
> 
> go install  code.google.com/p/goprotobuf/proto

- 编译.proto文件

> protoc 文件路径.proto --go_out=输出路径

- 导入包 "code.google.com/p/goprotobuf/proto"
```go
    buff := &pb.MobileSuiteProtobuf{  
    	Type:proto.Int32(321),  
    	Arena:   proto.Int32(111),  
    	Command: proto.Int32(0xa),  
    	Message: byt,  
    }  
    bybuf, _ := proto.Marshal(buff)  
```
如果遇到不能下载goprotobuf的情况, 修改自己的 hosts文件 参见这里



- 参考文献: 

> http://www.cnblogs.com/zhangqingping/archive/2012/10/28/2743274.html
> 
> https://godoc.org/code.google.com/p/goprotobuf/proto
