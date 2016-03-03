//
//  WaterfallLayout.h
//  瀑布流Demo
//
//  Created by Macx on 16/2/27.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallLayout;
@protocol WaterfallDelegate <NSObject>

@required
//item height
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@end

@interface WaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak)id<WaterfallDelegate> delegate;
@property (nonatomic, assign)UIEdgeInsets sectionInset;

@end
