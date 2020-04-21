//
// Created by Milker on 2020/4/16.
// Copyright (c) 2020 milker. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestClass : NSObject

- (NSString *)testStringInOut:(NSString *)p;
- (int)testIntInOut:(int)p;
- (NSInteger)testNSIntegerInOut:(NSInteger)p;
- (BOOL)testBoolInOut:(BOOL)p;
- (char)testCharInOut:(char)p;
- (long)testLongInOut:(long)p;
- (long long)testLongLongInOut:(long long)p;
- (short)testShortInOut:(short)p;
- (double)testDoubleInOut:(double)p;
- (Class)testClassInOut:(Class)p;
- (NSArray *)testArrayInOut:(NSArray *)p;
- (NSDictionary *)testNSDictionaryInOut:(NSDictionary *)p;

@end