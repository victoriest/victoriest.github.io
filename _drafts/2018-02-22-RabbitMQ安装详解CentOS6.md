---
layout: post
title: RabbitMQ安装详解CentOS6
date: 2018-02-22
description: RabbitMQ安装详解CentOS6
excerpt_separator: <!--more-->
---

1. 下载rabbitmq安装包

<http://www.rabbitmq.com/install-rpm.html>
这里选择的是rabbitmq-server-3.7.0-1.el6.noarch.rpm

2. 安装erlang

* 安装Erlang Solutions仓库到你的系统（目的在于让你可以使用yum安装到最新版本的erlang， 如果不设置， yum安装的erlang版本通常太低）

```
wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
 
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
```

* 因为rabbitmq是使用erlang语言实现， 所以需要安装erlang依赖

```
	yum install -y erlang
```


3. 安装socat

```
yum install -y socat
```


4. 安装

```
rpm -ivh rabbitmq-server-3.7.0-1.el6.noarch.rpm
```

5. 启动

```
# 启动
service rabbitmq-server start
# 停止
service rabbitmq-server stop
# 重启
service rabbitmq-server restart
```


6. 账号配置

安装启动后其实还不能在其它机器访问， rabbitmq默认的guest账号只能在本地机器访问， 如果想在其它机器访问必须配置其它账号
配置管理员账号：

```
rabbitmqctl add_user admin adminpasspord
rabbitmqctl set_user_tags admin administrator
```

启动rabbitmq内置web插件， 管理rabbitmq账号等信息
```
rabbitmq-plugins enable rabbitmq_management
```

7. 访问 http://你的地址:15672/#/users  

<!--more-->
