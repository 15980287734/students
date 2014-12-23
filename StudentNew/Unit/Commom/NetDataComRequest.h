//
//  NetDataComPro.h
//  StudentNew
//
//  Created by chenlei on 14-11-3.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIProgressDelegate.h"
//异步的协议实现
@protocol NetDataComAsyn

-(void) onRecvdone:(NSString *)msg;
-(void) onRecverr:(NSString *)msg;

@end

@interface NetDataComRequest : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
     id <NetDataComAsyn> _delegate;
}
@property(strong,nonatomic) id<NetDataComAsyn> delegate;
//设置发送参数
-(BOOL) setHead:(NSString *) value
       forName:(NSString *) name;

//设置发送数据
-(BOOL) setMsgData:(NSMutableDictionary *)dic
       forRow:(int) row;
//设置发送给服务端交易码
-(BOOL) setCode:(NSString *) business_code;
//设置mac加密字符串
-(BOOL) setMacKey:(NSString *)mk;
//设置分页
-(BOOL) setPagingRow:(int) row
            withPage:(int) page;

-(NSMutableArray *)getADataResponse;

-(NSMutableArray *)getADataResponse:(NSString *) url;

-(NSString *)getDataResponse;
	
-(NSString *)getResponseFromUrl:(NSString *) url;
	
-(NSString *)insertDateToUrl:(NSString *) url;	
		
-(NSString *)updateDateToUrl:(NSString *) url;		
										 	
-(NSString *)getResponseFromUrl:(NSString *) url
                 withPostAction:(NSString *) postAction
                     withAction:(NSString *) action;

-(NSString *)getAsynResponseFromUrl:(NSString *) url
                     withPostAction:(NSString *) postAction
                         withAction:(NSString *) action;
											 	
@end
