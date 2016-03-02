//
//  CitySearchResult.m
//  weatherForecast
//
//  Created by Macx on 16/2/5.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CitySearchResult.h"
#import "CityModel.h"
#import "UIView+ViewController.h"

#define kCity @"searchResult"

@implementation CitySearchResult

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:kCity];
    }
    return self;
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:kCity];
    
    CityModel *city = _cityModels[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@-%@", city.province_cn, city.district_cn, city.name_cn];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择城市");
    
    //update data
    WeatherManager *weatherManager = [WeatherManager sharedManager];
    NSString *cityId = ((CityModel *)self.cityModels[indexPath.row]).area_id;
    [weatherManager updateData:cityId];
    
    [self deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewController dismissViewControllerAnimated:YES completion:NULL];
}


@end
