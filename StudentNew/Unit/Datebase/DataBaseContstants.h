//
//  DataBaseContstants.h
//  IOSStudentApp
//
//  Created by user on 13-12-2.
//  Copyright (c) 2013年 user. All rights reserved.
//

#ifndef IOSStudentApp_DataBaseContstants_h
#define IOSStudentApp_DataBaseContstants_h

//数据库常量
#define UsedLibraryId_K1 (@"202")  //K1题库id
#define UsedLibraryId_K4 (@"101401")  //K4题库ID
//车型
#define UsedCartype_C1 (@"C1") //小车
#define UsedCartype_B2 (@"B2") //货车
#define UsedCartype_A1 (@"A1") //客车

#define ReBuildDbDate (@"2014/07/22") //用于判断是否重建数据库
#define DbBuildDate (@"DbBuildDate") //存放日期的key值

#define OrderPage (@"OrderPage") //顺序练习当前题目序号的key值

#define problem_type_jedge  1 // 判断题
#define problem_type_single_choice  2 // 单选题
#define problem_type_multi_choice  3 // 多选题
#define problem_type_fill_blank  4 // 填空题
#define problem_type_question_answer  5 // 简答题
#define problem_type_mind  6 // 心理题(n选1 每个选项赋不同分值)
//
#define problem_status_enabled  1 // 可用
#define problem_status_disabled  2 // 禁用
//
#define problem_right_answer_yes  1 // 题目的正确答案--是
#define problem_right_answer_no  2 // 题目的正确答案--否
//
#define exam_status_ongoing  1 // 考试状态--进行中
#define exam_status_finish  2 // 考试状态--已交卷
//
#define exam_library_default  1 // 缺省题库--是
#define exam_library_non_default  2 // 缺省题库--否

#define QUESTION_MARK_FAVORITE  1 // 题目标记--收藏
#define QUESTION_MARK_WRONG  2 // 题目标记--错题




#endif
