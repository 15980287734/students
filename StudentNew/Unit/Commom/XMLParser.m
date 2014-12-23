//
//  XMLParse.m
//  IOSCoachApp
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser{
    NSXMLParser *parser;
}


-(id)init{
    self = [super init];
    if (self) {
        list=[[NSMutableArray alloc] init];
        _dataSize=-1;
    }
    return self;
}

-(void)dealloc{
    [_dataString release];
    [list release];
    [parser release];
    [super dealloc];
}



/**
 *	@brief	解析xml
 *
 *	@param 	data 	xml字符串
 *
 *	@return	字典对象数组
 */
-(NSMutableArray *)XMLParse:(NSString *)data
{
    if (data) {
        parser=[[NSXMLParser alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [parser setDelegate: self];
        if([parser parse]){
            return list;
        }else{
            return nil;
        }
    }
    return nil;
}
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
   
    if([elementName isEqualToString:@"dataset"]) {
        
        _dataSize=[[attributeDict objectForKey:@"datasetSize"] integerValue];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"%@",NSStringFromSelector(_cmd) );
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"%@",NSStringFromSelector(_cmd) );
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
//    NSString *str=[[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    //把json数据转换为字典对象存入数组
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:CDATABlock  options:NSJSONReadingMutableLeaves error:nil]];
    NSString * str=[[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    self.dataString=str;
    [str release];
    [list addObject:dic];
}

@end
