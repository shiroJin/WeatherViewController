//
//  TodayModel.h
//  weatherForecast
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseModel.h"
@interface TodayModel : BaseModel

@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *week;
@property (nonatomic, copy)NSString *curTemp;
@property (nonatomic, copy)NSString *fengxiang;
@property (nonatomic, copy)NSString *fengli;
@property (nonatomic, copy)NSString *hightemp;
@property (nonatomic, copy)NSString *lowtemp;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *aqi;


@end
