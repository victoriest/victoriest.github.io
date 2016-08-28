---
layout: post
title: "zookeeper伪集群搭建笔记"
date: 2015-11-20
description: zookeeper伪集群搭建笔记
tags:
 - storm
 - zookeeper
---

这几天准备研究一下storm, 想先把storm的环境搭起来, 为了实现真是的集群环境, 在网上找了一些引导教程, 发现前置条件是需要搭建好zookeeper的服务器环境. 于是便有了此文.
此文, 用于记录**在linux环境下, 搭建zookeeper的(伪)集群环境的步骤.**

1. ##### 下载最新的稳定版的zookeeper
编写此文时, zookeeper的最新版本是3.4.6, 可以在zookeeper的官网[下载界面](http://www.apache.org/dyn/closer.cgi/zookeeper/), 通过wget下载, 如:
```shell
wget http://apache.dataguru.cn/zookeeper/zookeeper-3.3.6/zookeeper-3.3.6.tar.gz
```
下载成功后, 解压:
```shell
tar -xzf ./zookeeper-3.3.6.tar.gz
```
为了方便, 重命名zookeeper并且将zookepper移动到根目录:
```shell
mv ./zookeeper-3.3.6.tar.gz /zookeeper
```
2. ##### zookeeper伪集群环境的配置文件
zookeeper配置文件在conf目录下, 这里, 我们以启动3个服务器大小的zookeeper集群.
* 新建名为zoo1.cfg, zoo2.cfg, zoo3.cfg的文件, 内容如下:
```
# zoo1.cfg
tickTime=2000
dataDir=/home/zookeeper1
initLimit=5
syncLimit=2
clientPort=2181
server.1=127.0.0.1:2888:3888
server.2=127.0.0.1:2889:3889
server.3=127.0.0.1:2890:3890
```
```
# zoo2.cfg
tickTime=2000
dataDir=/home/zookeeper2
initLimit=5
syncLimit=2
clientPort=2182
server.1=127.0.0.1:2888:3888
server.2=127.0.0.1:2889:3889
server.3=127.0.0.1:2890:3890
```
```
# zoo3.cfg
tickTime=2000
dataDir=/home/zookeeper3
initLimit=5
syncLimit=2
clientPort=2183
server.1=127.0.0.1:2888:3888
server.2=127.0.0.1:2889:3889
server.3=127.0.0.1:2890:3890
```
* 建立zookeeper数据存储目录:
建立上面3个配置文件中dataDir里指定目录, 并分别在其目录下建立一个名为myid的文本文件, 内容为serverid. 如: 在/home/zookeeper1目录下myid的内容为1, 以此类推...

3. ##### 启动zookeeper集群
应用上面建立的3份配置文件启动3个zookeeper实例:
```
/zookeeper/bin/zkServer.sh start /zookeeper/conf/zoo1.cfg
/zookeeper/bin/zkServer.sh start /zookeeper/conf/zoo2.cfg
/zookeeper/bin/zkServer.sh start /zookeeper/conf/zoo3.cfg
```
启动成功的话, 用`jps`命令可以看到进程的id了.
