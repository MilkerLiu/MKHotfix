//
//  HotFix.m
//  HotFix
//
//  Created by milker on 2020/04/21.
//  Copyright © 2020年 milker. All rights reserved.
//

#import "MKHotfix.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Aspects.h"

static MKHotfix *fixManager = nil;

@interface MKHotfix()

@property(nonatomic, copy)JSContext *context;

@end

@implementation MKHotfix

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fixManager = [[MKHotfix alloc] init];
    });
    return fixManager;
}
- (instancetype)init {
    if(self = [super init]) {
        [self setup];
    }
    return self;
}

- (JSContext *)context {
    if(!_context) {
        _context = [[JSContext alloc] init];
        _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"Ohooo: %@",exception);
        };
    }
    return _context;
}

- (void)fixWithJS:(NSString *)js {
    if (!js) {return;}
    [self.context evaluateScript:js];
}

- (void)fixWithFileName:(NSString *)fileName {
    NSString *js = [self readFileAsObj:fileName];
    [self fixWithJS:js];
}

- (void)fixWithFilePath:(NSString *)filePath {
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self fixWithJS:js];
}

- (NSString *)readFileAsObj:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)fixWithMethod:(BOOL)isClassMethod aspectionOptions:(AspectOptions)option instanceName:(NSString *)instanceName selectorName:(NSString *)selectorName fixImpl:(JSValue *)fixImpl {
    Class klass = NSClassFromString(instanceName);
    if (isClassMethod) {
        klass = object_getClass(klass);
    }
    SEL sel = NSSelectorFromString(selectorName);
    [klass aspect_hookSelector:sel withOptions:option usingBlock:^(id<AspectInfo> aspectInfo){
        JSValue *returnV = [fixImpl callWithArguments:@[aspectInfo.instance, aspectInfo.originalInvocation, aspectInfo.arguments]];
        if (aspectInfo.originalInvocation.methodSignature.methodReturnLength > 0) {
            [self setReturnValue:aspectInfo.originalInvocation value:returnV];
        }
    } error:nil];
}

