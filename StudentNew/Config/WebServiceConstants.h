//
//  SystemContents.h
//  IOSCoachApp
//
//  Created by user on 13-11-7.
//  Copyright (c) 2013年 user. All rights reserved.
//

#ifndef IOSStudentApp_WebserviceContants_h
#define IOSStudentApp_WebserviceContants_h

#define  HANDLER_DICT_TYPE_CODE  (@"0001")   //字典类型处理器
#define  HANDLER_DICTIONARY_CODE  (@"0002")    //字典数据处理器

#pragma mark  --学员信息
#define  HANDLER_CARD_PUBLISH_CODE  (@"0003")  //学员发卡处理器
#define  HANDLER_BAOMING_CODE  (@"0007")  //学员报名信息处理器
#define  HANDLER_CHARGE_BOOK_CODE  (@"0009")  //收费流水账信息处理器
#define  HANDLER_STUDENT_PHOTO_CODE  (@"0010") //学员照片处理器

#pragma mark  --人事部分
#define  HANDLER_HUMAN_CODE  (@"0020")       //员工信息处理器

#pragma mark  --培训部分
#define  HANDLER_TRAIN_PLAN_CODE  (@"0031")    //培训计划信息处理器
#define  HANDLER_TRAIN_RESERVE_CODE  (@"0032") //培训预约信息处理器
#define  HANDLER_TRAIN_ENTRY_CODE  (@"0033")   //培训登记信息处理器
#define  HANDLER_TRAIN_DEVICE_CODE  (@"0034")  //培训设备数据处理器
#define  HANDLER_TRAIN_CHECKIN_CODE  (@"0035") //培训签到数据处理器
#define  HANDLER_STUDENT_TRAIN_PROGRESS_CODE  (@"0037") //学员培训进度数据处理器

#pragma mark  --客户管理部分
#define  HANDLER_CUSTOMER_CODE  (@"0041")      //客户信息
#define  HANDLER_CUSTOMER_IMPORT_CODE  (@"0042") //客户信息批量导入

#pragma mark  --考试管理部分
#define  HANDLER_EXAM_RESERVE_CODE  (@"0060")    //考试预约
#define  HANDLER_EXAM_RESERVE_ITEM_CODE (@"0061")  //考试预约项目
#define  HANDLER_EXAM_ARRANGE_CODE  (@"0062")     //考试安排
#define  HANDLER_EXAM_SCORE_CODE  (@"0063")       //考试成绩
#define  HANDLER_OPERATION_PRE_EXAM_CODE  (@"0064") //实操预考成绩信息处理器
#define  HANDLER_EXAM_MISS_CODE  (@"0065")        //考试失误

#pragma mark  --理论培训
#define  HANDLER_ONLINE_EXAM_LIBRARY_CODE  (@"0501") //预考题库处理器
#define  HANDLER_ONLINE_EXAM_SUBJECT_CODE  (@"0502") //预考章节处理器
#define  HANDLER_ONLINE_EXAM_PROBLEM_CODE  (@"0503") //预考题目处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_PAPER_CODE  (@"0504")//学员考卷处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_PAPER_ANSWER_CODE (@"0505")//学员考卷答案处理器

#pragma mark  --报表部分
#define  HANDLER_COACH_EXAM_REPORT_CODE  (@"0091")//教练月考试报表
#define  HANDLER_COACH_EXAM_ENROLLMENT_REPORT_CODE  (@"0092")	//教练月考试招生报表

#pragma mark  --系统部分
#define  HANDLER_DEVICE_ACTIVATION_CODE  (@"1000") //设备激活数据处理器
#define  HANDLER_ACCOUNT_CODE  (@"1001")          //帐户数据处理器
#define  HANDLER_LEAVE_WORD_CODE  (@"1011")      //客户留言数据处理器
#define  HANDLER_MY_SEND_MESSAGE_CODE  (@"1021")  //发送消息数据处理器
#define  HANDLER_MY_MESSAGE_CODE  (@"1022")      //我的消息数据处理器
#define  HANDLER_METHOD_MONITOR_CODE  (@"1099") //方法执行监控数据处理器

#pragma mark  --广告图片链接
#define  HANDLER_AD_LINK_CODE  (@"1051")		//全屏广告链接
#define  HANDLER_AD_LINK_CODE2  (@"1052")		//横幅广告链接

#pragma mark --常用的url
#define LOGIN_URL  (@"/comm/busLogin")  //登录接口后缀
#define SERVICE_URL (@"/comm/busService")  //服务接口后缀
#define UPDATE_URL (@"http://www.smyfjx.com:7777/apps/android/coach/update.properties")  //更新文件网址

#pragma mark  --userDefault中的key
#define ISFIRSTLOGIN (@"isfirstlogin") //是否第一次登录
#define USER_NAME (@"username")  //用户名
#define PASS_WORD (@"password")  //密码
#define KEY (@"key")  //用户密匙
#define USER_ID (@"userid")  //用户Id

#endif
