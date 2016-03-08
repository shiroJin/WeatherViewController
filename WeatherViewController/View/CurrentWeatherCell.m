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

@property (nonatomic, strong)UIView *forecast;
@property (nonatomic, strong)ForeCastView *tomorrow;
@property (nonatomic, strong)ForeCastView *dayAfterTomorrow;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation CurrentWeatherCell

- (void)awakeFromNib {
    // Initialization code

    self.forecast = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 150 - 10, 50, 150, 100)];
    self.tomorrow = [[ForeCastView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    self.dayAfterTomorrow = [[ForeCastView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    [self.forecast addSubview:self.tomorrow];
    [self.forecast addSubview:self.dayAfterTomorrow];
    [self.contentView addSubview:self.forecast];
    
    self.forecast.backgroundColor = [UIColor colorWithRed:50/255.0 green:100/255.0 blue:150/255.0 alpha:1];
    self.tomorrow.backgroundColor = [UIColor colorWithRed:50/255.0 green:100/255.0 blue:150/255.0 alpha:1];
    self.dayAfterTomorrow.backgroundColor = [UIColor colorWithRed:50/255.0 green:100/255.0 blue:150/255.0 alpha:1];

    
    [self setupTimer];
}

- (void)setupTimer {
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:6.0f target:self selector:@selector(exchangeView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)exchangeView {
    
    [UIView transitionWithView:self.forecast duration:1.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self.forecast exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:NULL];

//    [self.forecast exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    //    转场动画
//    CATransition *transition = [[CATransition alloc] init];
//    transition.type = @"rippleEffect";
//    transition.subtype = kCATransitionFromLeft;
//    transition.duration = 2;
//    [self.forecast.layer addAnimation:transition forKey:nil];

}

- (void)setWeatherModel:(WeatherModel *)weatherModel {
    if (_weatherModel != weatherModel) {
        _weatherModel = weatherModel;
        
        _aqi.text = [NSString stringWithFormat:@"空气指数:%@", _weatherModel.today.aqi];
        _date.text = _weatherModel.today.date;
        _type.text = _weatherModel.today.type;
        _temp.text = _weatherModel.today.curTemp;
        _fengli.text = [NSString stringWithFormat:@"风向：%@ 风力：%@", _weatherModel.today.fengxiang, _weatherModel.today.fengli];
        //forecast
        self.tomorrow.forecast = self.weatherModel.forecastArr[0];
        self.dayAfterTomorrow.forecast = self.weatherModel.forecastArr[1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
