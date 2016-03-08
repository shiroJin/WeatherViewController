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
#import "GraphCell.h"

#define kToday @"todayWeatherCell"
#define kGraph @"graphCell"

@implementation WeatherTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:@"CurrentWeatherCell" bundle:nil] forCellReuseIdentifier:kToday];
        [self registerNib:[UINib nibWithNibName:@"GraphCell" bundle:nil] forCellReuseIdentifier:kGraph];
    }
    return self;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CurrentWeatherCell *cell = [self dequeueReusableCellWithIdentifier:kToday];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.weatherModel = _weatherModel;
        return cell;
    }
    else {
        GraphCell *graphCell = [self dequeueReusableCellWithIdentifier:kGraph forIndexPath:indexPath];
        graphCell.weatherModel = self.weatherModel;
        return graphCell;
    }
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
