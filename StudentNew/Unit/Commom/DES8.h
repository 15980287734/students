//
//  DES8.h
//  IOSCoachApp
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES8 : NSObject
//当字符串长度不为8的倍数时，补0
+(NSString *)fillZero:(NSString *) input;
//当字符串长度不为8的倍数时，补空格
+(NSString *)fillNull:(NSString *) input;

//异或运算
+(Byte)xorByte:(Byte)b1 andB2:(Byte)b2;
/**
 * 异或运算
 *
 * @param src 源数组
 * @param srcPos 源数组中的起始位置
 * @param src2 源数组
 * @param srcPos2 源数组中的起始位置
 * @param dest 目标数组，存放运算结果
 * @param destPos 目标数据中的起始位置
 * @param length--要运算的数组元素的数量
 */
+ (void) xorByte:(Byte[]) src andSrcPos:(int) srcPos andSrc:(Byte[]) src2 andSrcPos2:(int) srcPos2 andDest:(Byte[]) dest andDestPos:(int) destPos andLen:(int) length;

/**
 * 字节转换为十六进制
 */
+(NSString *) byte2hex:(Byte[]) b andLen:(int) len ;

/*
 DES加密
 */
+(void)encrypt:(Byte[]) input andkey:(Byte[])key
     andoutput:(Byte[]) output;
/*
 DES解密
 */
+(void)decrypt:(Byte[]) input andkey:(Byte[])key
     andoutput:(Byte[]) output;



@end
