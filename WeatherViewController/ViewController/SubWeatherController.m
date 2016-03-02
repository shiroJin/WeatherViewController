//
//  SubWeatherController.m
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "SubWeatherController.h"
#import "WeatherManager.h"
#import "WXRefresh.h"
#import "WeatherTable.h"
#import "WeatherModel.h"
#import "Common.h"
#import "MainController.h"

@interface SubWeatherController ()

@property (nonatomic, strong)WeatherTable *weatherTableView;

@end

@implementation SubWeatherController

- (void)dealloc
{
    NSLog(@"subController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_night_snow.jpg"]];
    
    if (self.cityId) {
        [self requestData:self.cityId];
    }

}

- (void)createTableView {
    self.weatherTableView = [[WeatherTable alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 48) style:UITableViewStylePlain];
    
    __weak typeof(self) wself = self;
    [self.weatherTableView addPullDownRefreshBlock:^{
        [wself requestData:self.cityId];
    }];
    
    [self.view addSubview:self.weatherTableView];
}


#pragma mark - 请求数据
- (void)requestData:(NSString *)cityid {
    
    NSString *url = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"cityid" : cityid
                                                                                  }];
    
    [WeatherManager request:url params:params completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self parseData:data];
    }];
    
}

#pragma mark - 解析数据
- (void)parseData:(id)result {
    
    if (!self.weatherTableView) {
        [self createTableView];
    }
    
    NSDictionary *resultDic = [result objectForKey:@"retData"];
    
    WeatherModel *weatherModel = [[WeatherModel alloc] initContentWithDic:resultDic];
    self.weatherTableView.weatherModel = weatherModel;
    _cityName = weatherModel.city;
    
    //数据更新
    [self.mainController updateWeatherData:weatherModel];
}

#pragma mark - Status Bar State

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setMainController:(MainController *)mainController {
    if (_mainController != mainController) {
        _mainController = mainController;
    }
}

@end
