//
//  MainController.m
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MainController.h"
#import "SubWeatherController.h"
#import "LeftViewController.h"
#import "Common.h"

@interface MainController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollerView;//centerView滑动视图
@property (nonatomic, strong)UIView *customBar;//导航栏
@property (nonatomic, strong)UIPageControl *pageControl;//pageControl多页控件
@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;//拖动手势
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;//点击手势
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation MainController

- (instancetype)initWithLeftViewController:(UIViewController<MainControllerChild> *)leftViewController subViewControllers:(NSArray *)viewControllers {
    self = [super init];
    if (self) {
        _leftViewContrller = leftViewController;
        if ([self.leftViewContrller respondsToSelector:@selector(setMainController:)]) {
            self.leftViewContrller.mainController = self;
        }
        self.viewControllers = [viewControllers mutableCopy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"updateData" object:nil];
    }
    return self;
}

- (void)update {
    WeatherManager *weatherManager = [WeatherManager sharedManager];
    NSString *cityId = weatherManager.cityArray.lastObject;
    SubWeatherController *subController = [[SubWeatherController alloc] init];
    subController.cityId = cityId;
    [self.viewControllers addObject:subController];
    
    [self layoutSubviews];
    [self.scrollerView setContentOffset:CGPointMake(kScreenWidth * (self.viewControllers.count - 1), 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _centerView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.centerView];
    [self.view insertSubview:self.leftView belowSubview:self.centerView];
    
    [self createScroller];
    [self createCustomBar];
    [self createPageControl];
    
    //手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
}

- (void)createPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 10)];
    self.pageControl.numberOfPages = self.viewControllers.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    self.pageControl.currentPage = 0;
    
    [self.centerView addSubview:self.pageControl];
}

//创建导航栏
- (void)createCustomBar {
    self.customBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.customBar.backgroundColor = [UIColor clearColor];
    [self.centerView addSubview:self.customBar];
    
    //侧滑Btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 32, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customBar addSubview:leftBtn];
    
    //title label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 60) / 2, 20, 60, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"杭州";
    [self.customBar addSubview:_titleLabel];
}

//显示侧边栏
- (void)openAction {
    [self configLeftView];
    ((LeftViewController *)self.leftViewContrller).citysWeather = self.weatherData;
    
    [self openAnimation];
    self.scrollerView.scrollEnabled = NO;
    [self.centerView addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)configLeftView {
    [self addChildViewController:self.leftViewContrller];
    self.leftViewContrller.view.frame = self.leftView.bounds;
    [self.leftView addSubview:self.leftViewContrller.view];
}

//创建滑动视图
- (void)createScroller {
    self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.bounds.size.width, self.centerView.bounds.size.height)];
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.bounces = NO;
    self.scrollerView.delegate = self;
    self.scrollerView.contentSize = CGSizeMake(self.centerView.bounds.size.width * self.viewControllers.count, self.centerView.bounds.size.height);
    [self.centerView addSubview:self.scrollerView];
    
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * self.scrollerView.bounds.size.width, 0, self.scrollerView.bounds.size.width, self.scrollerView.bounds.size.height)];
        
        SubWeatherController *viewController = self.viewControllers[i];
        [self addChildViewController:viewController];
        viewController.view.frame = self.view.bounds;
        viewController.mainController = self;
        [viewController didMoveToParentViewController:self];
        //滑动视图中添加视图
        [view addSubview:viewController.view];
        [self.scrollerView addSubview:view];
    }
}

#pragma mark - Scroller View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //
    CGFloat offsetX = self.scrollerView.contentOffset.x;
    NSInteger currentIndex = offsetX / kScreenWidth;
    if (currentIndex != self.currentIndex) {
        self.pageControl.currentPage = currentIndex;
        self.currentIndex = currentIndex;
        self.titleLabel.text = ((SubWeatherController *)self.viewControllers[currentIndex]).cityName;
    }
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
    [self closeAnimation];
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
        ((LeftViewController *)self.leftViewContrller).citysWeather = self.weatherData;
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
        self.scrollerView.scrollEnabled = YES;
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
