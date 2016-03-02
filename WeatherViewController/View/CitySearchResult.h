//
//  CitySearchResult.h
//  weatherForecast
//
//  Created by Macx on 16/2/5.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySearchResult : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSArray *cityModels;

@end
