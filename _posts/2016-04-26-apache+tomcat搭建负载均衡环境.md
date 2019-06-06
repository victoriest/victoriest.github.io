---
layout: post
title: "使用 apache 和 tomcat 搭建负载均衡环境"
date: 2016-04-26
description: 使用 apache 和 tomcat 搭建负载均衡环境
tags:
 - 负载均衡
 - apache
 - tomcat
excerpt_separator: <!--more-->
---

### 前置环境
* 安装apache 其中配置文件在/etc/httpd/conf/httpd.conf
* 安装tomcat, 复制两个tomcat实例用来测试(分别为/tomcat0, /tomcat1)

### tomcat配置
因为需要启动两个tomcat实例, 所以需要修改其中一个实例的配置文件, 以避免端口号占用. (tomcat配置文件在/tomcat/conf/server.xml)

### apache配置
```xml
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_http_module modules/mod_proxy_http.so

ProxyRequests Off
<Proxy balancer://mycluster>
    BalancerMember ajp://172.29.226.144:8009
    BalancerMember ajp://172.29.226.144:8019 status=+H
</Proxy>
ProxyPass /test balancer://mycluster/
ProxyPassReverse /test balancer://mycluster/

<Proxy balancer://mycluster1>
    BalancerMember ajp://172.29.226.144:8019
    BalancerMember ajp://172.29.226.144:8009 status=+H
</Proxy>
ProxyPass /test2 balancer://mycluster1/
ProxyPassReverse /test2 balancer://mycluster1/

<Location /balancer-manager>
SetHandler balancer-manager
Order Deny,Allow
Allow from all
</Location>
```
<!--more-->
* 配置示例中, 我们定义了两个负载均衡的组(mycluster和myclusters), 访问路径分别为/test和/test2

* status=+H, 的意义为热备份(Hot Standby), 当主节点down掉, 才会访问+H的节点

另外, 还需要在linux系统中, 设置一下:
```config
/usr/sbin/setsebool httpd_can_network_connect 1
```

### 测试运行
这里我们可以使用http://172.29.226.144/test/ 访问第一个集群, 用http://172.29.226.144/test2/ 访问第二个集群;
另外可以使用http://172.29.226.144/balancer-manager/ 来访问负载均衡的状态管理页面.

### 参考文章
* [http://blog.51yip.com/apachenginx/873.html](http://blog.51yip.com/apachenginx/873.html)

* [http://koda.iteye.com/blog/465061](http://koda.iteye.com/blog/465061)
