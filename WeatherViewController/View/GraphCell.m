
//
//  GraphCell.m
//  WeatherViewController
//
//  Created by Macx on 16/3/6.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "GraphCell.h"
#import "GraphView.h"

@interface GraphCell ()

@property (nonatomic, strong)GraphView *graphView;

@end

@implementation GraphCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.graphView = [[GraphView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.graphView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        scroll.contentSize = CGSizeMake(50 * 12, 300);
        [self.contentView addSubview:scroll];
        self.graphView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        [scroll addSubview:self.graphView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setWeatherModel:(WeatherModel *)weatherModel {
    _weatherModel = weatherModel;
    self.graphView.weatherModel = weatherModel;
}

@end
