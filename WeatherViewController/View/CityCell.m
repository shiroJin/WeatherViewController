//
//  CityCell.m
//  weatherForecast
//
//  Created by Macx on 16/2/4.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CityCell.h"
#import "WeatherModel.h"

@implementation CityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setWeather:(WeatherModel *)weather {
    if (_weather != weather) {
        _weather = weather;
        
        NSDictionary *types = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weatherType" ofType:@"plist"]];
        NSArray *arr = types.allKeys;
        
        NSString *iconStr;
        if (_weather.today.type.length > 0) {
            NSString *type = _weather.today.type;
            for (NSString *weatherType in arr) {
                if ([type isEqualToString:weatherType]) {
                    iconStr = [types objectForKey:type];
                    break;
                }
            }
        }
        
        if (iconStr.length > 0) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"w%@", iconStr]];
            self.icon.image = img;
        }
        
        self.cityName.text = _weather.city;
        self.temp.text = _weather.today.curTemp;
    }
}

#pragma mark - Getter Method
@synthesize icon = _icon;
@synthesize cityName = _cityName;
@synthesize temp = _temp;

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        _icon.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1];
        _icon.layer.cornerRadius = 20;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)cityName {
    if (!_cityName) {
        _cityName = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 60, 40)];
        _cityName.font = [UIFont systemFontOfSize:14];
        _cityName.textAlignment = NSTextAlignmentCenter;
        _cityName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cityName];
    }
    return _cityName;
}

- (UILabel *)temp {
    if (!_temp) {
        _temp = [[UILabel alloc] initWithFrame:CGRectMake(kLeftLength - 10 - 40, 10, 40, 40)];
        _temp.font = [UIFont systemFontOfSize:14];
        _temp.textAlignment = NSTextAlignmentCenter;
        _temp.textColor = [UIColor blackColor];
        [self.contentView addSubview:_temp];
    }
    return _temp;
}


@end
