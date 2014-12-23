//
//  StringUntil.m
//  DrivingStudent
//
//  Created by user on 13-12-9.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

/**
 *	@brief	判断字符串为空
 *
 *	@param 	str 	
 *
 *	@return
 */
+(BOOL)isBlank:(NSString *)str
{
    if (str == nil) {
        return YES;
    }
    //去除前后空格，判断是否为空
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/**
 *	@brief	判断字符串不为空
 *
 *	@param 	str 	<#str description#>
 *
 *	@return	<#return value description#>
 */
+(BOOL)isNotBlank:(NSString *)str
{
    if (str == nil) {
        return NO;
    }
    //去除前后空格，判断是否为空
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

@end
