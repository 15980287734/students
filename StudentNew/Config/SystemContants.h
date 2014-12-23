//
//  SystemContants.h
//  IOSStudentApp
//
//  Created by user on 13-12-2.
//  Copyright (c) 2013年 user. All rights reserved.
//

#ifndef IOSStudentApp_SystemContants_h
#define IOSStudentApp_SystemContants_h

#pragma mark  --userDefault中的key
#define SCHOOL_PER (@"schoolPermission")  //驾校权限
#define ISFIRSTLOGIN (@"isfirstlogin") //是否第一次登录
#define ISDOWNLOADOFFLINE (@"isDownloadOffLineData")//离线数据是否加载完成
#define USER_NAME (@"username")  //用户名
#define USER_NICK_NAME (@"nickname") //用户姓名
#define PASS_WORD (@"password")  //密码
#define USER_TYPE (@"usertype") //用户类型
#define CARTYPE (@"usedCarType")//车型
#define USEDLIBRARY (@"usedLibrary")//题库
#define KEY (@"key")  //用户密匙

#define SCHOOL_NAME (@"schoolName")  //驾校名
#define SCHOOL_URL (@"schoolUrl")  //驾校网址
#define SCHOOL_CODE (@"schoolCode") //companyId
#define CITY_CODE (@"cityCode") //companyId
#define CITY_NAME (@"cityName") //companyId
#define ISALLOWBB (@"isAllowBB") //companyId

#define USER_ID (@"userid")  //用户Id
#define IMAGEURL (@"http://exam.51xc.cn") //题库加载专用ip地址
#define ISSOUNDOFF (@"isSoundOFF")//是否开启消息提示音
#define DATABASECHANGE (@"DataBaseChange")//数据库修改
#define SCHOOLDATA (@"schoolData") //驾校数据
#define USEDSCHOOL (@"usedSchool") //已选择的驾校

#define QUESTION_USERID (@"06ffd9037a6611e3b1d73de4f326377f") //加载题库专用userId
#define QUESTION_USERNAME (@"500net") //加载题库专用userName

//#pragma mark  --userDefault中的保存缓存的key
//
//#define STUDENTINFO (@"studentInfo") //学员对象
//#define BAOBEI (@"baobei") //报备记录

#pragma mark --Colors

#define violetColor [UIColor colorWithRed:255/255.0 green:180/255.0 blue:233/255.0 alpha:1] //浅紫色(练习界面回答错误时，title的背景色)
#define roseColor   [UIColor colorWithRed:255/255.0 green:0/255.0 blue:204/255.0 alpha:1] //紫红色（练习界面，选错答案时，选项的字体颜色）
#define skyBlueColor [UIColor colorWithRed:0 green:102/255.0 blue:255/255.0 alpha:1]  //天空蓝
#define lightBlueColor [UIColor colorWithRed:225/255.0 green:242/255.0 blue:255/255.0 alpha:1]//浅蓝色
#define lightGreenColor [UIColor colorWithRed:215/255.0 green:251/255.0 blue:203/255.0 alpha:1]//浅绿色
#define darkGreenColor [UIColor colorWithRed:1/255.0 green:153/255.0 blue:122/255.0 alpha:1]//深绿色

#define tab_bg_Color [UIColor colorWithRed:193/255.0 green:241/255.0 blue:254/255.0 alpha:1]//tab背景色
#define tab_baseLine_Color [UIColor colorWithRed:0/255.0 green:175/255.0 blue:246/255.0 alpha:1]//tab下划线颜色
#define lightGray [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]//浅灰色
#define tableBackColor [UIColor colorWithRed:231/255.0 green:232/255.0 blue:233/255.0 alpha:1]//浅灰色

#define tabbar_bg [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]//滑动导航栏背景色
#define tab_select_bg [UIColor colorWithRed:0/255.0 green:204/255.0 blue:102/255.0 alpha:1]//滑动导航栏选中色
#define tab_text_bg [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]//滑动导航栏默认色



#endif
