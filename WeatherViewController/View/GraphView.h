//
//  GraphView.h
//  WeatherViewController
//
//  Created by Macx on 16/3/6.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherModel;
@interface GraphView : UIScrollView

@property (nonatomic, strong)WeatherModel *weatherModel;

@end
