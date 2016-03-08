//
//  MainController.m
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MainController.h"
#import "LeftViewController.h"
#import "Common.h"
#import "WeatherTabBarController.h"

@interface MainController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;//拖动手势
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;//点击手势
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)UIViewController *currentViewController;

@end

@implementation MainController

//初始化方法
- (instancetype)initWithLeftViewController:(LeftViewController<MainControllerChild> *)leftViewController centerViewController:(WeatherTabBarController<MainControllerChild> *)tabBarController {
    self = [super init];
    if (self) {
        _leftViewContrller = leftViewController;
        _tabBarController = tabBarController;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLeftView) name:@"updateData" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubviews];
}

// UI
- (void)layoutSubviews {
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _centerView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.centerView];
    [self.view insertSubview:self.leftView belowSubview:self.centerView];
    
    // Add tabBar Controller
    [self addChildViewController:self.tabBarController];
    self.tabBarController.mainController = self;
    [self.tabBarController didMoveToParentViewController:self];

    [self.centerView addSubview:self.tabBarController.view];
    self.tabBarController.view.frame = self.centerView.bounds;
    
    //手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
}


//显示侧边栏
- (void)openLeftView {
    [self addChildViewController:self.leftViewContrller];
    self.leftViewContrller.view.frame = self.leftView.bounds;
    [self.leftView addSubview:self.leftViewContrller.view];
    
    [self openAnimation];
    [self.centerView addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.panGesture];
}

//关闭侧边栏
- (void)closeLeftView {
    [self closeAnimation];
    [self.centerView removeGestureRecognizer:self.tapGesture];
    [self.view removeGestureRecognizer:self.panGesture];
}

#pragma mark - 手势事件

//Pan Event
- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    static CGFloat x;
    CGPoint location;
    CGFloat delta;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        location = [panGesture locationInView:self.centerView];
        x = location.x;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        location = [panGesture locationInView:self.view];
        delta = location.x - x;
        //
        if (delta > kLeftLength) {
            return;
        }
        
        CGRect leftFrame = CGRectMake(- kLeftLength + delta, 0, kLeftLength, kScreenHeight);
        CGRect centerFrame = CGRectMake(delta, 0, kScreenWidth, kScreenHeight);
        
        self.leftView.frame = leftFrame;
        self.centerView.frame = centerFrame;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        location = [panGesture locationInView:self.view];
        delta = location.x - x;
        if ([panGesture velocityInView:self.view].x < 0.0f) {
            [self closeAnimation];
            [self.view removeGestureRecognizer:self.panGesture];
        }
        else if (delta < - kLeftLength / 2) {
            
            //            if (self.isClose) {
            //                [self openAnimation];
            //                [self.centerView addGestureRecognizer:self.tapGesture];
            //            }
            //            else {
            [self closeAnimation];
            [self.view removeGestureRecognizer:self.tapGesture];
            //            }
        }
    }
}

//Tap Event
- (void)tapAction {
    [self closeLeftView];
}


#pragma mark - 动画

- (void)openAnimation {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect leftFrame = CGRectMake(0, 0, kLeftLength, kScreenHeight);
        CGRect centerFrame = CGRectMake(kLeftLength, 0, kScreenWidth, kScreenHeight);
        self.leftView.frame = leftFrame;
        self.centerView.frame = centerFrame;
    } completion:^(BOOL finished) {
        //do something else
//        self.currentViewController = self.leftViewContrller;
    }];
}

- (void)closeAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect leftFrame = CGRectMake(- kLeftLength, 0, kLeftLength, kScreenHeight);
        CGRect centerFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.leftView.frame = leftFrame;
        self.centerView.frame = centerFrame;
    } completion:^(BOOL finished) {
        //do something else
        [self.view removeGestureRecognizer:self.panGesture];
        [self.centerView removeGestureRecognizer:self.tapGesture];
//        self.currentViewController = self.viewControllers[self.currentIndex];
    }];
}

#pragma mark - Update Data

- (void)updateWeatherData:(WeatherModel *)weatherModel {
    if (self.weatherData.count > (self.currentIndex + 1)) {
        [self.weatherData replaceObjectAtIndex:self.currentIndex withObject:weatherModel];
    }
    else {
        [self.weatherData addObject:weatherModel];
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)weatherData {
    if (!_weatherData) {
        _weatherData = [NSMutableArray array];
    }
    return _weatherData;
}


#pragma mark - Status Bar State
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
