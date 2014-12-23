//
//  WebSiteToIP.m
//  DrivingStudent
//
//  Created by user on 13-12-9.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "WebSiteToIP.h"
#include <netdb.h>
#include <arpa/inet.h>
#import "NetWork.h"
#import "Toast+UIView.h"

/**
 *	@brief	把网址转换为ip地址
 */
@implementation WebSiteToIP

+(NSString *)websiteToIP:(NSString *)webSiteString{
    if ([NetWork isWorking]) {
        NSRange range = [webSiteString rangeOfString:@":"];
        NSString *b;
        if (range.length>0) {
            b = [webSiteString substringFromIndex:range.location +
                 range.length-1];//开始截取
            webSiteString=[webSiteString substringToIndex:range.location +
                           range.length-1];
        }else{
            b=@"";
        }
        //域名转为ip地址
        //NSString to char*
        const char *webSite = [webSiteString cStringUsingEncoding:NSASCIIStringEncoding];
        // Get host entry info for given host
        struct hostent *remoteHostEnt = gethostbyname(webSite);
        // Get address info from host entry
        struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
        // Convert numeric addr to ASCII string
        char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
        //char* to NSString
        NSString *ip = [[[NSString alloc] initWithCString:sRemoteInAddr
                                                 encoding:NSASCIIStringEncoding] autorelease];
        ip=[[@"http://" stringByAppendingString:ip] stringByAppendingString:b];
        return ip;
    }else{
        return nil;
    }
}
@end
