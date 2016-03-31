//
//  TempView.m
//  CAShapeLayer
//
//  Created by Macx on 16/3/23.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "TempView.h"

#define LINE_WIDTH 10.0f
#define RADIUS (self.bounds.size.width-2*LINE_WIDTH)/2

@interface TempView ()

@property (nonatomic, strong)CAShapeLayer *bottomLayer;
@property (nonatomic, strong)CAShapeLayer *progressLayer;
@property (nonatomic, strong)CAGradientLayer *gradentLayer;

@end

@implementation TempView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat size = frame.size.width;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, size, size);
    
    self = [super initWithFrame:newFrame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)awakeFromNib {
    [self initSubview];
}

- (void)initSubview {
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.frame = self.bounds;
    arc.path = roundPath.CGPath;
    arc.lineWidth = 5.0f;
    arc.fillColor = [UIColor clearColor].CGColor;
    arc.strokeColor = [UIColor whiteColor].CGColor;
    arc.lineCap = kCALineCapRound;
    [self.layer addSublayer:arc];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2) radius:RADIUS startAngle:M_PI_4 endAngle:M_PI_4 * 7 clockwise:YES];
    
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = self.bounds;
    self.bottomLayer.path = bezierPath.CGPath;
    self.bottomLayer.lineWidth = LINE_WIDTH;
    self.bottomLayer.strokeStart = 0.0f;
    self.bottomLayer.strokeEnd = 1.0f;
    self.bottomLayer.lineCap = kCALineCapRound;
    self.bottomLayer.fillColor = [UIColor clearColor].CGColor;
    self.bottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.bottomLayer];

    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.path = bezierPath.CGPath;
    self.progressLayer.strokeColor = [UIColor blackColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = LINE_WIDTH;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.speed = 0.1;
    [self.layer addSublayer:self.progressLayer];
    
    self.gradentLayer = [CAGradientLayer layer];
    self.gradentLayer.colors = @[
                                 (id)[UIColor redColor].CGColor,
                                 (id)[UIColor blueColor].CGColor,
                                 ];
    self.gradentLayer.frame = self.bounds;
    self.gradentLayer.locations = @[@0, @1];
    self.gradentLayer.startPoint = CGPointMake(0, 0);
    self.gradentLayer.endPoint = CGPointMake(0, 1);
    
    [self.gradentLayer setMask:self.progressLayer];
    [self.layer addSublayer:self.gradentLayer];
    
}

- (void)setTemp:(NSString *)temp {
    _temp = temp;
    self.progressLayer.strokeEnd = ([temp integerValue] + 10) / 50.0f;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    NSMutableParagraphStyle *paraSytle = [[NSMutableParagraphStyle alloc] init];
    paraSytle.alignment = NSTextAlignmentCenter;
    paraSytle.paragraphSpacingBefore = 10.0f;
    paraSytle.minimumLineHeight = 1.414 * RADIUS / 2;
    
    [_temp drawInRect:CGRectMake(0.293 * RADIUS + LINE_WIDTH, 0.293 * RADIUS + LINE_WIDTH, 1.414 * RADIUS, 1.414 * RADIUS) withAttributes:@{
                                                                                                                                          NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                                                          NSFontAttributeName : [UIFont systemFontOfSize:45],
                                                                                                                                          NSParagraphStyleAttributeName : paraSytle,
                                                                                                                                          }];
    
}

@end
