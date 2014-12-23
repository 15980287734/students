//
//  UpdateUserPasswordData.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-12-6.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "UpdateUserPasswordData.h"
#import "GetDataHelper.h"
#import "XMLParser.h"

@implementation UpdateUserPasswordData


+(BOOL)changeUserPassword:(UIView *)view andRecordText:(NSString *)recordText
{
    GetDataHelper *gdh=[[GetDataHelper alloc]initWithView:view];
    gdh.businessCode=HANDLER_ACCOUNT_CODE;
    gdh.action=@"update";
    gdh.postAction=@"uploadXMLData";
    gdh.recordText=recordText;
    NSString *response=[gdh getResponseFromUrl];
    
    if ([response hasPrefix:@"OK"]) {
        [gdh release];
        return YES;
    }
    else
    {
        [gdh release];
        return NO;
    }
}
@end
