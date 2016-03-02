//
//  WeatherTable.m
//  weatherForecast
//
//  Created by Macx on 16/2/3.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherTable.h"
#import "CurrentWeatherCell.h"
#import "WeatherModel.h"
#import "WXRefresh.h"

#define kToday @"todayCell"
@implementation WeatherTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"CurrentWeatherCell" bundle:nil] forCellReuseIdentifier:kToday];
        self.dataSource = self;
        self.delegate = self;
    
    }
    return self;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrentWeatherCell *cell = [self dequeueReusableCellWithIdentifier:kToday];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.today = _weatherModel.today;
    
    return cell;
}

//set model
- (void)setWeatherModel:(WeatherModel *)weatherModel {
    if (_weatherModel != weatherModel) {
        _weatherModel = weatherModel;
        
        [self reloadData];
        [self.pullToRefreshView stopAnimating];
    }
}

@end
