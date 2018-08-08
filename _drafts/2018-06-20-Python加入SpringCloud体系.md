---
layout: post
title: Python加入SpringCloud体系
date: 2018-06-20
description: Python加入SpringCloud体系
excerpt_separator: <!--more-->
---

其实下面参考的文章已经讲的很清楚了, 这里只简要的列一下实现步骤.

1. 在spring cloud 体系中引入[sidecar](https://cloud.spring.io/spring-cloud-netflix/multi/multi__polyglot_support_with_sidecar.html).

2. Python微服务, 添加一个健康检查的接口.

3. 实现python微服务

4. 依次启动, python微服务, eureka, sidecar, java服务


##### 参考

<https://blog.csdn.net/LoveCarpenter/article/details/78819227>

<https://www.cnblogs.com/YrlixJoe/p/7509655.html>

<http://www.dayexie.com/detail1214412.html>



<!--more-->
