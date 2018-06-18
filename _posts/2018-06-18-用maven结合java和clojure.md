---
layout: post
title: 用maven结合java和clojure
date: 2018-06-18
description: 用maven结合java和clojure
excerpt_separator: <!--more-->
---

1. 添加maven的dependencies

```xml
<dependencies>
  <dependency>
    <groupId>org.clojure</groupId>
    <artifactId>clojure</artifactId>
    <version>1.7.0</version>
  </dependency>
  <dependency>
    <groupId>org.clojure</groupId>
    <artifactId>clojure-contrib</artifactId>
    <version>1.2.0</version>
  </dependency>
  <dependency>
    <groupId>incanter</groupId>
    <artifactId>incanter</artifactId>
    <version>1.9.0</version>
  </dependency>
  <dependency>
    <groupId>org.clojure</groupId>
    <artifactId>tools.nrepl</artifactId>
    <version>0.2.10</version>
  </dependency>
 <!-- pick your poison swank or cider. just make sure the version of nRepl matches. -->
  <dependency>
    <groupId>cider</groupId>
    <artifactId>cider-nrepl</artifactId>
    <version>0.10.0-SNAPSHOT</version>
  </dependency>
  <dependency>
    <groupId>swank-clojure</groupId>
    <artifactId>swank-clojure</artifactId>
    <version>1.4.3</version>
  </dependency>
</dependencies>
```

2. 添加maven的plugin

```xml
            <plugin>
                <groupId>com.theoryinpractise</groupId>
                <artifactId>clojure-maven-plugin</artifactId>
                <version>1.8.1</version>
                <extensions>true</extensions>
                <configuration>
                    <sourceDirectories>
                        <sourceDirectory>src/main/clojure</sourceDirectory>
                    </sourceDirectories>
                    <testSourceDirectories>
                        <testSourceDirectory>test/main/clojure</testSourceDirectory>
                    </testSourceDirectories>
                    <!--<warnOnReflection>false</warnOnReflection>-->
                    <!--<copyDeclaredNamespaceOnly>true</copyDeclaredNamespaceOnly>-->
                    <copiedNamespaces>
                        <copiedNamespace>none</copiedNamespace>
                    </copiedNamespaces>
                </configuration>
                <executions>
                    <execution>
                        <id>compile-clojure</id>
                        <phase>compile</phase>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>test-clojure</id>
                        <phase>test</phase>
                        <goals>
                            <goal>test</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
```

3. 我的clojure test 代码

```clojure
(ns com.wenduing.app.test)
(defn hello [str] (println str ",hello world"))
```

4. 我的java测试代码

```java
// 方式1
        IFn require = Clojure.var("clojure.core", "require");
        require.invoke(Clojure.read("com.wenduing.app.test"));
        IFn hello = Clojure.var("com.wenduing.app.test", "hello");
        hello.invoke("victoriest");

        RT.loadResourceScript("com/wenduing/app/test.clj");


// 方式2

        // Get a reference to the hello function
        Var foo = RT.var("clj.test", "hello");

        // Call it!
        Object result = foo.invoke("World!");
```

5. 参考

<https://joelholder.com/2015/10/23/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/>

<https://clojurefun.wordpress.com/2012/12/24/invoking-clojure-code-from-java/>

<!--more-->
