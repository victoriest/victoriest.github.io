---
layout: post
title: "Golang实现简单tcp服务器"
date: 2015-11-18
description: Golang实现简单tcp服务器
tags:
 - golang
 - tcp服务器
excerpt_separator: <!--more-->
---

## 概述

Golang作为一门近些年来非常风光的开发语言, 其实用范围很广, 图形界面, web框架, 图像引擎等等.
由于其语言特性简化了并发/多核的开发, 受到了很大的关注. 而使用它进行服务器开发, 也是非常高校而简洁的.
废话不多说, 本项目实践的目的是使用golang开发一个简单的基于tcp协议的服务器/客户端.

### 预备知识
首先, 我们需要了解一下golang下的如下包与特性:

### goroutine
goroutine是一种轻量型的线程, 作为golang语言的语言特性, 可以很简单的在golang中进行多线程的开发. 利用go关键字, 我们能把任何一个方法/函数, 放在一个新的goroutine里执行.
实验01:

在**实验环境**的**主文件夹**里, 建立一个名为test.go的文本文档, 并开始编写以下代码
```go
	package main

 	import (
 		"fmt"
 	)

 	var quit chan bool = make(chan bool)

 	func main() {
 		go testGorountine()
 		<-quit
 	}

 	func testGorountine() {
 		for i := 0; i < 10; i++ {
 			fmt.Println("Hello world!")
 		}
 		quit <- true
 	}
```
然后, 打开xFce终端, 键入命令
> go run test.go

<!--more-->

我们就会看到终端的输出, 可以看到10行"hello world".  这里, 我们的hello world程序就是利用了gorountine创建了一个多线程/协程程序, 然后利用channel等待开启的协程处理完毕, 才结束主线程.

