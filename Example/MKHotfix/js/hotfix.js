fixInstanceMethodReplace("TestClass", "testStringInOut:", function(instance, originInvocation, originArguments) {
    console.log("testStringInOut args = " + originArguments);
    return "修复返回值";
});

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

fixInstanceMethodReplace("TestClass", "testNSIntegerInOut:", function(instance, originInvocation, originArguments) {
    console.log("testNSIntegerInOut args = " + originArguments);
    /// 修改原函数入参后,再执行原函数逻辑
    var a1 = originArguments[0];
    if (a1 === 1) {
        return 2; /// 如果参数是1, 则直接修改返回值为固定值
    } else {
        return runInvocation(originInvocation); /// 参数非1, 执行原函数逻辑
    }
});

fixInstanceMethodReplace("TestClass", "testBoolInOut:", function(instance, originInvocation, originArguments) {
    console.log("testBoolInOut args = " + originArguments);
    setInvocationParameter(originInvocation, true, 0);
    var originRes = runInvocation(originInvocation);
    console.log("testBoolInOut originRes = " + originRes);
    return originRes; /// 将结果返回到业务调用处
})

fixInstanceMethodReplace("TestClass", "testCharInOut:", function(instance, originInvocation, originArguments) {
    console.log("testCharInOut args = " + originArguments);
    setInvocationParameter(originInvocation, 'b', 0);
    var originRes = runInvocation(originInvocation);
    console.log("testCharInOut originRes = " + originRes);
    return originRes;
})

fixInstanceMethodReplace("TestClass", "testLongInOut:", function(instance, originInvocation, originArguments) {
    console.log("testLongInOut args = " + originArguments);
    setInvocationParameter(originInvocation, 2, 0);
    var originRes = runInvocation(originInvocation);
    console.log("testLongInOut originRes = " + originRes);
    return originRes;
});

fixInstanceMethodReplace("TestClass", "testDoubleInOut:", function(instance, originInvocation, originArguments) {
    console.log("testDoubleInOut args = " + originArguments);
    setInvocationParameter(originInvocation, 2, 0);
    var originRes = runInvocation(originInvocation);
    console.log("testDoubleInOut originRes = " + originRes);
    return originRes;
});

fixInstanceMethodReplace("TestClass", "testShortInOut:", function(instance, originInvocation, originArguments) {
    console.log("testShortInOut args = " + originArguments);
    setInvocationParameter(originInvocation, 2, 0);
    var originRes = runInvocation(originInvocation);
    console.log("testShortInOut originRes = " + originRes);
    return originRes;
});

fixInstanceMethodReplace("TestClass", "testClassInOut:", function(instance, originInvocation, originArguments) {
    console.log("testClassInOut args = " + originArguments);
    setInvocationParameter(originInvocation, 'TestClass', 0);
    var originRes = runInvocation(originInvocation);
    console.log("testClassInOut originRes = " + originRes);
    return originRes;
});

fixInstanceMethodReplace("TestClass", "testNSDictionaryInOut:", function(instance, originInvocation, originArguments) {
    console.log("testNSDictionaryInOut args = " + originArguments);
    setInvocationParameter(originInvocation, {"a":"JS值"}, 0);
    var originRes = runInvocation(originInvocation);
    console.log("testNSDictionaryInOut originRes = " + originRes);
    return originRes;
});

fixInstanceMethodReplace("TestClass", "testArrayInOut:", function(instance, originInvocation, originArguments) {
    console.log("testArrayInOut args = " + originArguments);
    setInvocationParameter(originInvocation, ["JS值"], 0);
    var originRes = runInvocation(originInvocation);
    console.log("testArrayInOut originRes = " + originRes);
    return originRes;
});

