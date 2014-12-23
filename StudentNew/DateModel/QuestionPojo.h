//
//  QuestionPojo.h
//  IOSStudentApp
//
//  Created by user on 13-11-28.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionPojo : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) int right;
/**
 * 错误次数
 */
@property (nonatomic,assign) int wrong;
@property (nonatomic,assign) int new_right;
@property (nonatomic,assign) int new_wrong;
@property (nonatomic,assign) int favorite;
/**
 * 是否为错题
 */
@property (nonatomic,assign) int wrongquestion;
@property (nonatomic,assign) int rating;
@property (nonatomic,assign) int key;
@property (nonatomic,assign) int type;//题目类型 0 单选 1判断 2多选
@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *option_a;
@property (nonatomic,copy) NSString *option_b;
@property (nonatomic,copy) NSString *option_c;
@property (nonatomic,copy) NSString *option_d;
@property (nonatomic,copy) NSString *explain;
@property (nonatomic,copy) NSString *library_id;
@property (nonatomic,copy) NSString *subject_id;
@property (nonatomic,copy) NSString *scope;
@property (nonatomic,copy) NSString *imgPath;
@property (nonatomic,copy) NSString *ultimedia;
@property (nonatomic,copy) NSString *label;

@end
