//
//  HotFix.m
//  HotFix
//
//  Created by milker on 2020/04/21.
//  Copyright © 2020年 milker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKHotfix : NSObject

+ (instancetype)shared;

- (void)fixWithJS:(NSString *)js; /// Fix With JS Source
- (void)fixWithFilePath:(NSString *)filePath; /// Fix With Sandbox FilePath
- (void)fixWithFileName:(NSString *)fileName; /// Fix With Project JS File

@end
