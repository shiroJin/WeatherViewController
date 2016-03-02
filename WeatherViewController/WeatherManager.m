//
//  WeatherManager.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherManager.h"

@interface WeatherManager ()

@property (nonatomic, strong)NSUserDefaults *userDefaults;

@end

@implementation WeatherManager


+ (instancetype)sharedManager {
    static WeatherManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[WeatherManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        
        //get citys list
        if ([self.userDefaults objectForKey:@"citys"]) {
            self.cityArray = [[self.userDefaults objectForKey:@"citys"] mutableCopy];
            for (NSString *cityId in self.cityArray) {
                if ([cityId isEqualToString:@"101210101"]) {
                    break;
                }
            }
            [self.cityArray addObject:@"101210101"];
        }
        else {
            self.cityArray = [NSMutableArray array];
            [self.cityArray addObject:@"101210101"];
        }
        NSLog(@"%@", self.cityArray);
    }
    return self;
}

//更新数据
- (void)updateData:(NSString *)cityId {
    
    //判断城市列表中是否已经存在。
    __block BOOL isSave = NO;
    [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:cityId]) {
            isSave = YES;
            *stop = YES;
        }
    }];
    
    if (!isSave) {
        [self.cityArray addObject:cityId];
        
        [self.userDefaults setObject:self.cityArray forKey:@"citys"];
        [self.userDefaults synchronize];
        //发送更新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
    }
    else {
        return;
    }
}


#pragma mark - 数据请求
+ (void)request:(NSString *)url params:(NSMutableDictionary *)params completionHandler:(CompeletionBlock)compeletionBlock {
    
    __block NSMutableString *param = [NSMutableString string];//GET方法拼接参数的字符串
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [param appendFormat:@"%@=%@&", key, obj];
    }];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", url, param];
    //对URL进行转码
    NSString *encodeStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodeStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.HTTPMethod = @"GET";
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [request setValue:@"f4386168b45e296010c025ebe3cb0ced" forHTTPHeaderField:@"apikey"];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    compeletionBlock(jsonData, response, error);
                });
            }
        }
    }];
    
    [dataTask resume];
}

@end
