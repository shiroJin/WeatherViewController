//
//  WeatherModel.h
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseModel.h"
#import "TodayModel.h"
#import "HistoryModel.h"
#import "ForecastModel.h"

@interface WeatherModel : BaseModel

@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *cityid;
@property (nonatomic, strong)TodayModel *today;
@property (nonatomic, copy)NSArray *historyArr;
@property (nonatomic, copy)NSArray *forecastArr;

@end
