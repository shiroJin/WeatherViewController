//
//  SearchController.m
//  WeatherViewController
//
//  Created by Macx on 16/3/1.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "SearchController.h"
#import "WeatherManager.h"
#import "CityModel.h"
#import "CitySearchResult.h"

@interface SearchController ()<UITextFieldDelegate>
{
    CitySearchResult *_citySearchReslut;
}
@property (nonatomic, strong)UITextField *textField;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSearchView];
    [self createBackBtn];
    [self createTableView];
    
}

#pragma mark - 搜索视图
- (void)createSearchView {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth - 60, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"想要查看的城市";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeySearch;
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_search"]];
    _textField.leftView = img;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
}

//返回按钮
- (void)createBackBtn {
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    back.frame = CGRectMake(kScreenWidth - 40, 20, 30, 30);
    back.layer.cornerRadius = 10;
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:back];
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.textField resignFirstResponder];
}


//文本框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    //do something
    [self search];
    
    return YES;
}

- (void)createTableView {
    _citySearchReslut = [[CitySearchResult alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 200) style:UITableViewStylePlain];
    [self.view addSubview:_citySearchReslut];
}

#pragma mark - 网络请求,数据解析
- (void)search {
    NSString *city = _textField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:city forKey:@"cityname"];
    
    [WeatherManager request:kSearchCityURL params:params completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self parseData:data];
    }];
}

- (void)parseData:(id)data {
    if (data) {
        NSDictionary *resultDic = [data objectForKey:@"retData"];
        for (NSDictionary *dic in resultDic) {
            CityModel *city = [[CityModel alloc] initContentWithDic:dic];
            [self.cityModels addObject:city];
        }
        
        _citySearchReslut.cityModels = self.cityModels;
        [_citySearchReslut reloadData];
    }
}

@synthesize cityModels = _cityModels;

- (NSArray *)cityModels {
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    
    return _cityModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
