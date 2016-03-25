//
//  GraphView.m
//  WeatherViewController
//
//  Created by Macx on 16/3/6.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "GraphView.h"
#import "WeatherModel.h"

#define kGraphHeight 200
#define kWidth 50
#define kGrid 5
#define kStart (kWidth / 2)

@implementation GraphView

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    //重新设定宽度
    CGFloat width = kWidth * 12;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    self = [super initWithFrame:newFrame];
    if (self) {
        //...
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (!self.weatherModel) {
        return;
    }
    //绘制折线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
////    旋转坐标系
//    CGContextSaveGState(context);
//    CGContextScaleCTM(context, 1, -1);
//    CGContextTranslateCTM(context, 0, -300);
    
    CGMutablePathRef lowPath = CGPathCreateMutable();
    CGMutablePathRef highPath = CGPathCreateMutable();
    
    NSInteger lowTemp, highTemp;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttribute = @{
      NSFontAttributeName : [UIFont systemFontOfSize:10],
      NSForegroundColorAttributeName : [UIColor whiteColor],
      NSParagraphStyleAttributeName : paraStyle,
      };
    
    //历史天气
    for (int i = 0; i < self.weatherModel.historyArr.count; i++) {
        
        HistoryModel *history = self.weatherModel.historyArr[i];
        lowTemp = [history.lowtemp integerValue];
        highTemp = [history.hightemp integerValue];
        
        if (i == 0) {
            CGPathMoveToPoint(lowPath, NULL, i * kWidth + kStart, kGraphHeight - lowTemp * kGrid);
            CGPathMoveToPoint(highPath, NULL, i * kWidth + kStart, kGraphHeight - highTemp * kGrid);
        }
        else {
            CGPathAddLineToPoint(lowPath, NULL, i * kWidth + kStart, kGraphHeight - lowTemp * kGrid);
            CGPathAddLineToPoint(highPath, NULL, i * kWidth + kStart, kGraphHeight - highTemp * kGrid);
        }
        //week
        [history.week drawInRect:CGRectMake(i * kWidth, 280, kWidth, 20) withAttributes:textAttribute];
        //temp
        [history.lowtemp drawInRect:CGRectMake(i * kWidth, kGraphHeight - (lowTemp * kGrid - 10), kWidth, 10) withAttributes:textAttribute];
        [history.hightemp drawInRect:CGRectMake(i * kWidth, kGraphHeight - (highTemp * kGrid + 20), kWidth, 10) withAttributes:textAttribute];
    }
    
    //今日天气
    lowTemp = [self.weatherModel.today.lowtemp integerValue];
    highTemp = [self.weatherModel.today.hightemp integerValue];
    
    TodayModel *today = self.weatherModel.today;
    
    CGPathAddLineToPoint(lowPath, NULL, self.weatherModel.historyArr.count * kWidth + kStart, kGraphHeight - lowTemp * kGrid);
    CGPathAddLineToPoint(highPath, NULL, self.weatherModel.historyArr.count * kWidth + kStart, kGraphHeight - highTemp * kGrid);
    //week
    [today.week drawInRect:CGRectMake(self.weatherModel.historyArr.count * kWidth, 280, kWidth, 10) withAttributes:textAttribute];
    //temp
    [today.lowtemp drawInRect:CGRectMake(self.weatherModel.historyArr.count * kWidth, kGraphHeight - (lowTemp * kGrid - 10), kWidth, 10) withAttributes:textAttribute];
    [today.hightemp drawInRect:CGRectMake(self.weatherModel.historyArr.count * kWidth, kGraphHeight - (highTemp * kGrid + 20), kWidth, 10) withAttributes:textAttribute];
    
    //draw
    CGContextAddPath(context, lowPath);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddPath(context, highPath);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(lowPath);
    CGPathRelease(highPath);
    lowPath = CGPathCreateMutable();
    highPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(lowPath, NULL, self.weatherModel.historyArr.count * kWidth + kStart, kGraphHeight - lowTemp * kGrid);
    CGPathMoveToPoint(highPath, NULL, self.weatherModel.historyArr.count * kWidth + kStart, kGraphHeight - highTemp * kGrid);
    
    //预报天气
    for (int i = 0; i < self.weatherModel.forecastArr.count; i++) {
        ForecastModel *forecast = self.weatherModel.forecastArr[i];
        lowTemp = [forecast.lowtemp integerValue];
        highTemp = [forecast.hightemp integerValue];
        
        CGPathAddLineToPoint(lowPath, NULL, (self.weatherModel.historyArr.count + 1 + i) * kWidth + kStart, kGraphHeight - lowTemp * kGrid);
        CGPathAddLineToPoint(highPath, NULL, (self.weatherModel.historyArr.count + 1 + i) * kWidth + kStart, kGraphHeight - highTemp * kGrid);
        
        //week
        [forecast.week drawInRect:CGRectMake((self.weatherModel.historyArr.count + 1 + i) * kWidth, 280, kWidth, 20) withAttributes:textAttribute];
        //temp
        [forecast.lowtemp drawInRect:CGRectMake((self.weatherModel.historyArr.count + 1 + i) * kWidth, kGraphHeight - (lowTemp * kGrid - 10), kWidth, 10) withAttributes:textAttribute];
        [forecast.hightemp drawInRect:CGRectMake((self.weatherModel.historyArr.count + 1 + i) * kWidth, kGraphHeight - (highTemp * kGrid + 20), kWidth, 10) withAttributes:textAttribute];

    }
    
    CGContextAddPath(context, lowPath);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddPath(context, highPath);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(lowPath);
    CGPathRelease(highPath);
    context = nil;
}

@end
