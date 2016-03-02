//
//  SubWeatherController.h
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface SubWeatherController : UIViewController<MainControllerChild>

@property (nonatomic, copy)NSString *cityId;
@property (nonatomic, weak)MainController *mainController;
@property (nonatomic, readonly, copy)NSString *cityName;

@end
