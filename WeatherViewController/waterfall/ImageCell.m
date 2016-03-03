//
//  ImageCell.m
//  瀑布流Demo
//
//  Created by Macx on 16/2/27.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ImageCell.h"
#import "UIImageView+WebCache.h"

@interface ImageCell ()

@property (nonatomic, strong)UIImageView *imgView;

@end

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)setImg:(NSString *)img {
    if (![_img isEqualToString:img]) {
        _img = img;
        //set img
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_img]];
        self.imgView.frame = self.bounds;
        self.imgView.clipsToBounds = YES;
    }
}

@end
