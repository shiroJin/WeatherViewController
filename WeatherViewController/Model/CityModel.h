//
//  CityModel.h
//  weatherForecast
//
//  Created by Macx on 16/2/5.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseModel.h"
@interface CityModel : BaseModel

@property (nonatomic, copy)NSString *province_cn;
@property (nonatomic, copy)NSString *district_cn;
@property (nonatomic, copy)NSString *name_cn;
@property (nonatomic, copy)NSString *name_en;
@property (nonatomic, copy)NSString *area_id;

@end
