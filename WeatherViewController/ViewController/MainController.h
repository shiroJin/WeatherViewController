//
//  MainController.h
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

//protocol
@class MainController;
@protocol MainControllerChild <NSObject>

@property (nonatomic, weak)MainController *mainController;

@end

//mainController
@class LeftViewController;
@class WeatherModel;
@class WeatherTabBarController;

@interface MainController : UIViewController

@property (nonatomic, readonly, strong)LeftViewController<MainControllerChild> *leftViewContrller;

@property (nonatomic, readonly, strong)UIView *leftView;

@property (nonatomic, readonly, strong)WeatherTabBarController *tabBarController;

@property (nonatomic, readonly, strong)UIView *centerView;

@property (nonatomic, readonly, getter=isClose, assign)BOOL close;

@property (nonatomic, strong)NSMutableArray *weatherData;

//初始化方法
- (instancetype)initWithLeftViewController:(UIViewController<MainControllerChild> *)leftViewController centerViewController:(WeatherTabBarController<MainControllerChild> *)tabBarController;

- (void)openLeftView;

- (void)updateWeatherData:(WeatherModel *)weatherModel;

@end
