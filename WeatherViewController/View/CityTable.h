//
//  CityTable.h
//  weatherForecast
//
//  Created by Macx on 16/2/4.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTable : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSArray *citysWeather;

@end
