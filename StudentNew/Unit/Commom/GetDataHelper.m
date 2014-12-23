//
//  GetDataHelper.m
//  IOSCoachApp
//
//  Created by user on 13-11-7.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "GetDataHelper.h"
#import "ASIFormDataRequest.h"
#import "MAC.h"
#import "NetWork.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"


@implementation GetDataHelper


@synthesize postAction=_postAction;
@synthesize company=_company;
@synthesize application=_application;
@synthesize terminal=_terminal;
@synthesize branchId=_branchId;
@synthesize version=_version;
@synthesize userId=_userId;
@synthesize userName=_userName;
@synthesize businessCode=_businessCode;
@synthesize action=_action;
@synthesize dataFormat=_dataFormat;
@synthesize startRow=_startRow;
@synthesize pageSize=_pageSize;
@synthesize paramId=_paramId;
@synthesize recordText=_recordText;
//@synthesize recordTextList=_recordTextList;
@synthesize libraryType=_libraryType;
@synthesize progressView;

-(id)initWithView:(UIView *) view{
    self = [super init];
    if (self) {
        
        _view=view;
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        self.url= [[userDefaults objectForKey:SCHOOL_URL] stringByAppendingString:SERVICE_URL];
        self.key = [userDefaults objectForKey:KEY];
        //变量初始化
        _postAction=[[NSString alloc] initWithString: @"downloadXMLData"];
        _company=[[NSString alloc] initWithString:@""];
        _application=[[NSString alloc] initWithString:@"studentApp"];
        _terminal=[[NSString alloc] initWithString:@"iphone"];
        _branchId=[[NSString alloc] initWithString:@"1.0"];
        _version=[[NSString alloc] initWithString:@""];
        if ([userDefaults valueForKey:USER_ID] != nil) {
            _userId=[[NSString alloc] initWithString:[userDefaults valueForKey:USER_ID]];
        }else{
            _userId=[[NSString alloc] initWithString:@""];
        }
        if ([userDefaults objectForKey:USER_NAME]!=nil) {
            _userName=[[NSString alloc] initWithString:[userDefaults objectForKey:USER_NAME]];
        }
        else
        {
            _userName=[[NSString alloc] initWithString:@""];
        }
        
        _businessCode=[[NSString alloc] initWithString:@""];
        _action=[[NSString alloc] initWithString:@"query"];
        _dataFormat=[[NSString alloc] initWithString:@"JSON"];
        _startRow=0;
        _pageSize=0;
        _paramId=[[NSString alloc] initWithString:@""];
        _recordText=[[NSString alloc] initWithString:@""];
        //        _recordTextList=[[NSMutableArray alloc]initWithCapacity:1];
        _libraryType=[[NSString alloc] initWithString:@""];
        _subjectScope=[[NSString alloc] initWithString:@""];
        //        _messageId=[[NSString alloc] initWithString:@""];
    }
    return self;
}

-(void)dealloc{
    
    if (_messageId!=nil) {
        [_messageId release];
    }
    if (_url) {
        [_url release];
    }
    if (_key) {
        [_key release];
    }
    [_postAction release];
    //公司代码，暂时可以为空
    [_company release];
    //客户端类型，教练为coachApp，学员为studentApp
    [_application release];
    //手机类型，默认为iphone
    [_terminal release];
    //网点代码，暂时默认为1.0
    [_branchId release];
    //版本号
    [_version release];
    //用户id
    [_userId release];
    //用户名
    [_userName release];
    //业务代码，每次使用之前必须设置值，默认为“”
    [_businessCode release];
    //操作类型(query/insert/update/delete，要删除时必须指定为delete)，默认为query
    [_action release];
    //上传值的类型，默认为JSON
    [_dataFormat release];
    [_paramId release];
    //上传数据时，用于存放JSON数据的字符串
    //    if (_recordText) {
    [_recordText release];
    //    }
    
    
    
    //批量上传
    [_recordTextList release];
    [_libraryType release];
    [_subjectScope release];
    
    if (progressView) {
        [progressView release];
    }
    [super dealloc];
    
}

