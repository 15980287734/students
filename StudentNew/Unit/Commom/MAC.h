//
//  MAC.h
//  IOSCoachApp
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
//用DES进行MAC加密
/*
 算法原理：
 就是把争端数据（要求是8byte的整数倍），用客户密匙加密，加密一段（8byte），就把密文和下一段明文异或，把结果作为明文，在加密，一直到数据取完。
 这样得到8byte密文为MAC码，把它附加到原数据后发给客户。
 客户收到后按相同算法处理，看得到的mac码是否一致，如果不一致，肯定被篡改。
 */
@interface MAC : NSObject

+(void)calculate:(Byte[])input andLen:(int)len andKey:(Byte[])key andOutput:(Byte[]) output;
+(NSString *)calculateMac:(Byte[])input andLen:(int)len andByteKey:(Byte[])key;
+(NSString *)calculateMac:(NSString *)input andStringKey:(NSString *)key;
+(NSString *)calculateMacByASCII:(NSString *)input andKey:(NSString *)key;

@end
