---
layout: post
title: 在tomcat中添加jfr日志
date: 2018-01-08
description: 在tomcat中添加jfr日志
---

catalina.sh最上面加入如下:
```
JAVA_OPTS="-server -Xmx1G -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:FlightRecorderOptions=defaultrecording=true,disk=true,maxsize=1G,compress=true,settings=$JAVA_HOME/jre/lib/jfr/profile.jfc,dumponexit=true,dumponexitpath=/data/jfr/tomcat_$CURDATE.jfr -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
```
`/data/jfr/`这个要先mkdir

这个要放在JAVA_OPTS前面
```
CURDATE=`date +%Y-%m-%d_%H_%M_%S`
```

1. 引言
最近1年多的时间，因为需要排查线上应用出现的性能问题，会借助一些工具如JProfiler、Yourkit，但是这些工具都具有商业性质，使用时难免受到限制。后来发现Oracle Jdk(version>=7u40)中自带了一个Java Mission Control(以下简称JMC)的应用，也可以实现JVM的监控。
另外，与JProfiler等使用JVMPI/JVMTI方式实现的工具不同，JMC使用了JVM内部特定的基于事件的接口，几乎不会给应用造成额外的压力（默认设置下，对性能影响小于1%），因此可以用在负载很高的生产环境中。
本文就来简单介绍一下使用JMC来监测JVM性能。
注意：需要下载Oracle Jdk 7u40以后的版本，OpenJdk无效，切记！

2. 目标JVM配置
在被监控的JVM（目标JVM）上需要开启以下Java Options才能对其进行监控，对于Tomcat来说，在JAVA_OPTS或CATALINA_OPTS中加入以下代码即可：
```
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
-Djava.rmi.server.hostname=192.168.32.11
-Dcom.sun.management.jmxremote.port=7777
-Dcom.sun.management.jmxremote
-XX:+UnlockCommercialFeatures
-XX:+FlightRecorder
```

java.rmi.server.hostname：如果要允许其它机器监控该程序，必须设定，否则就只能在本机监控该程序。
com.sun.management.jmxremote：启用JMX远程监控。
com.sun.management.jmxremote.port：JMX远程监控的端口。
com.sun.management.jmxremote.ssl：将此配置设置为 true 时，将使用服务器证书通过 SSL 来保护通信。
com.sun.management.jmxremote.authenticate：是否开启权限控制，如果设置为true，需要指定两个文件：jmxremote.password和jmxremote.access，password文件主要是配置用户名和密码，access主要是配置权限（可读或者读写）。
在Tomcat的bin目录下增加下面两个文件：jmxremote.password和jmxremote.access，格式如下：
```
jmxremote.access：
admin readwrite \
  create com.sun.management.*,com.oracle.jrockit.* \
  unregister
monitor readonly
```

表示admin有操作权限（比如调用GC等操作），monitor只有查看权限，不能进行任何操作。
```
jmxremote.password：
admin test
monitor test    
```

表示有两个用户，admin和monitor，密码分别是test和test。
-XX:+UnlockCommercialFeatures：开启商业特性，默认这个选项是关闭的。
-XX:+FlightRecorder：开启飞行记录器。
上述参数配置完毕，重新启动tomcat即可。


<https://cyberdak.github.io/2016/03/25/tomcat-jmx-flight-recorder>
<http://fengfu.io/2016/05/20/%E6%80%A7%E8%83%BD%E8%B0%83%E4%BC%98%E5%B7%A5%E5%85%B7-Java-Mission-Control/>


#### 我的catalina.sh
```
CURDATE=`date +%Y-%m-%d_%H_%M_%S`
# JAVA_OPTS=" -server -Xmx1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200"settings=$JAVA_HOME/jre/lib/jfr/profile.jfc,
JAVA_OPTS="$JAVA_OPTS -XX:+UnlockCommercialFeatures"
JAVA_OPTS="$JAVA_OPTS -XX:+FlightRecorder"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=172.16.0.229"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=7777"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote"
JAVA_OPTS="$JAVA_OPTS -XX:+UnlockCommercialFeatures"
JAVA_OPTS="$JAVA_OPTS -XX:+FlightRecorder"
JAVA_OPTS="$JAVA_OPTS -XX:FlightRecorderOptions=defaultrecording=true,disk=true,maxsize=1G,dumponexit=true,dumponexitpath=/data/jfr/pyq_jfr_$CURDATE.jfr"
```