//
//  MyRequestData.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-30.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "MyRequestData.h"
#import "GetDataHelper.h"
#import "XMLParser.h"
#import "JsonTools.h"

@implementation MyRequestData

+(NSString *)removeTagFromText:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return html;
}
//获取推送消息
+(NSMutableArray *)getPushInformations:(UIView *)view
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.businessCode=HANDLER_MESSAGE_RECEIVE_CODE;
    NSString *response=[gdh getResponseFromUrl];
    //解析字符串为字典数据
    XMLParser *parse=[[XMLParser alloc] init];
    NSMutableArray *user=[[NSMutableArray alloc]initWithCapacity:1];
    [user addObjectsFromArray:[parse XMLParse:response]];
    if (user.count>0) {
        for (NSDictionary *temp in user) {
            [self reply:view andMessageId:[temp valueForKey:@"id"]];
        }
    }
    [gdh release];
    [parse release];
    return [user autorelease];
}

//获取其他驾校的推送消息
+(NSMutableArray *)getOtherSchoolPushInformations:(UIView *)view andUrl:(NSString *)url andUserId:(NSString *)userId andKey:(NSString *)key
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.businessCode=HANDLER_MESSAGE_RECEIVE_CODE;
    gdh.url=url;
    gdh.userId=userId;
    gdh.key=key;
    NSString *response=[gdh getResponseFromUrl];
    //解析字符串为字典数据
    XMLParser *parse=[[XMLParser alloc] init];
    NSMutableArray *user=[[NSMutableArray alloc]initWithCapacity:1];
    [user addObjectsFromArray:[parse XMLParse:response]];
    if (user.count>0) {
        for (NSDictionary *temp in user) {
            [self reply:view andUrl:url andKey:key andUserId:userId andMessageId:[temp valueForKey:@"id"]];
        }
    }
    [gdh release];
    [parse release];
    return [user autorelease];
}

//返回推送消息接收状态
+(BOOL)reply:(UIView *)view andUrl:(NSString *)url andKey:(NSString *)key andUserId:(NSString *)userId andMessageId:(NSString *)messageId
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.url=url;
    gdh.userId=userId;
    gdh.key=key;
    gdh.postAction=@"uploadXMLData";
    gdh.action=@"update";
    gdh.recordText=messageId;
    gdh.businessCode=HANDLER_MESSAGE_RECEIVE_CODE;
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


//发送消息给好友
+(BOOL)pushMessage:(UIView *)view andRecord:(NSString *)record{
    GetDataHelper *gdh = [[GetDataHelper alloc] initWithView:view];
    gdh.businessCode=HANDLER_MESSAGE_SEND_CODE;
    gdh.postAction=POST_ACTION_TYPE_UPLOADXMLDATA;
    gdh.action=ACTION_TYPE_INSERT;
    gdh.recordText=record;
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
//返回推送消息接收状态
+(BOOL)reply:(UIView *)view andMessageId:(NSString *)messageId
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.postAction=@"uploadXMLData";
    //    gdh.messageId=messageId;
    gdh.action=@"update";
    gdh.recordText=messageId;
    gdh.businessCode=HANDLER_MESSAGE_RECEIVE_CODE;
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
//回复推送消息
+(BOOL)replyPushInformation:(UIView *)view andRecord:(NSString *)record
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.postAction=@"uploadXMLData";
    gdh.action=@"insert";
    gdh.recordText=record;
    gdh.businessCode=HANDLER_MESSAGE_REPLY_CODE;
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
//从服务器获取问题和答案
+(NSMutableArray *)getRequestOrAnswerData:(UIView *)view andPage:(int)page
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.startRow=1+(page-1)*10;
    gdh.pageSize=10;
    gdh.businessCode=HANDLER_LEAVE_WORD_CODE;
    NSString *response=[gdh getResponseFromUrl];
    //解析字符串为字典数据
    XMLParser *parse=[[XMLParser alloc] init];
    NSMutableArray *user=[parse XMLParse:response];
    if (((parse.dataSize+(gdh.pageSize-1))/gdh.pageSize)<page) {
        [gdh release];
        [parse release];
        return nil;
    }
    NSMutableArray * arr=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    if (user.count>0) {
        for (int i=0; i<user.count; i++) {
            [arr addObject:[self getRequestOrAnswerDictionaryData:[user objectAtIndex:i]]];
        }
    }
    [gdh release];
    [parse release];
    return arr;
}
//获取每个问题所在的字典
+(NSMutableDictionary *)getRequestOrAnswerDictionaryData:(NSMutableDictionary *)dic
{
    NSMutableDictionary * dicTemp=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
    [dicTemp setObject:[dic valueForKey:@"name"] forKey:@"name"];
    [dicTemp setObject:[dic valueForKey:@"id"] forKey:@"id"];
    if ([dic valueForKey:@"content"]!=nil) {
        [dicTemp setObject:[NSString stringWithFormat:@"%@ : %@",[dic valueForKey:@"name"],[dic valueForKey:@"content"]] forKey:@"content"];
    }
    else
    {
        [dicTemp setObject:@"" forKey:@"content"];
        
    }
    if ([dic valueForKey:@"leaveDate"]!=nil) {
        [dicTemp setObject:[dic valueForKey:@"leaveDate"] forKey:@"leaveDate"];
    }
    else
    {
        [dicTemp setObject:@"" forKey:@"leaveDate"];
    }
    
    if ([dic valueForKey:@"replyContent"]!=nil) {
        
        [dicTemp setObject:[self removeTagFromText:[dic valueForKey:@"replyContent"]] forKey:@"replyContent"];
        
    }
    else
    {
        //        [dicTemp setObject:@"" forKey:@"replyContent"];
        
    }
    if ([dic valueForKey:@"replyDate"]!=nil) {
        [dicTemp setObject:[dic valueForKey:@"replyDate"] forKey:@"replyDate"];
    }
    else
    {
        //        [dicTemp setObject:@"" forKey:@"replyDate"];
    }
    if ([dic valueForKey:@"status"]!=nil) {
        [dicTemp setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]] forKey:@"status"];
    }
    else
    {
        [dicTemp setObject:@"0" forKey:@"status"];
    }
    
    
    
    return dicTemp;
}
+(BOOL)answer:(UIView *)view andRecord:(NSString *)recordText
{
    
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.action=@"update";
    gdh.postAction=@"uploadXMLData";
    gdh.recordText=recordText;
    gdh.businessCode=HANDLER_LEAVE_WORD_CODE;
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
+(BOOL)request:(UIView *)view andRecord:(NSString *)recordText
{
    GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:view];
    gdh.action=@"insert";
    gdh.postAction=@"uploadXMLData";
    gdh.recordText=recordText;
    gdh.businessCode=HANDLER_LEAVE_WORD_CODE;
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
    //解析字符串为字典数据
    //    XMLParser *parse=[[XMLParser alloc] init];
    //    NSMutableArray *user=[parse XMLParse:response];
}

@end
