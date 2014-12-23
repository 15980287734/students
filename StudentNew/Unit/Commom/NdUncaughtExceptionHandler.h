//
//  NdUncaughtExceptionHandler.h
//  Test1
//
//  Created by 陈主祥 on 13-12-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NdUncaughtExceptionHandler : NSObject


+ (void)setDefaultHandler;

+ (NSUncaughtExceptionHandler*)getHandler;

@end
