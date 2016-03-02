//
//  LeftViewController.m
//  WeatherViewController
//
//  Created by Macx on 16/2/29.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "LeftViewController.h"
#import "CityTable.h"
#import "SearchController.h"
#import "WeatherModel.h"

@interface LeftViewController ()

@property (nonatomic, strong)CityTable *cityTableView;
@property (nonatomic, strong)UIView *customBar;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createCustomBar];
}

- (void)setCitysWeather:(NSArray *)citysWeather {
    //返回的数组地址不变。。所以没多大用啊！
    self.cityTableView.citysWeather = citysWeather;
    [self.cityTableView reloadData];
}

- (void)createTableView {
    self.cityTableView = [[CityTable alloc] initWithFrame:CGRectMake(0, 64, kLeftLength, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.cityTableView];
}

#pragma mark - NavigationBar Items

- (void)createCustomBar {
    self.customBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    self.customBar.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:self.customBar];
    
    //add btn
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, 30, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"left_drawer_add_city_normal"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCitys) forControlEvents:UIControlEventTouchUpInside];
    [self.customBar addSubview:addBtn];
    
    //eidt btn
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(kLeftLength - 40, 30, 40, 25);
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [self.customBar addSubview:editBtn];
}

- (void)addCitys {
    SearchController *searchController = [[SearchController alloc] init];
    [self presentViewController:searchController animated:YES completion:NULL];
}

- (void)edit {
    //编辑模式
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setMainController:(MainController *)mainController {
    if (_mainController != mainController) {
        _mainController = mainController;
    }
}

@end
