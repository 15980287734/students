//
//  JsonTools.m
//  IOSCoachApp
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "JsonTools.h"

@implementation JsonTools

//NSString *jsonString ;

//@synthesize _dictionary;

-(id)init{
    self=[super init];
    if (self) {
        _dic=[[NSMutableDictionary alloc] initWithCapacity:1];
        //        jsonString = [[NSString alloc] init];
    }
    return self;
}

-(void)dealloc{
    //    NSLog(@"%d",jsonString.retainCount);
    
    [_jsonString release];
    
    
    [_dic release];
    [super dealloc];
}


-(void)setValue:(NSString *)value forKey:(NSString *)key{
    //    NSLog(@"%@++++%@",value,key);
    [_dic setValue:value forKey:key];
    
}
-(NSMutableDictionary *)getDictionary
{
    return _dic;
}
-(void)setDictionary:(NSDictionary *)dic
{
    [_dic setDictionary:dic];
    
}
-(NSString *)getJsonString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] != 0 && error == nil){
        self.jsonString = [[[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding] autorelease];
        return self.jsonString;
    }else{
        
        return nil;
    }
    
}


@end
