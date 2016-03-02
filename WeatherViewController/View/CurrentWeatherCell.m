//
//  CurrentWeatherCell.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CurrentWeatherCell.h"

@implementation CurrentWeatherCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setToday:(TodayModel *)today {
    if (_today != today) {
        _today = today;
        
        _aqi.text = _today.aqi;
        _date.text = _today.date;
        _type.text = _today.type;
        _temp.text = _today.curTemp;
        _fengli.text = [NSString stringWithFormat:@"风向：%@ 风力：%@", _today.fengxiang, _today.fengli];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
