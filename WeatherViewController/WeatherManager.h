//
//  WeatherManager.h
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompeletionBlock) (id _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface WeatherManager : NSObject

+ (_Nonnull instancetype)sharedManager;

@property (nonatomic, strong)NSMutableArray *cityArray;

- (void)updateData:(NSString *)cityId;

/**
 *  请求数据，并返回JSON数据。
 *
 *  @param url              url
 *  @param params           请求参数
 *  @param compeletionBlock 数据请求完成后的操作
 */
+ (void)request:(NSString * _Nullable)url params:(NSMutableDictionary *_Nullable)params completionHandler:(CompeletionBlock _Nullable)compeletionBlock;

@end
