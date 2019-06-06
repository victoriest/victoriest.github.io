---
layout: post
title: 客户端软件架构nodejs+edgejs+electron调查报告
date: 2017-02-02
description: 客户端软件架构nodejs+edgejs+electron调查报告
tags:
 - js
 - nodejs
 - electron
excerpt_separator: <!--more-->
---
# 概述
随着扫描客户端功能与算法趋于稳定. 可以预见, 今后会有越来越多关于交互方式/UI样式/个性化方面的需求. 
然而当前客户端使用的架构为单纯的windowsform. 虽然有开发快速, 上手简单的优点; 但缺点是界面单调, 个性化外观定制较难实现. 

故需要寻找一套上手门槛低, 方便进行样式调整/个性化定制的客户端架构, nodejs+edgejs+electron便是备选方案之一.

以下便为该架构的调查报告

# 准备
### 需要工具
 * [node.js](https://nodejs.org/en/)
 * [electron](http://electron.atom.io/)
 * [edge.js](http://tjanczuk.github.io/edge/)
 * [electron-edge](https://github.com/kexplo/electron-edge)

electron的安装容易在运行install.js时卡住. 
解决的方法就是在~/.npmrc里做如下设置 
```
electron_mirror="https://npm.taobao.org/mirrors/electron/"
```

electron不能直接利用edge.js调用.net的dll, 需要用electron-edge

# 调查

## 实现

### c#部分实现
```csharp
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TestEdgeForNodejs
{
    public class HelloWorld
    {
        public async Task<object> HelloWorldMessage(object input)
        {
            MessageBox.Show("Hello " + input);
            return input;
        }
    }

}

```
利用IDE VS生成dll, 拷贝到electron工程所在的目录中.

### js部分实现

main.js

```javascript
const edge = require('electron-edge');
const electron=require("electron");
const app=electron.app;
const BrowserWindow=electron.BrowserWindow;

// 声明要引用的dll中的方法
var helloWorld = edge.func({
    assemblyFile: './TestEdgeForNodejs.dll',	// dll路径
    typeName: 'TestEdgeForNodejs.HelloWorld',	// namespace.class
    methodName: 'HelloWorldMessage'				// method
});

function createWindow(){
    mainWindow=new BrowserWindow({
        width:300,
        height:300
    });

    mainWindow.loadURL('file://'+__dirname+'/index.html'); 

    mainWindow.on("closed",function(){
        mainWindow = null;
    });
}

app.on("ready",createWindow);

app.on("window-all-closed",function(){
    if(process.platform!="darwin"){
        app.quit();
    }
});

app.on("activate",function(){
    if(mainWindow===null){
        createWindow();
    }
});

// 调用dll中的HelloWorldMessage方法
function callHelloWorld() {
    helloWorld("World", function (error, result) {
        console.log(result);
    });
}

```

index.html

```html
<!DOCTYPE html>

<html>
    <head>
        <meta charset="utf-8">
        <title>Victoriest Demo Apps</title>
    </head>

    <body>
        <div id="content">
            estest
            <input type="button" onclick="callHelloWorld();">
        </div>

        <script src="./main.js"></script>
    </body>
</html>
```

### 运行
在命令行中, 进入electron工程所在的目录.
```
electron .
```

### 数据通讯
通过edge-electron可以进行双向的数据传递[https://github.com/kexplo/electron-edge/blob/electron_v1.4.4/samples/108_func.js](https://github.com/kexplo/electron-edge/blob/electron_v1.4.4/samples/108_func.js)

### 不足
到目前为止, 还没有找到类似于在electron中监听c#dll中发出的event的方法. 而目前客户端代码中大量使用了这种形式来控制UI显示状态, 如若转换架构, 涉及到修改重构的代码量会比较大.

### 阶段性结论
在找到能够监听c#dll发出的event的方法(或等价方法)前, 暂不考虑此方案. 
<!--more-->
