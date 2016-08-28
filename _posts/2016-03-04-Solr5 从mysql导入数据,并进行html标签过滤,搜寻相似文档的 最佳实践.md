---
layout: post
title: "Solr5 从mysql导入数据,并进行html标签过滤,搜寻相似文档的 最佳实践"
date: 2016-03-04
description: Solr5从mysql导入数据,并进行html标签过滤,搜寻相似文档的最佳实践
-tags:
 - Solr
 - java
---

# 准备工作

## Solr5.5
从[solr主页](http://lucene.apache.org/solr/)中获取对应系统的最新版本的solr(写此文时时5.5)解压即可, 无需安装
## mysqlImporter - 从mysql导入数据
先下载mysql-connector-java的jar包, [下载地址](http://dev.mysql.com/downloads/connector/j/)

将其放到solr目录下的contrib/dataimporthander/lib/目录下

## mmseg4j - 中文分词器
下载最新版本的mmseg4j, 可以到其作者的github中相应的项目地址下载, [链接](https://github.com/chenlb)

将其放到solr目录下的contrib/extraction/lib/目录下

##配置文件
**在solr的"./server/solr/configsets/"目录下可以看到几个configs的例子, 这里我们复制一个"basic_configs"例子, 给他重命名为你希望的名字. 这里我们给他起为victoriest, 进入这个victoriest/conf目录后, 我们就要进行一系列的配置文件的修改了**

* ##### 进行mysql数据导入相关配置
在solrconfig.xml文件中, 加入如下配置:
```xml
<lib dir="${solr.install.dir:../../../..}/contrib/dataimporthandler/lib" regex=".*\.jar" />
<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-\d.*\.jar" />
```

* ##### 进行mmseg4j相关配置
同样是在solrconfig.xml文件中, 加入配置:
    ```xml
  	<lib dir="${solr.install.dir:../../../..}/contrib/extraction/lib" regex=".*\.jar" />
  	<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-cell-\d.*\.jar" />
    ```

    * ##### 配置mysql数据导入的requestHandler
    在solrconfig.xml文件中, 加入:
    ```xml
      <requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler">
        <lst name="defaults">
        <str name="config">data-config.xml</str>
      </lst>
     </requestHandler>
    ```
	其中, data-config.xml文件是需要我们手动在solrconfig.xml中新建的, 内容如下:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <dataConfig>
        <dataSource type="JdbcDataSource" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://[数据库ip]:[端口号]/[数据库schame]" user="[用户名]" password="[密码]" />
      <document name="testVictoriest">
            <entity name="t_name" transformer="HTMLStripTransformer"
                 query="SELECT COL1, COL2, COL3, UPDATE_TIME FROM T_NAME"
                 deltaImportQuery="select COL1, COL2, COL3, UPDATE_TIME FROM T_NAME where COL1='${dataimporter.delta.COL1}'"
                 deltaQuery="select  COL1, COL2, COL3, UPDATE_TIME FROM T_NAME where UPDATE_TIME >'${dataimporter.last_index_time}'">
                <field column="COL1" name="col1"/>
                <field column="COL2" name="col2" stripHTML="true"/>
                <field column="COL3" name="col3"/>
                <field column="UPDATE_TIME" name="updateTime"/>
         </entity>
        </document>
    </dataConfig>
    ```
    其中:
    dataSource为数据库连接的相关配置;
    document为生成文档的相关配置;
    query为初始化导入数据时所引用的sql语句
    deltaQuery为增量导入数据是得查询语句
    deltaImportQuery为增量导入时的插入查询语句
    field为数据索引项, column对应数据库字段, name对应schema.xml中定义的field名

    * ##### 建立配置文件schema.xml
    在solrconfig.xml同级目录下, 没有schema.xml文件, 我们可以将managed-schema文件重命名为schema.xml

    * ##### 中文分词相关配置
    在schema.xml文件中, 加入如下配置:
    ```xml
    <fieldType name="text_mmseg4j_complex" class="solr.TextField" positionIncrementGap="100" >
    <analyzer>
        <tokenizer class="com.chenlb.mmseg4j.solr.MMSegTokenizerFactory" mode="simple" dicPath="J:\solr-5.5.0\server\solr\victoriest\conf"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="words.dic" />
      </analyzer>
    </fieldType>
    <fieldType name="text_mmseg4j_maxword" class="solr.TextField" positionIncrementGap="100" >
          <analyzer>
            <charFilter class="solr.HTMLStripCharFilterFactory" />
            <tokenizer class="com.chenlb.mmseg4j.solr.MMSegTokenizerFactory" mode="max-word" dicPath="J:\solr-5.5.0\server\solr\victoriest\conf"/>
            <filter class="solr.StopFilterFactory" ignoreCase="true" words="words.dic" />
          </analyzer>
    </fieldType>
    <fieldType name="text_mmseg4j_simple" class="solr.TextField" positionIncrementGap="100" >
          <analyzer>
            <tokenizer class="com.chenlb.mmseg4j.solr.MMSegTokenizerFactory" mode="simple" dicPath="J:\solr-5.5.0\server\solr\victoriest\conf"/>
            <filter class="solr.StopFilterFactory" ignoreCase="true" words="words.dic" />
          </analyzer>
    </fieldType>
    ```
	其中 filter中指定的words.dic就是分词字典文件, 可以在mmseg4j-core的jar包中找到, 解压到此目录中, 并将tokenizer的dicPath属性指定到该目录
    * ##### 自定义字段配置
    在schema.xml中, 添加:
    ```xml
    <field name="col1" type="text_mmseg4j_maxword" indexed="true" stored="true" required="true"/>
    <field name="col2" type="text_mmseg4j_maxword" indexed="true" stored="true" termVectors="true"/>
    <field name="col3" type="text_mmseg4j_maxword" indexed="true" stored="true"/>
    <field name="updateTime" type="date" indexed="true" stored="true"/>
    <uniqueKey>col1</uniqueKey>
    ```
这里我们分别定义了4个field, 其中name就是与data-config.xml中field的name相对应, 而type就是我们刚刚定义的中文分词的filedType; 另外, 我们将col1定义为标识列, 所以给col1添加了属性`required="true"`, 并添加了一个`<uniqueKey>col1</uniqueKey>`标签


* ###测试运行一下

	* ##### 启动solr
	将我们上面建立的victoriest配置复制到solr中的server\solr\目录下;
	在终端中进入solr中的bin目录下, 启动solr:`solr start`;
    启动后, 可以通过浏览器访问http://localhost:8983/solr, 可以看到如下界面:
    <img src="./images/20160304105834.jpg"/>

	在name和instanceDir中输入victoriest(也就是我们实例的名字), 点击Add Core按钮就会创建一个该名字的实例

    * ##### 初始化数据导入
    如图 选择 full-import, 然后点击Execute按钮
    之后就会初始化索引, 初始化索引的过程中, 可以点击Refresh Status查看索引的进度:
    <img src="./images/20160304110600.jpg"/>

    * ##### 增量数据导入
    如图, 与 full-import相似, 但是请注意图中红框标注出来的选项变化:
    <img src="./images/20160304111223.jpg"/>

    * ##### 通过控制台查询文档
    可以在控制台中的Query进行查询, 如图:
    <img src="./images/20160304112305.jpg"/>

    * #####通过url进行查询访问
    另外也可以通过url进行查询访问, 详细参考文档:[http://blog.javachen.com/2014/03/03/solr-query-syntax.html](http://blog.javachen.com/2014/03/03/solr-query-syntax.html)


* ###添加额外功能

    * ##### 去除html标签
	在某些场景中, 我们可能从数据库查询出来的数据是个html文档, 其中包含大量html的标签等无用的信息. solr提供了一些工具组件用来过滤这些无用的html标签. 其配置如下:

    1. 在数据库的读取文件data-config.xml 中的entity标记里边添加 transformer=”HTMLStripTransformer” 代码;

    2. 同样是data-config.xml文件中, 在field 字段需要过滤html代码的字段添加stripHTML=”true”;

    3. 修改schema.xml文件中的fieldType标记中的内容，添加:
    ```xml
    <charFilter class=”solr.HTMLStripCharFilterFactory” />
    ```
    以上相关配置在前面的给出的xml配置例子中都可以找到

    * ##### moreLikeThis组件使用
	使用MoreLikeThis组件可以给出查询结果的近似结果, 典型的应用场景如: 在文档库中, 给定文档id, 找到该与文档相似或雷同的文档;
    在solrconfig.xml中, 添加如下配置项:
    ```xml
    <requestHandler name="/mlt" class="solr.MoreLikeThisHandler">
        <lst name="defaults">
            <str name="mlt.fl">questionContext</str>
            <str name="mlt.mintf">1</str>
            <str name="mlt.minwl">2</str>
            <int name="rows">5</int>
        </lst>
    </requestHandler>
    ```
    另外，在schema.xml配置中, 在希望引入MoreLikeThis搜索结果的filed标签内添加属性:`termVectors="true"`; 如上面例子中的filed:col2

    其中的参数, 可以参考如下连接:
	[https://cwiki.apache.org/confluence/display/solr/MoreLikeThis](https://cwiki.apache.org/confluence/display/solr/MoreLikeThis)
 	[http://www.cnblogs.com/a198720/p/4016052.html](http://www.cnblogs.com/a198720/p/4016052.html)

	* ##### mlt查询调用
	如若需要在查询结果中获取相似文档的内容, 则需要通过/mlt进行查询:
    <img src="./images/20160304112305.jpg"/>

    其查询条件语法与普通的/select查询相似, 也可通过url访问查询, 其特有参数可以参考:[http://www.cnblogs.com/a198720/p/4016052.html](http://www.cnblogs.com/a198720/p/4016052.html)

