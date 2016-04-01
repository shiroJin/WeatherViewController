//
//  ForeCastView.m
//  WeatherViewController
//
//  Created by Macx on 16/3/6.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ForeCastView.h"
#define WEEKWIDTH 60
#define WEEKHEIGHT 30
#define IMGSIZE 30

@implementation ForeCastView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!self.forecast) {
        return;
    }
    
    NSMutableParagraphStyle *leftParaStyle = [[NSMutableParagraphStyle alloc] init];
    leftParaStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *rightParaStyle = [[NSMutableParagraphStyle alloc] init];
    rightParaStyle.alignment = NSTextAlignmentRight;

    [self.forecast.week drawInRect:CGRectMake(0, 0, WEEKWIDTH, WEEKHEIGHT) withAttributes:@{
                                                                                           NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                           NSParagraphStyleAttributeName : leftParaStyle,
                                                                                           }];
    
    NSDictionary *typeDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weatherType" ofType:@"plist"]];
    
    __block NSString *imgName = nil;
    __weak typeof(self) wself = self;
    
    [typeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:wself.forecast.type]) {
            imgName = obj;
            *stop = YES;
        }
    }];
    
    UIImage *typeImg = [UIImage imageNamed:[NSString stringWithFormat:@"w%@", imgName]];
    [typeImg drawInRect:CGRectMake(70, 0, IMGSIZE, IMGSIZE)];
    
    [self.forecast.type drawInRect:CGRectMake(110, 0, 40, 30) withAttributes:@{
                                                                               NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                               NSParagraphStyleAttributeName : rightParaStyle,
                                                                               }];
    
    NSString *temp = [NSString stringWithFormat:@"%@-%@", self.forecast.lowtemp, self.forecast.hightemp];
    [temp drawInRect:CGRectMake(0, 50, 60, 30) withAttributes:@{
                                                                 NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                 NSParagraphStyleAttributeName : leftParaStyle,
                                                                 }];
    
    NSString *wind = [NSString stringWithFormat:@"%@ %@", self.forecast.fengxiang, self.forecast.fengli];
    [wind drawInRect:CGRectMake(60, 50, 90, 30) withAttributes:@{
                                                                 NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                 NSParagraphStyleAttributeName : rightParaStyle,
                                                                 }];
}

- (void)setForecast:(ForecastModel *)forecast {
    _forecast = forecast;
    [self setNeedsDisplay];
}

@end
