//
//  WeatherManager.h
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherModel;
typedef void (^CompeletionBlock) (WeatherModel *weatherModel);
typedef void (^SearchBlock) (NSArray *arr);

@interface WeatherManager : NSObject

+ (_Nonnull instancetype)sharedManager;

@property (nonatomic, strong)NSMutableArray *cityArray;
@property (nonatomic, strong)NSMutableDictionary *weatherDataDic;

- (void)updateData:(NSString *)cityId;

//请求数据
- (void)request:(NSString * _Nullable)url params:(NSMutableDictionary *_Nullable)params key:(NSString *)key completionHandler:(CompeletionBlock _Nullable)compeletionBlock;
- (void)requestCity:(NSString *)url params:(NSMutableDictionary *)params completionHandler:(SearchBlock)searchBlock;

//+ (void)request:(NSString *)url params:(NSMutableDictionary *)params completionHandler:(CompeletionBlock)

@end
