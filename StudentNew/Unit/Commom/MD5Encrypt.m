//
//  MD5Encrypt.m
//  IOSCoachApp
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MD5Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Encrypt

//32位MD5加密
+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}


@end
