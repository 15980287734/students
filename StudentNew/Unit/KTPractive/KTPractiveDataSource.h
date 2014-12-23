//
//  KTPractiveDataSource.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTDefineView;
@class ButtomBarButton;

@protocol KTPractiveDataSource <NSObject>
@required

- (NSInteger)numberOfOnes;

@optional
///////////////////////////////////////////////
// 自定义就实现下面一个了
- (id)detailAtIndex:(NSInteger)index;

- (void)detailAtIndex:(NSInteger)index
             withView:(KTDefineView *)selfDefineView;

///////////////////////////////////////////////
//
-(void)jumpAtIndex:(NSInteger)index
        withbutton:(ButtomBarButton *)btn;
//查看答案
- (void)getAnswerAtIndex:(NSInteger)index
                withbutton:(ButtomBarButton *)btn;
//收藏
- (void)restoreQuestionAtIndex:(NSInteger)index
                      withbutton:(ButtomBarButton *)btn;
//交卷
- (void)submitAtIndex:(NSInteger)index
                withbutton:(ButtomBarButton *)btn;
//查看未作
- (void)undoAtIndex:(NSInteger)index
           withbutton:(ButtomBarButton *)btn;
- (UIColor *)imageBackgroundColor;

@end
