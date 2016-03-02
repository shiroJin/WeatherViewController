//
//  LeftViewController.h
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface LeftViewController : UIViewController<MainControllerChild>

@property (nonatomic, copy)NSArray *citysWeather;

@property (nonatomic, weak)MainController *mainController;

@end