- (id)runClassWithClassName:(NSString *)className selector:(NSString *)selector obj1:(id)obj1 obj2:(id)obj2 {
    Class klass = NSClassFromString(className);
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [klass performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
    #pragma clang diagnostic pop
}

- (id)runInstanceWithInstance:(id)instance selector:(NSString *)selector obj1:(id)obj1 obj2:(id)obj2 {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [instance performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
    #pragma clang diagnostic pop
}
- (void)setup {
    __weak typeof(self) wkself = self;
    self.context[@"fixInstanceMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:NO aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"fixInstanceMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:NO aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"fixInstanceMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:NO aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"fixClassMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:YES aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"fixClassMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:YES aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"fixClassMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [wkself fixWithMethod:YES aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    [self context][@"runClassWithNoParamter"] = ^id(NSString *className, NSString *selectorName) {
        return [wkself runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
    };
    [self context][@"runClassWith1Paramter"] = ^id(NSString *className, NSString *selectorName, id obj1) {
        return [wkself runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
    };
    [self context][@"runClassWith2Paramters"] = ^id(NSString *className, NSString *selectorName, id obj1, id obj2) {
        return [wkself runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
    };
    [self context][@"runVoidClassWithNoParamter"] = ^(NSString *className, NSString *selectorName) {
        [wkself runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
    };
    [self context][@"runVoidClassWith1Paramter"] = ^(NSString *className, NSString *selectorName, id obj1) {
        [wkself runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
    };
    [self context][@"runVoidClassWith2Paramters"] = ^(NSString *className, NSString *selectorName, id obj1, id obj2) {
        [wkself runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
    };
    [self context][@"runInstanceWithNoParamter"] = ^id(id instance, NSString *selectorName) {
        return [wkself runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
    };
    [self context][@"runInstanceWith1Paramter"] = ^id(id instance, NSString *selectorName, id obj1) {
        return [wkself runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
    };
    [self context][@"runInstanceWith2Paramters"] = ^id(id instance, NSString *selectorName, id obj1, id obj2) {
        return [wkself runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
    };
    [self context][@"runVoidInstanceWithNoParamter"] = ^(id instance, NSString *selectorName) {
        [wkself runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
    };
    [self context][@"runVoidInstanceWith1Paramter"] = ^(id instance, NSString *selectorName, id obj1) {
        [wkself runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
    };
    [self context][@"runVoidInstanceWith2Paramters"] = ^(id instance, NSString *selectorName, id obj1, id obj2) {
        [wkself runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
    };
    [self context][@"runInvocation"] = ^id(NSInvocation *invocation) {
        [invocation invoke];
        if (invocation.methodSignature.methodReturnLength) {
            return [self getReturnValue:invocation];
        }
        return nil;
    };
    [self context][@"setInvocationParameter"] = ^(NSInvocation *invocation, id value, NSInteger index) {
        [self setArgument:invocation value:value index:index + 2];
        [invocation retainArguments];
    };
    [[self context] evaluateScript:@"var console = {}"];
    [self context][@"console"][@"log"] = ^(id message) {
        NSLog(@"HotFix-JS-Log: %@",message);
    };
}

// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

- (void)setReturnValue:(NSInvocation *)invocation value:(JSValue *)v {
    const char *type = invocation.methodSignature.methodReturnType;
    if (!strcmp(type, @encode(float))) {
        float rv = [v.toNumber floatValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(BOOL))) {
        BOOL rv = [v.toNumber boolValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(int)) || !strcmp(type, @encode(unsigned int))) {
        int rv = [v.toNumber intValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(long)) || !strcmp(type, @encode(unsigned long))) {
        long rv = [v.toNumber longValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(short)) || !strcmp(type, @encode(unsigned short))) {
        short rv = [v.toNumber shortValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(char)) || !strcmp(type, @encode(unsigned char))) {
        char rv = [v.toNumber charValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(long long)) || !strcmp(type, @encode(unsigned long long))) {
        long long rv = [v.toNumber longLongValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(double))) {
        double rv = [v.toNumber doubleValue];
        [invocation setReturnValue:&rv];
    } else if (!strcmp(type, @encode(Class))) {
        Class clazz;
        if (v.isString) {
            clazz = NSClassFromString(v.toString);
        } else {
            clazz = v.toObject;
        }
        [invocation setReturnValue:&clazz];
    } else /*if (!strcmp(type, @encode(id)))*/ {
        id rv = [v toObject];
        [invocation setReturnValue:&rv];
    } /*else if (!strcmp(type, @encode(Class))) {
        Class rv = [v toObject];
        [invocation setReturnValue:&rv];
    }*/
}

- (void)setArgument:(NSInvocation *)invocation value:(id)v index:(NSInteger)index {
    const char *type = [invocation.methodSignature getArgumentTypeAtIndex:index];
    if (!strcmp(type, @encode(float))) {
        if ([v isKindOfClass:NSNumber.class]) {
            float rv = [(NSNumber *)v floatValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(BOOL))) {
        if ([v isKindOfClass:NSNumber.class]) {
            BOOL rv = [(NSNumber *)v boolValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(int)) || !strcmp(type, @encode(unsigned int))) {
        if ([v isKindOfClass:NSNumber.class]) {
            int rv = [(NSNumber *)v intValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(long)) || !strcmp(type, @encode(unsigned long))) {
        if ([v isKindOfClass:NSNumber.class]) {
            long rv = [(NSNumber *)v longValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(short)) || !strcmp(type, @encode(unsigned short))) {
        if ([v isKindOfClass:NSNumber.class]) {
            short rv = [(NSNumber *)v shortValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(char)) || !strcmp(type, @encode(unsigned char))) {
        if ([v isKindOfClass:NSString.class]) {
            char rv = [(NSString *)v characterAtIndex:0];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(long long)) || !strcmp(type, @encode(unsigned long long))) {
        if ([v isKindOfClass:NSNumber.class]) {
            long long rv = [(NSNumber *)v longLongValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(double))) {
        if ([v isKindOfClass:NSNumber.class]) {
            double rv = [(NSNumber *)v doubleValue];
            [invocation setArgument:&rv atIndex:index];
        }
    } else if (!strcmp(type, @encode(Class))) {
        Class clazz = NSClassFromString(v);
        [invocation setArgument:&clazz atIndex:index];
    } else /*if (!strcmp(type, @encode(id)))*/ {
        id rv = v;
        [invocation setArgument:&rv atIndex:index];
    } /*else if (!strcmp(type, @encode(Class))) {
        Class rv = [v toObject];
        [invocation setReturnValue:&rv];
    }*/
}

- (id)getReturnValue:(NSInvocation *)invocation {
    const char *type = invocation.methodSignature.methodReturnType;
    if (!strcmp(type, @encode(float))) {
        float rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(BOOL))) {
        BOOL rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(int)) || !strcmp(type, @encode(unsigned int))) {
        int rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(long)) || !strcmp(type, @encode(unsigned long))) {
        long rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(short)) || !strcmp(type, @encode(unsigned short))) {
        short rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(char)) || !strcmp(type, @encode(unsigned char))) {
        char rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(long long)) || !strcmp(type, @encode(unsigned long long))) {
        long long rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else if (!strcmp(type, @encode(double))) {
        double rv;
        [invocation getReturnValue:&rv];
        return @(rv);
    } else /*if (!strcmp(type, @encode(id)))*/ {
        id rv;
        [invocation getReturnValue:&rv];
        return rv;
    }
}

@end
