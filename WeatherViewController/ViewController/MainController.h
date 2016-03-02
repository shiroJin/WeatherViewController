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
@class WeatherModel;
@class LeftViewController;

@interface MainController : UIViewController

@property (nonatomic, readonly, strong)UIViewController<MainControllerChild> *leftViewContrller;

@property (nonatomic, readonly, strong)UIView *leftView;

@property (nonatomic, strong)NSMutableArray *viewControllers;

@property (nonatomic, readonly, strong)UIView *centerView;

@property (nonatomic, readonly, getter=isClose, assign)BOOL close;

@property (nonatomic, strong)NSMutableArray *weatherData;

- (instancetype)initWithLeftViewController:(UIViewController<MainControllerChild> *)leftViewController subViewControllers:(NSArray *)viewControllers;

- (void)updateWeatherData:(WeatherModel *)weatherModel;

@end
