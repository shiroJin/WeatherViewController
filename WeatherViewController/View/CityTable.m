//
//  CityTable.m
//  weatherForecast
//
//  Created by Macx on 16/2/4.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CityTable.h"
#import "CityCell.h"
#import "CityModel.h"

#define kCity @"cityCell"
@implementation CityTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[CityCell class] forCellReuseIdentifier:kCity];
    }
    return self;
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _citysWeather.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [self dequeueReusableCellWithIdentifier:kCity forIndexPath:indexPath];
    cell.weather = [_citysWeather objectForKey:[NSString stringWithFormat:@"%ld",  indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //...
}

@end