### net包
在net包中, 提供了常用网络I/O操作的api, 包括我们的试验中需要用到的, Listen, Accept, Write, Read等方法. 具体参考链接:[http://godoc.golangtc.com/pkg/net/](http://godoc.golangtc.com/pkg/net/)

### bufio包
bufio包则提供了一套有缓存的I/O读写操作的方法, 在我们的服务器与客户端进行数据通讯时, 会用到. 参考链接:[http://godoc.golangtc.com/pkg/bufio/](http://godoc.golangtc.com/pkg/bufio/)

然后, 还需要对**长连接的TCP服务器**与客户端通讯有个基本的认识:
client向server发起连接，server接受client连接，双方建立连接。Client与server完成一次读写之后，它们之间的连接并不会主动关闭，后续的读写操作会继续使用这个连接。 关于这个概念, 网上有很多参考资料, 如果还不清楚, 随便google一下~

## 用Golang实现 echo服务器/客户端

本节我们就从实现一个简单的echo的服务端/客户端来入手, 了解golang的实现tcp长连接服务器的具体细节.

首先, 我们先列一下**服务端的实现思路及步骤**:
1. 创建一个套接字对象, 指定其IP以及端口.
2. 开始监听套接字指定的端口.
3. 如有新的客户端连接请求, 则建立一个goroutine, 在goroutine中, 读取客户端消息, 并转发回去, 直到客户端断开连接
4. 主进程继续监听端口.

我们可以在实验环境的主文件夹中, 建立一个名为server.go的文件, 在其中编写服务器端程序代码
服务端程序清单如下:

**server.go**
```go
    package main

    import (
    	"bufio"
    	"fmt"
    	"net"
    	"time"
    )

    func main() {
    	var tcpAddr *net.TCPAddr

    	tcpAddr, _ = net.ResolveTCPAddr("tcp", "127.0.0.1:9999")

    	tcpListener, _ := net.ListenTCP("tcp", tcpAddr)

    	defer tcpListener.Close()

    	for {
    		tcpConn, err := tcpListener.AcceptTCP()
    		if err != nil {
    			continue
    		}

    		fmt.Println("A client connected : " + tcpConn.RemoteAddr().String())
    		go tcpPipe(tcpConn)
    	}

    }

    func tcpPipe(conn *net.TCPConn) {
    	ipStr := conn.RemoteAddr().String()
    	defer func() {
    		fmt.Println("disconnected :" + ipStr)
    		conn.Close()
    	}()
    	reader := bufio.NewReader(conn)

    	for {
    		message, err := reader.ReadString('\n')
    		if err != nil {
    			return
    		}

    		fmt.Println(string(message))
    		msg := time.Now().String() + "\n"
    		b := []byte(msg)
    		conn.Write(b)
    	}
    }
```

接着, 我们打开终端, 编译服务端程序:

> go build server.go

编译成功的话, 会在主目录中看到编译成功的server程序

接下来, 是**客户端的代码实现步骤**:
1. 创建一个套接字对象, ip与端口指定到上面我们实现的服务器的ip与端口上.
2. 使用创建好的套接字对象连接服务器.
3. 连接成功后, 开启一个goroutine, 在这个goroutine内, 定时的向服务器发送消息, 并接受服务器的返回消息, 直到错误发生或断开连接.

程序清单如下:

client.go
```go
    package main

    import (
    	"bufio"
    	"fmt"
    	"net"
    	"time"
    )

    var quitSemaphore chan bool

    func main() {
    	var tcpAddr *net.TCPAddr
    	tcpAddr, _ = net.ResolveTCPAddr("tcp", "127.0.0.1:9999")

    	conn, _ := net.DialTCP("tcp", nil, tcpAddr)
    	defer conn.Close()
    	fmt.Println("connected!")

    	go onMessageRecived(conn)

    	b := []byte("time\n")
    	conn.Write(b)

    	<-quitSemaphore
    }

    func onMessageRecived(conn *net.TCPConn) {
    	reader := bufio.NewReader(conn)
    	for {
    		msg, err := reader.ReadString('\n')
    		fmt.Println(msg)
    		if err != nil {
    			quitSemaphore <- true
    			break
    		}
    		time.Sleep(time.Second)
    		b := []byte(msg)
    		conn.Write(b)
    	}
    }
```

编译客户端:

> go build client.go

最后, 开启两个终端, 分别运行server和client

可以看到以下类似的输出:

> connected!
> 2015-03-19 23:42:08.4875559 +0800 CST
>
> 2015-03-19 23:42:09.4896132 +0800 CST
>
> 2015-03-19 23:42:10.4906704 +0800 CST
>
> 2015-03-19 23:42:11.4917277 +0800 CST


这样, 一个简单的echo服务器/客户端就实现了

## 用Golang实现 文本广播式聊天服务器/客户端

本节, 我们将一步一步的把上一节完成的echo服务器/客户端改造成一个文本信息的聊天室

**服务端的改动**

1. 服务器为了实现聊天信息的群体广播, 需要记录所有连接到服务器的客户端信息, 所以, 我们需要添加一个集合来保存所有客户端的连接:
	> var ConnMap map[string]*net.TCPConn

2. 接着, 每次当有新的客户端连接到服务器时, 需要把这个客户端连接行信息加入集合:
	> ConnMap[tcpConn.RemoteAddr().String()] = tcpConn

3. 当服务器收到客户端的聊天信息时, 需要广播到所有客户端, 所以我们需要利用上面保存TCPConn的map来遍历所有TCPConn进行广播, 用以下方法实现:
```go
		func boradcastMessage(message string) {
			b := []byte(message)
			for _, conn := range ConnMap {
			conn.Write(b)
			}
		}
```
**客户端代码改动**

客户端代码改动相对简单, 只是加入了用户自己输入聊天信息的功能, 在连接成功并且 启动了消息接收的gorountine后, 加入以下代码:
```go
		for {
			var msg string
			fmt.Scanln(&msg)
			if msg == "quit" {
				break
			}
			b := []byte(msg + "\n")
			conn.Write(b)
		}
```

完整的服务端代码如下:

server.go
```go
	package main

	import (
		"bufio"
		"fmt"
		"net"
	)

	// 用来记录所有的客户端连接
	var ConnMap map[string]*net.TCPConn

	func main() {
		var tcpAddr *net.TCPAddr
		ConnMap = make(map[string]*net.TCPConn)
		tcpAddr, _ = net.ResolveTCPAddr("tcp", "127.0.0.1:9999")

		tcpListener, _ := net.ListenTCP("tcp", tcpAddr)

		defer tcpListener.Close()

		for {
			tcpConn, err := tcpListener.AcceptTCP()
			if err != nil {
				continue
			}

			fmt.Println("A client connected : " + tcpConn.RemoteAddr().String())
			// 新连接加入map
			ConnMap[tcpConn.RemoteAddr().String()] = tcpConn
			go tcpPipe(tcpConn)
		}

	}

	func tcpPipe(conn *net.TCPConn) {
		ipStr := conn.RemoteAddr().String()
		defer func() {
			fmt.Println("disconnected :" + ipStr)
			conn.Close()
		}()
		reader := bufio.NewReader(conn)

		for {
			message, err := reader.ReadString('\n')
			if err != nil {
				return
			}
			fmt.Println(conn.RemoteAddr().String() + ":" + string(message))
			// 这里返回消息改为了广播
			boradcastMessage(conn.RemoteAddr().String() + ":" + string(message))
		}
	}


	func boradcastMessage(message string) {
		b := []byte(message)
		// 遍历所有客户端并发送消息
		for _, conn := range ConnMap {
			conn.Write(b)
		}
	}
```

客户端完整代码如下:

client.go
```go
	package main

	import (
		"bufio"
		"fmt"
		"net"
	)

	func main() {
		var tcpAddr *net.TCPAddr
		tcpAddr, _ = net.ResolveTCPAddr("tcp", "127.0.0.1:9999")

		conn, _ := net.DialTCP("tcp", nil, tcpAddr)
		defer conn.Close()
		fmt.Println("connected!")

		go onMessageRecived(conn)

		// 控制台聊天功能加入
		for {
			var msg string
			fmt.Scanln(&msg)
			if msg == "quit" {
				break
			}
			b := []byte(msg + "\n")
			conn.Write(b)
		}
	}

	func onMessageRecived(conn *net.TCPConn) {
		reader := bufio.NewReader(conn)
		for {
			msg, err := reader.ReadString('\n')
			fmt.Println(msg)
			if err != nil {
				quitSemaphore <- true
				break
			}
		}
	}
```
最后分别编译server与client试试效果吧!

> go build server.go
>
> go build client.go

先启动server端, 然后新开两个个终端, 启动客户端, 在其中一个客户端里键入聊天信息后回车, 会发现另外一个客户端收到了刚刚发送的聊下天信息

完事大吉!

## 服务器的粘包处理

**什么是粘包**

一个完成的消息可能会被TCP拆分成多个包进行发送，也有可能把多个小的包封装成一个大的数据包发送，这个就是TCP的拆包和封包问题

**TCP粘包和拆包产生的原因**

1. 应用程序写入数据的字节大小大于套接字发送缓冲区的大小

2. 进行MSS大小的TCP分段。MSS是最大报文段长度的缩写。MSS是TCP报文段中的数据字段的最大长度。数据字段加上TCP首部才等于整个的TCP报文段。所以MSS并不是TCP报文段的最大长度，而是：MSS=TCP报文段长度-TCP首部长度

3. 以太网的payload大于MTU进行IP分片。MTU指：一种通信协议的某一层上面所能通过的最大数据包大小。如果IP层有一个数据包要传，而且数据的长度比链路层的MTU大，那么IP层就会进行分片，把数据包分成托干片，让每一片都不超过MTU。注意，IP分片可以发生在原始发送端主机上，也可以发生在中间路由器上。

**TCP粘包和拆包的解决策略**

1. 消息定长。例如100字节。
2. 在包尾部增加回车或者空格符等特殊字符进行分割，典型的如FTP协议
3. 将消息分为消息头和消息尾。
4. 其它复杂的协议，如RTMP协议等。

参考(http://blog.csdn.net/initphp/article/details/41948919)

**我们的处理方式**

解决粘包问题有多种多样的方式, 我们这里的做法是:

- 发送方在每次发送消息时将消息长度写入一个int32作为包头一并发送出去, 我们称之为Encode
- 接受方则先读取一个int32的长度的消息长度信息, 再根据长度读取相应长的byte数据, 称之为Decode

在实验环境中的主文件夹内,  新建一个名为codec的文件夹在其之下新建一个文件codec.go, 将我们的Encode和Decode方法写入其中, 这里给出Encode与Decode相应的代码:

codec.go
```go
	package codec
	import (
		"bufio"
		"bytes"
		"encoding/binary"
	)

	func Encode(message string) ([]byte, error) {
		// 读取消息的长度
		var length int32 = int32(len(message))
		var pkg *bytes.Buffer = new(bytes.Buffer)
		// 写入消息头
		err := binary.Write(pkg, binary.LittleEndian, length)
		if err != nil {
			return nil, err
		}
		// 写入消息实体
		err = binary.Write(pkg, binary.LittleEndian, []byte(message))
		if err != nil {
			return nil, err
		}

		return pkg.Bytes(), nil
	}

	func Decode(reader *bufio.Reader) (string, error) {
		// 读取消息的长度
		lengthByte, _ := reader.Peek(4)
		lengthBuff := bytes.NewBuffer(lengthByte)
		var length int32
		err := binary.Read(lengthBuff, binary.LittleEndian, &length)
		if err != nil {
			return "", err
		}
		if int32(reader.Buffered()) < length+4 {
			return "", err
		}

		// 读取消息真正的内容
		pack := make([]byte, int(4+length))
		_, err = reader.Read(pack)
		if err != nil {
			return "", err
		}
		return string(pack[4:]), nil
	}
```
这里就不帖服务器与客户端的调用代码了, 同学们自己动手试试~
