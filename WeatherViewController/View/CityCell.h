//
//  CityCell.h
//  weatherForecast
//
//  Created by Macx on 16/2/4.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherModel;
@interface CityCell : UITableViewCell

@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *cityName;
@property (nonatomic, strong)UILabel *temp;

@property (nonatomic, strong)WeatherModel *weather;

@end
