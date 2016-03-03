//
//  AppDelegate.m
//  WeatherViewController
//
//  Created by Macx on 16/2/28.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "LeftViewController.h"
#import "SubWeatherController.h"
#import "WaterfallViewController.h"
#import "MainTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    WeatherManager *weatherManager = [WeatherManager sharedManager];
    NSArray *citys =  [weatherManager.cityArray copy];
    
    NSMutableArray *subControllers = [NSMutableArray array];
    for (NSString *cityId in citys) {
        SubWeatherController *subController = [[SubWeatherController alloc] init];
        subController.cityId = cityId;
        [subControllers addObject:subController];
    }
    
    LeftViewController *left = [[LeftViewController alloc] init];
    
    MainController *weatherMain = [[MainController alloc] initWithLeftViewController:left subViewControllers:subControllers];
    
    WaterfallViewController *waterfallController = [[WaterfallViewController alloc] init];
    
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    tabBarController.viewControllers = @[weatherMain, waterfallController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = tabBarController;
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
