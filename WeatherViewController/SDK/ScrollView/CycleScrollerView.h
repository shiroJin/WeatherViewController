//
//  CycleScrollerView.h
//  AutoScrollerView
//
//  Created by Macx on 16/2/8.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollerView : UIView <UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame imgs:(NSArray *)imgArr isNetImage:(BOOL)isNet;

@property (nonatomic, assign) CGFloat timeInterval;//默认为1.5s

@end
