//
//  UIViewController+AppDelegate.m
//  weatherForecast
//
//  Created by Macx on 16/2/4.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "UIViewController+AppDelegate.h"
#import "AppDelegate.h"

@implementation UIViewController (AppDelegate)

//获取appDelegate。
- (AppDelegate *)appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}


@end
