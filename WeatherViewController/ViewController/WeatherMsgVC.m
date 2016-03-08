//
//  WeatherMsgVC.m
//  WeatherViewController
//
//  Created by Macx on 16/3/5.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherMsgVC.h"
#import "WeatherModel.h"
#import "WeatherTable.h"
#import "WXRefresh.h"
#import "WeatherTabBarController.h"
#import "MainController.h"

@interface WeatherMsgVC () <UIScrollViewDelegate>

@property (nonatomic, strong)UIView *customBar;//导航栏
@property (nonatomic, strong)UIPageControl *pageControl;//pageControl多页控件
@property (nonatomic, strong)UILabel *titleLabel;//城市标题
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong)WeatherManager *weatherManager;

@end

@implementation WeatherMsgVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"updateData" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sunny.jpg"]];
    //请求数据
    NSArray *cityArr = [self.weatherManager.cityArray copy];
    for (int i = 0; i < cityArr.count; i++) {
        NSString *cityId = cityArr[i];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self requestData:cityId key:[NSString stringWithFormat:@"%d", i]];
        });
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self createScroll];
    });
    
    [self createCustomBar];
    [self createPageControl];
}

#pragma mark - 新城市添加
- (void)update {
    //更新PageControl
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    [self createPageControl];
    
    NSInteger count = self.weatherManager.cityArray.count;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * count, kScreenHeight - 64 - 48);
    WeatherTable *newTableView = [[WeatherTable alloc] initWithFrame:CGRectMake(kScreenWidth * (count - 1), 0, kScreenWidth, kScreenHeight - 64 - 48)];
    [newTableView addPullDownRefreshBlock:^{
        [self refreshData:self.weatherManager.cityArray[count - 1] index:count - 1];
    }];
    
    [self.scrollView addSubview:newTableView];
    [self.weatherView addObject:newTableView];
    //请求数据
    [self refreshData:self.weatherManager.cityArray.lastObject index:count - 1];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth * (count - 1), 0);
}

#pragma mark - Custom Bar

- (void)createPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 10)];
    self.pageControl.numberOfPages = [WeatherManager sharedManager].cityArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

//创建导航栏
- (void)createCustomBar {
    self.customBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.customBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.customBar];
    
    //侧滑Btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 34, 30, 30);
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

- (void)openAction {
    [((WeatherTabBarController *)self.tabBarController).mainController openLeftView];
}


#pragma mark - 请求数据

- (void)requestData:(NSString *)cityId key:(NSString *)key {
    NSDictionary *params = @{
                             @"cityid" : cityId,
                             };
    [[self weatherManager] request:kRecentWeather params:[params mutableCopy] key:key completionHandler:^(WeatherModel *weatherModel) {
        //...
        [self.dataDic setValue:weatherModel forKey:key];
        if (self.dataDic.count == self.weatherManager.cityArray.count) {
            //update UI
            [self layoutSubViews];
        }
    }];
}

- (void)refreshData:(NSString *)cityId index:(NSInteger)index {
    
    NSDictionary *params = @{
                             @"cityid" : cityId,
                             };
    [self.weatherManager request:kRecentWeather params:[params mutableCopy] key:[NSString stringWithFormat:@"%ld", index] completionHandler:^(WeatherModel *weatherModel) {
        //下拉刷新
        [self.dataDic setValue:weatherModel forKey:[NSString stringWithFormat:@"%ld", index]];
        [self.weatherManager.weatherDataDic setValue:weatherModel forKey:[NSString stringWithFormat:@"%ld", index]];
        
        WeatherTable *tableView = self.weatherView[index];
        tableView.weatherModel = weatherModel;
    }];
}

#pragma mark - UI

- (void)createScroll {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 48)];
    self.scrollView.contentSize = CGSizeMake(self.weatherManager.cityArray.count * kScreenWidth, kScreenHeight - 64 - 48);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
}

- (void)layoutSubViews {
    
    for (int i = 0; i < _dataDic.count; i++) {
        WeatherTable *tableView = [[WeatherTable alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight - 64 - 48)];
        [self.scrollView addSubview:tableView];
        tableView.weatherModel = [self.dataDic objectForKey:[NSString stringWithFormat:@"%d", i]];
        [tableView addPullDownRefreshBlock:^{
            [self refreshData:self.weatherManager.cityArray[i] index:i];
        }];
        
        [self.weatherView addObject:tableView];
    }
    
    [self.view addSubview:self.scrollView];
}

#pragma mark - Scroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / kScreenWidth;
    self.pageControl.currentPage = index;
    self.titleLabel.text = ((WeatherModel *)[self.dataDic objectForKey:[NSString stringWithFormat:@"%ld", index]]).city;
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGFloat offsetX = [touch locationInView:self.scrollView].x;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.scrollView resignFirstResponder];
}

#pragma mark - getter
- (WeatherManager *)weatherManager {
    if (!_weatherManager) {
        _weatherManager = [WeatherManager sharedManager];
    }
    return _weatherManager;
}

- (NSMutableArray *)weatherView {
    if (!_weatherView) {
        _weatherView = [NSMutableArray array];
    }
    return _weatherView;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

@end
