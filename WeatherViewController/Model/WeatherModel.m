//
//  WeatherModel.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    
    _today = [[TodayModel alloc] initContentWithDic:[jsonDic objectForKey:@"today"]];
    
}

@end
