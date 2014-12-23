//
//  ChoicButton.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-13.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoicButton : UIButton

@property (retain,nonatomic)UIImageView * selectedImageView;
@property (copy,nonatomic)NSString *typeName;

-(id)initWithFrame:(CGRect)frame withName:(NSString *)name;
@end
