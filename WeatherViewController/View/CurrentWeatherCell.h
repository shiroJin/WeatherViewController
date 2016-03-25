//
//  CurrentWeatherCell.h
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
@class TempView;
@interface CurrentWeatherCell : UITableViewCell

@property (nonatomic, strong) WeatherModel *weatherModel;

@property (weak, nonatomic) IBOutlet UILabel *aqi;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *fengli;
@property (weak, nonatomic) IBOutlet TempView *temp;

@end
