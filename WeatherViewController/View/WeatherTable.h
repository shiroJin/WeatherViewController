//
//  WeatherTable.h
//  weatherForecast
//
//  Created by Macx on 16/2/3.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherModel;
@interface WeatherTable : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)WeatherModel *weatherModel;

@end
