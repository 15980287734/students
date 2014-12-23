//
//  GetExceptionData.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-12-13.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "GetExceptionData.h"
#import "JsonTools.h"
#import "GetDataHelper.h"
#import "XMLParser.h"

@implementation GetExceptionData


//把异常提交到服务器上
+(BOOL)setExceptionData:(UIView *)view andException:(NSString *)exception
{
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    int y = [dd year];
    int m = [dd month];
    int d = [dd day];
    int h=[dd hour];
    int minute=[dd minute];
    int second=[dd second];
    
    NSString *mm;
    NSString *day;
    NSString *hh;
    NSString *mimi;
    NSString *sese;
    if (m < 10) {
        mm=[NSString stringWithFormat:@"0%d",m];
    }else{
        mm=[NSString stringWithFormat:@"%d",m];
    }
    
    if (d < 10) {
        day=[NSString stringWithFormat:@"0%d",d];
    }else{
        day=[NSString stringWithFormat:@"%d",d];
    }
    
    if (h < 10) {
        hh=[NSString stringWithFormat:@"0%d",h];
    }else{
        hh=[NSString stringWithFormat:@"%d",h];
    }
    
    if (minute < 10) {
        mimi=[NSString stringWithFormat:@"0%d",minute];
    }else{
        mimi=[NSString stringWithFormat:@"%d",minute];
    }
    
    if (second < 10) {
        sese=[NSString stringWithFormat:@"0%d",second];
    }else{
        sese=[NSString stringWithFormat:@"%d",second];
    }

    
    JsonTools *jt=[[JsonTools alloc]init];
    [jt setValue:[NSString stringWithFormat:@"%d-%@-%@ %@:%@:%@",y,mm,day,hh,mimi,sese] forKey:@"activeTime"];
    [jt setValue:@"CATCH" forKey:@"adviseType"];
    [jt setValue:@"APPS" forKey:@"pointcutType"];
    [jt setValue:exception forKey:@"exceptionInfo"];
    [jt setValue:[NSString stringWithFormat:@"userName=%@, userId=%@, company=%@, city=, 设备=%@, 系统=iOS%@, appName=%@, versionCode=%@",
                  [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME],
                  [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID],
                  [[NSUserDefaults standardUserDefaults] valueForKey:SCHOOL_NAME],
                  [[UIDevice currentDevice] systemName],
                  [[UIDevice currentDevice] systemVersion],
                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forKey:@"remark"];
    GetDataHelper *gdh=[[GetDataHelper alloc]initWithView:view];
    gdh.recordText=[jt getJsonString];
    gdh.action=@"insert";
    gdh.postAction=@"uploadXMLData";
    gdh.businessCode=HANDLER_METHOD_MONITOR_CODE;
    
    
    if ([[gdh getResponseFromUrl] hasPrefix:@"OK"]) {
        [gdh release];
        [jt release];
        return YES;
    }
    [gdh release];
    [jt release];
    return NO;
}
@end
