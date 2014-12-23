//
//  NetWork.m
//  IOSCoachApp
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "NetWork.h"
#import "Reachability.h"

@implementation NetWork

+(BOOL)isWorking{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;  
    }
    return isExistenceNetwork;
}

+(BOOL)isWifi{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if ([r currentReachabilityStatus]==ReachableViaWiFi) {
        return YES;
    }
    return NO;
}

@end
