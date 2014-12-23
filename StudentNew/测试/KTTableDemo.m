//
//  KTTableDemo.m
//  StudentNew
//
//  Created by chenlei on 14-12-19.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import "KTTableDemo.h"

@interface KTTableDemo ()

@end

@implementation KTTableDemo
{
    ASFTableView *_mASFTableView;
    NSMutableArray *_rowsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSArray *cols = @[@"日期",@"列2",@"列3",@"人名",@"照片"];
    NSArray *weights = @[@(0.25f),@(0.15f),@(0.2f),@(0.20f),@(0.20f)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(16),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(false),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor clearColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(0.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:239/255.0 green:244/255.0 blue:254/255.0 alpha:1.0]};
    _mASFTableView=[[ASFTableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-80)];
    NSLog(@"%f,%f",SCREEN_WIDTH, SCREEN_HEIGHT-80);
    [_mASFTableView setDelegate:self];
    [_mASFTableView setBounces:YES];
    [_mASFTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [_mASFTableView setTitles:cols
                  WithWeights:weights
                  WithOptions:options
                    WitHeight:40 Floating:YES];
    _rowsArray = [[NSMutableArray alloc] init];
    //[_rowsArray removeAllObjects];
    for (int i=0; i<25; i++) {
        if(i%2==0)
        [_rowsArray addObject:@{
                                kASF_ROW_ID :
                                    @(i),
                                
                                kASF_ROW_CELLS :
                                    @[@{kASF_CELL_TITLE : @"2014-12-19", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                      @{kASF_CELL_TITLE : @"", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentLeft)},
                                      @{kASF_CELL_TITLE : @"", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                      @{kASF_CELL_TITLE : @"小明", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                       @{kASF_CELL_TITLE : @"查看", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                
                                kASF_ROW_OPTIONS :
                                    @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                      kASF_OPTION_CELL_PADDING : @(0),
                                      kASF_OPTION_CELL_BORDER_COLOR : [UIColor blueColor],
                                      kASF_OPTION_CELL_BORDER_SIZE : @(0.0)},
                                
                                
                                @"some_other_data" : @(123)}];
        else
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(i),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"Sample ID", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"Sample", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentLeft)},
                                          @{kASF_CELL_TITLE : @"Phone No.", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"Sample Gender", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(5),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor clearColor]},
                                    
                                    @"some_other_data" : @(123)}];
    }
    
    [_mASFTableView setRows:_rowsArray];
    [self.view addSubview:_mASFTableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASFTableViewDelegate
- (void)ASFTableView:(ASFTableView *)tableView DidSelectRow:(NSDictionary *)rowDict WithRowIndex:(NSUInteger)rowIndex {
    NSLog(@"%d", rowIndex);
}
@end
