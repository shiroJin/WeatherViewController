//
//  WeatherManager.m
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherModel.h"
#import "CityModel.h"

@interface WeatherManager ()

@property (nonatomic, strong)NSUserDefaults *userDefaults;

@end

@implementation WeatherManager

#pragma mark - 初始化方法
+ (instancetype)sharedManager {
    static WeatherManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[WeatherManager alloc] init];
        manager.userDefaults = [NSUserDefaults standardUserDefaults];
        
        //获得城市列表
        if ([manager.userDefaults objectForKey:@"citys"]) {
            manager.cityArray = [[manager.userDefaults objectForKey:@"citys"] mutableCopy];
            
//            [manager.cityArray removeAllObjects];
//            [manager.cityArray addObject:@"101210101"];
//            [manager.cityArray addObject:@"101020100"];
//            [manager.userDefaults setObject:manager.cityArray forKey:@"citys"];
            
            for (NSString *cityId in manager.cityArray) {
                if ([cityId isEqualToString:@"101210101"]) {
                    break;
                }
            }
        }
        else {
            manager.cityArray = [NSMutableArray array];
            [manager.cityArray addObject:@"101210101"];
        }
        NSLog(@"%@", manager.cityArray);

    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //...
    }
    return self;
}

#pragma mark - 更新数据

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
//        同步数据
//        [self.userDefaults setObject:self.cityArray forKey:@"citys"];
//        [self.userDefaults synchronize];
        //发送更新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
    }
    else {
        return;
    }
}


#pragma mark - 天气数据请求
- (void)request:(NSString *)url params:(NSMutableDictionary *)params key:(NSString *)key completionHandler:(CompeletionBlock)compeletionBlock {
    
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
            //json 解析
            NSError *jsonError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                [self parseData:jsonData key:(NSString *)key];
                //更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    compeletionBlock([self.weatherDataDic objectForKey:key]);
                });
            }
        }
    }];
    
    [dataTask resume];
}

- (void)parseData:(id)data key:(NSString *)key {
    //解析数据
    NSDictionary *resultDic = [data objectForKey:@"retData"];
    
    WeatherModel *weatherModel = [[WeatherModel alloc] initContentWithDic:resultDic];
    [self.weatherDataDic setValue:weatherModel forKey:key];
}

#pragma mark - 搜索城市
- (void)requestCity:(NSString *)url params:(NSMutableDictionary *)params completionHandler:(SearchBlock)searchBlock {
    
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
            //json 解析
            NSError *jsonError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                __block NSMutableArray *citys = [NSMutableArray array];
                
                NSArray *resultDic = [jsonData objectForKey:@"retData"];
                for (NSDictionary *dic in resultDic) {
                    CityModel *city = [[CityModel alloc] initContentWithDic:dic];
                    [citys addObject:city];
                }
                //更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    searchBlock(citys);
                });
            }
        }
    }];
    
    [dataTask resume];
}

#pragma mark - lazy load
- (NSMutableDictionary *)weatherDataDic {
    if (!_weatherDataDic) {
        _weatherDataDic = [NSMutableDictionary dictionary];
    }
    return _weatherDataDic;
}


@end
