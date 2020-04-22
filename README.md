# MKHotfix

![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)

轻量JS热修工具

## Installation

```ruby
pod 'MKHotfix'
pod 'Aspects' 
```
* Aspects库是依赖


## Example

#### 热修功能

* 类函数 执行前/后添加切面函数和替换类函数
* 实例 函数执行前/后添加切面函数和替换实例函数
* 修改 类/实例 函数的入参和返回值
* 执行 类/实例 函数

#### 能力简介

```
fixInstanceMethodReplace("TestClass", "testIntInOut:", function(instance, originInvocation, originArguments) {
    /**
     * instance: 函数执行的实例
     * originInvocation: 原函数
     * originArguments: 原参数
     */
    /**
     * 可在此处进行修复逻辑的处理, originArguments[index], 取出原参数
     */
    console.log("testStringInOut args = " + originArguments);
    /// setInvocationParameter(originInvocation, $value, $index), 可更新函数入参
    setInvocationParameter(originInvocation, 4, 0);
    /// 更改入参后, 执行原函数, 拿到原函数返回结果
    var originRes = runInvocation(originInvocation);
    console.log("testStringInOut originRes = " + originRes);
    return originRes; /// 将结果返回到业务调用处
});
```

其他能力参见Demo

```
.
├── MKHotfix
│   ├── Demo
│   │   ├── TestClass.h : 样例修复的目标类
│   │   └── TestClass.m
│   ├── MKViewController.h : 业务执行类
│   ├── MKViewController.m
└────── js
        └── hotfix.js : 修复脚本
```

#### 下发热修脚本

* 针对不同的App版本和系统版本由自己的服务端下发
* Bugly下发
