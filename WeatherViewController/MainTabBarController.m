//
//  MainTabBarController.m
//  WeatherViewController
//
//  Created by Macx on 16/3/3.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@property (nonatomic, strong)UIView *customBar;

@end

@implementation MainTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBar.hidden = YES;
    [self configTabBar];
}

- (void)configTabBar {
    self.customBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 48, kScreenWidth, 48)];
    self.customBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customBar];
    
    NSArray *arr = @[@"天气", @"美图"];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((kScreenWidth / 2) * i, 0, kScreenWidth / 2, 48);
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.customBar addSubview:btn];
    }
}

- (void)click:(UIButton *)sender {
    NSInteger index = sender.tag;
    self.selectedIndex = index;
}

@end
