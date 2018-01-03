---
layout: post
title: 记一则mysql抛出Lock wait timeout exceeded; try restarting transaction异常的离奇事件(未解决)
date: 2017-10-24
description: 记一则mysql抛出Lock wait timeout exceeded; try restarting transaction异常的离奇事件(未解决)
excerpt_separator: <!--more-->
---

一直以来, 数据库方面的东西对我来说是个黑盒子, 期望将问题留给DBA解决. 不过, 近日, 在我的项目上突然在没有任何负载的情况下经常抛出出Lock wait timeout exceeded; try restarting transaction异常. 而迫使我慢慢了解数据库问题排查方面的套路.

我们的服务器环境是一个centos的虚拟机, 其上安装了mysql5.6, 我们的java服务器程序, 另外, 我们是与公司的另外两个产品共用的同一台虚拟机.

通过mysql的`select * from information_schema.innodb_trx;`查询发现, 有一个事务状态一直是running, 没有锁表, 没有查询语句. `SELECT * FROM information_schema.innodb_locks;`与`SELECT * FROM information_schema.innodb_lock_waits;` 也都没有查出数据. 

通过查询资料:<http://blog.csdn.net/mchdba/article/details/39459347>, 根据其描述的步骤:
* 通过`select * from INNODB_TRX\G;`或`select * from information_schema.innodb_trx;`查询正在running的`trx_mysql_thread_id`.
* 通过`trx_mysql_thread_id`去查询`information_schema.processlist`找到执行事务的客户端请求的SQL线程
* 通过SQL线程, 找到应用程序的IP地址以及端口
* 进入应用服务器, 通过netstat检索端口找到正在运行的应用工程的PID

```
netstat -nlatp |grep 23452
tcp        0      0 ::ffff:10.xx.3.2x:23452    ::ffff:10.xx4.3.x1:3306     ESTABLISHED 12059/java          

ps -eaf|grep 12059
```

通过以上步骤就可以确定是那个程序调用的mysql出现的running的事务.

但是通过调查, 并没有发现异常日志, 以及可疑的地方. 

另外, 我也彻底排查了一下程序中的sql语句的问题, 基本排除由于程序逻辑导致未提交事务产生. 

调查陷入了死胡同. 而此时发现, 与我们的服务器程序公用一台虚拟机的其他程序cpu占用异常高, 导致服务器经常卡顿. 联系了运维后发现, 服务器虚拟机资源已耗尽. 重启服务器, 将我们的服务器程序独立出来后, 暂时未出现running的事务. 此持续跟踪中....

#### 调查中参考资料

<http://keithlan.github.io/2017/06/05/innodb_locks_1/>
<http://blog.csdn.net/mchdba/article/details/39459347>

```

-- innodb_trx  ## 当前运行的所有事务
select * from information_schema.innodb_trx;

desc information_schema.innodb_trx;
+----------------------------+---------------------+------+-----+---------------------+-------+
| Field | Type | Null | Key | Default | Extra |
+----------------------------+---------------------+------+-----+---------------------+-------+
| trx_id | varchar(18) | NO | | | |#事务ID
| trx_state | varchar(13) | NO | | | |#事务状态：
| trx_started | datetime | NO | | 0000-00-00 00:00:00 ||#事务开始时间；
| trx_requested_lock_id | varchar(81) | YES | | NULL ||#innodb_locks.lock_id
| trx_wait_started | datetime | YES | | NULL | |#事务开始等待的时间
| trx_weight | bigint(21) unsigned | NO | | 0 | |#
| trx_mysql_thread_id | bigint(21) unsigned | NO | | 0 ||#事务线程ID
| trx_query | varchar(1024) | YES | | NULL | |#具体SQL语句
| trx_operation_state | varchar(64) | YES | | NULL ||#事务当前操作状态
| trx_tables_in_use | bigint(21) unsigned | NO | | 0 ||#事务中有多少个表被使用
| trx_tables_locked | bigint(21) unsigned | NO | | 0 ||#事务拥有多少个锁
| trx_lock_structs | bigint(21) unsigned | NO | | 0 | |#
| trx_lock_memory_bytes | bigint(21) unsigned | NO | | 0 ||#事务锁住的内存大小（B）
| trx_rows_locked | bigint(21) unsigned | NO | | 0 ||#事务锁住的行数
| trx_rows_modified | bigint(21) unsigned | NO | | 0 ||#事务更改的行数
| trx_concurrency_tickets | bigint(21) unsigned | NO | | 0 ||#事务并发票数
| trx_isolation_level | varchar(16) | NO | | | |#事务隔离级别
| trx_unique_checks | int(1) | NO | | 0 | |#是否唯一性检查
| trx_foreign_key_checks | int(1) | NO | | 0 | |#是否外键检查
| trx_last_foreign_key_error | varchar(256) | YES | | NULL ||#最后的外键错误
| trx_adaptive_hash_latched | int(1) | NO | | 0 | |#
| trx_adaptive_hash_timeout | bigint(21) unsigned | NO | | 0 ||#
+----------------------------+---------------------+------+-----+---------------------+-------+


-- innodb_locks ## 当前出现的锁
SELECT * FROM information_schema.innodb_locks;
desc information_schema.innodb_locks;
+-------------+---------------------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------------+---------------------+------+-----+---------+-------+
| lock_id | varchar(81) | NO | | | |#锁ID
| lock_trx_id | varchar(18) | NO | | | |#拥有锁的事务ID
| lock_mode | varchar(32) | NO | | | |#锁模式
| lock_type | varchar(32) | NO | | | |#锁类型
| lock_table | varchar(1024) | NO | | | |#被锁的表
| lock_index | varchar(1024) | YES | | NULL | |#被锁的索引
| lock_space | bigint(21) unsigned | YES | | NULL | |#被锁的表空间号
| lock_page | bigint(21) unsigned | YES | | NULL | |#被锁的页号
| lock_rec | bigint(21) unsigned | YES | | NULL | |#被锁的记录号
| lock_data | varchar(8192) | YES | | NULL | |#被锁的数据
+-------------+---------------------+------+-----+---------+-------+


-- innodb_lock_waits ## 锁等待的对应关系
SELECT * FROM information_schema.innodb_lock_waits;

desc information_schema.innodb_lock_waits;
+-------------------+-------------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------------------+-------------+------+-----+---------+-------+
| requesting_trx_id | varchar(18) | NO | | | |#请求锁的事务ID
| requested_lock_id | varchar(81) | NO | | | |#请求锁的锁ID
| blocking_trx_id | varchar(18) | NO | | | |#当前拥有锁的事务ID
| blocking_lock_id | varchar(81) | NO | | | |#当前拥有锁的锁ID
+-------------------+-------------+------+-----+---------+-------+


show full processlist;

show open tables;

show status like '%lock%';

show engine innodb status;

show open tables where in_use>0;

select @@autocommit;

SELECT @@GLOBAL.tx_isolation, @@tx_isolation;

select connection_id();

show variables like '%wait_timeout%';

show variables like '%tx_isolation%';

show status like 'innodb_row_lock%';

-- 解释如下：
-- Innodb_row_lock_current_waits : 当前等待锁的数量
-- Innodb_row_lock_time : 系统启动到现在，锁定的总时间长度
-- Innodb_row_lock_time_avg : 每次平均锁定的时间
-- Innodb_row_lock_time_max : 最长一次锁定时间
-- Innodb_row_lock_waits : 系统启动到现在总共锁定的次数

```