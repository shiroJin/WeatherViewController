//
//  WeatherModel.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherModel.h"

@interface WeatherModel ()

@property (nonatomic, strong)NSMutableArray *history;
@property (nonatomic, strong)NSMutableArray *forecast;

@end

@implementation WeatherModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    
    _today = [[TodayModel alloc] initContentWithDic:[jsonDic objectForKey:@"today"]];
    //历史天气
    self.history = [NSMutableArray array];
    for (NSDictionary *dic in jsonDic[@"history"]) {
        HistoryModel *history = [[HistoryModel alloc] initContentWithDic:dic];
        [self.history addObject:history];
    }
    self.historyArr = [self.history copy];
    //预报天气
    self.forecast = [NSMutableArray array];
    for (NSDictionary *dic in jsonDic[@"forecast"]) {
        ForecastModel *forecast = [[ForecastModel alloc] initContentWithDic:dic];
        [self.forecast addObject:forecast];
    }
    self.forecastArr = [self.forecast copy];
}

@end
