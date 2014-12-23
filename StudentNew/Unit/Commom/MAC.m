//
//  MAC.m
//  IOSCoachApp
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MAC.h"
#import "DES8.h"

@implementation MAC

+(void)calculate:(Byte[])input andLen:(int)len andKey:(Byte[])key andOutput:(Byte[])output{
    
    Byte *wdata=malloc(9);
    for (int i=0; i<9; i++) {
        wdata[i]=(char)0;
    }
    
    int offset=0;
    
    for (int i=0; i<len/8; i++) {
        offset=i*8;
        for (int j=0; j<8; j++) {
            wdata[j]=[DES8 xorByte:output[j] andB2:input[j+offset]];
        }
        
        [DES8 encrypt:wdata andkey:key andoutput:output];
    }
}

+(NSString *)calculateMac:(Byte[])input andLen:(int)len
               andByteKey:(Byte[])key{
    
    Byte *result=malloc(8);
    for (int i=0; i<8; i++) {
        result[i]=(char)0;
    }
    
    [MAC calculate:input andLen:len andKey:key andOutput:result];
    NSString *res=[DES8 byte2hex:result andLen:8];

    if(res.length>8){
        res=[res substringToIndex:8];
    }
    return res;
}

+(NSString *)calculateMac:(NSString *)input andStringKey:(NSString *)key{
    input=[DES8 fillZero:input];
    key=[DES8 fillNull:key];
    @try {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSData* inputData = [input dataUsingEncoding:enc];
        Byte * inputByte = (Byte *)[inputData bytes];
        NSData* keyData = [key dataUsingEncoding:enc];
        Byte * keyByte=(Byte *)[keyData bytes];

        NSString *result=[MAC calculateMac: inputByte andLen:input.length andByteKey: keyByte];
        return result;
    }
    @catch (NSException *exception) {
        NSLog(@"encodingException");
        return @"encoding covert exception";
    }
}

//Mac加密
+(NSString *)calculateMacByASCII:(NSString *)input andKey:(NSString *)key{
    NSMutableString *tempInput =[[[NSMutableString alloc] initWithString:@""] autorelease];
    for (int i=0; i<input.length; i++) {
        if([input characterAtIndex:i]>='0' && [input characterAtIndex:i]<='9'){
            NSRange range=NSMakeRange(i , 1);
            NSString *b=[input substringWithRange:range];
            [tempInput appendString:b];
        }else if([input characterAtIndex:i]>='A' && [input characterAtIndex:i]<='Z'){
            
            NSRange range=NSMakeRange(i , 1);
            NSString *b=[input substringWithRange:range];
            [tempInput appendString:b];
        }else if([input characterAtIndex:i]>='a' && [input characterAtIndex:i]<='z'){
            
            NSRange range=NSMakeRange(i , 1);
            NSString *b=[input substringWithRange:range];
            [tempInput appendString:b];
        }
    }
    
    return [MAC calculateMac:tempInput andStringKey:key];
}

@end