/**
 *	@brief	生成xml中element
 *
 *	@param 	tag   键值
 *	@param 	value 	键值对中的value
 *
 *	@return	<tag>value</tag>
 */
-(NSString *)writeElement:(NSString *)tag andValue:(NSString *)value

{
    NSString *content=[[[[[[@"<" stringByAppendingString:tag]stringByAppendingString:@">"] stringByAppendingString:value] stringByAppendingString:@"</"] stringByAppendingString:tag] stringByAppendingString:@">\n"];
    return content;
}
/**
 *	@brief	生成xml字符串，上传请求参数
 *
 *	@return	xml字符串
 */
-(NSString *)writeXML
{
    NSString *xmlContent=@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n";
    xmlContent=[xmlContent stringByAppendingString:@"<Root>\n<head>\n"];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"company" andValue:_company]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"application" andValue:_application]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"terminal" andValue:_terminal]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"branchId" andValue:_branchId]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"version" andValue:_version]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"userId" andValue:_userId]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"userName" andValue:_userName]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"businessCode" andValue:_businessCode]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"action" andValue:_action]];
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"dataFormat" andValue:_dataFormat]];
    if (_messageId!=nil) {
        xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"messageId" andValue:_messageId]];
    }
    
    
    xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"param" andValue:_paramId]];
    if(_startRow !=0 ){
        NSString *str=[[[[@"<query startRow=" stringByAppendingString:[NSString stringWithFormat:@"\"%d\"",_startRow]] stringByAppendingString:@" pageSize="] stringByAppendingString:[NSString stringWithFormat:@"\"%d\"",_pageSize]] stringByAppendingString:@"></query>\n"];
        xmlContent=[xmlContent stringByAppendingString:str];
    }
    
    //模拟考试时用到
    if (![_libraryType isEqualToString:@""]) {
        xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"libraryType" andValue:_libraryType]];
    }
    
    //模拟考试时用到
    if (![_subjectScope isEqualToString:@""]) {
        xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"subjectScope" andValue:_subjectScope]];
    }
    
    xmlContent=[xmlContent stringByAppendingString:@"</head>\n<body>\n<dataset>\n"];
    
    if(self.recordText != nil){
        if ( ![self.recordText isEqualToString:@""]) {
            
            
            xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"record" andValue:self.recordText]];}
    }
    if(self.recordTextList.count>0){
        for (int i=0; i<self.recordTextList.count; i++) {
            xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"record" andValue:[self.recordTextList objectAtIndex:i]]];
        }
    }
    
    xmlContent=[xmlContent stringByAppendingString:@"</dataset>\n</body>\n</Root>\n"];
    
    //    NSLog(@"+++++++>%@",xmlContent);
    return xmlContent;
}

-(NSString *)getResponseFromUrl
{
    @synchronized(self){
        
        if ([NetWork isWorking]) {
            
            NSString *content=[self writeXML];
            NSString *macVal=[MAC calculateMacByASCII:content andKey:_key];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_url]];
            [request setPostValue:_postAction forKey:@"action"];
            [request setPostValue:_userName forKey:@"username"];
            [request setPostValue:macVal forKey:@"checkCode"];
            [request setPostValue:content forKey:@"content"];
            [request setStringEncoding:NSUTF8StringEncoding];
            request.timeOutSeconds = 30;       //设置网络延迟时间
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            [request setStringEncoding:enc];
            //添加显示下载进度的进度条
            if (progressView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [request setShowAccurateProgress:YES];
                    [request setDownloadProgressDelegate:progressView];
                });
            }
            [request startSynchronous];
            NSError *erro = [request error];
            if (erro) {             //没有错误信息时，返回的是null
                [erro localizedDescription];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_view makeToast:@"亲，获取数据出错，请检查您的手机是否能正常上网!"];
                });
                return nil;
            }else{
                NSString *strResult = [request responseString];
                return strResult;
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_view makeToast:@"亲，当前网络不给力，请检查您的手机是否能正常上网！"];
            });
            return nil;
        }
    }
    
}


@end
