//
//  MKViewController.m
//  MKHotfix
//
//  Created by hua1017059@163.com on 04/21/2020.
//  Copyright (c) 2020 hua1017059@163.com. All rights reserved.
//

#import "MKViewController.h"
#import "MKHotfix.h"
#import "TestClass.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHotfix];
    [self testHotfix];
}

- (void)initHotfix {
    [[MKHotfix shared] fixWithFileName:@"js/hotfix"];
}

- (void)divider {
    NSLog(@"=========");
}

- (void)testHotfix {
    TestClass *t1 = [TestClass new];
    {
        NSString *res = [t1 testStringInOut:@"入参"];
        NSLog(@"OC[testStringInOut] = %@", res);
    }
    [self divider];
    {
        int res = [t1 testIntInOut:1];
        NSLog(@"OC[testIntInOut] = %d", res);
    }
    [self divider];
    {
        NSInteger res = [t1 testNSIntegerInOut:1];
        NSLog(@"OC[testNSIntegerInOut] = %ld", res);
    }
    [self divider];
    {
        BOOL res = [t1 testBoolInOut:YES];
        NSLog(@"OC[testBoolInOut] = %@", res ? @"YES" : @"NO");
    }
    [self divider];
    {
        char p = 'a';
        char res = [t1 testCharInOut:p];
        NSLog(@"OC[testCharInOut] = %c", res);
    }
    [self divider];
    {
        long long p = 1;
        long long res = [t1 testLongLongInOut:p];
        NSLog(@"OC[testLongLongInOut] = %lli", res);
    }
    [self divider];
    {
        long  p = 1;
        long res = [t1 testLongInOut:p];
        NSLog(@"OC[testLongInOut] = %li", res);
    }
    [self divider];
    {
        short  p = 1;
        short res = [t1 testShortInOut:p];
        NSLog(@"OC[testShortInOut] = %hi", res);
    }
    [self divider];
    {
        double p = 1;
        double res = [t1 testDoubleInOut:p];
        NSLog(@"OC[testDoubleInOut] = %lf", res);
    }
    [self divider];
    {
        Class clazz = TestClass.class;
        Class res = [t1 testClassInOut:clazz];
        NSLog(@"OC[testClassInOut] = %@", res);
    }
    [self divider];
    {
        NSDictionary *res = [t1 testNSDictionaryInOut:@{@"d": @1}];
        NSLog(@"OC[testNSDictionaryInOut] = %@", res);
    }
    [self divider];
    {
        NSArray *res = [t1 testArrayInOut:@[@"1"]];
        NSLog(@"OC[testArrayInOut] = %@", res);
    }

    NSLog(@"END");

}

@end
