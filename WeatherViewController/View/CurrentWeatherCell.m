//
//  CurrentWeatherCell.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CurrentWeatherCell.h"
#import "ForeCastView.h"

@interface CurrentWeatherCell ()

@property (nonatomic, strong)ForeCastView *forecastView;

@end
@implementation CurrentWeatherCell

- (void)awakeFromNib {
    // Initialization code
    _forecastView = [[ForeCastView alloc] initWithFrame:CGRectMake(kScreenWidth - 160, 150, 150, 100)];
    _forecastView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_forecastView];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setWeatherModel:(WeatherModel *)weatherModel {
    if (_weatherModel != weatherModel) {
        _weatherModel = weatherModel;
        
        _aqi.text = _weatherModel.today.aqi;
        _date.text = _weatherModel.today.date;
        _type.text = _weatherModel.today.type;
        _temp.text = _weatherModel.today.curTemp;
        _fengli.text = [NSString stringWithFormat:@"风向：%@ 风力：%@", _weatherModel.today.fengxiang, _weatherModel.today.fengli];
        _forecastView.forecast = self.weatherModel.forecastArr[0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
