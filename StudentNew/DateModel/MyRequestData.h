//
//  MyRequestData.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-30.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequestData : NSObject

//获取问题数据
+(NSMutableArray *)getRequestOrAnswerData:(UIView *)view andPage:(int)page;
//提问
+(BOOL)request:(UIView *)view andRecord:(NSString *)recordText;
//回答
+(BOOL)answer:(UIView *)view andRecord:(NSString *)recordText;


//-(NSString *)removeTagFromText:(NSString *)html;
+(NSMutableArray *)getPushInformations:(UIView *)view;
+(NSMutableArray *)getOtherSchoolPushInformations:(UIView *)view andUrl:(NSString *)url andUserId:(NSString *)userId andKey:(NSString *)key;
//返回推送消息接收状态
+(BOOL)replyPushInformation:(UIView *)view andRecord:(NSString *)record;
//推送消息给好友
+(BOOL)pushMessage:(UIView *)view andRecord:(NSString *)record;
+(BOOL)reply:(UIView *)view andUrl:(NSString *)url andKey:(NSString *)key andUserId:(NSString *)userId andMessageId:(NSString *)messageId;
@end
