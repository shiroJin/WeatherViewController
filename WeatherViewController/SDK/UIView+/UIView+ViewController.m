//
//  UIView+ViewController.m
//  weatherForecast
//
//  Created by Macx on 16/2/5.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    UIResponder *responder = self.nextResponder;
    
    while (![responder isKindOfClass:[UIWindow class]])
    {
        if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
        }
        
        responder = responder.nextResponder;
    }
    
    return nil;
}

@end
