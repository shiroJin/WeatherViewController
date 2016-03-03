
//
//  WaterfallLayout.m
//  瀑布流Demo
//
//  Created by Macx on 16/2/27.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WaterfallLayout.h"
#import "Common.h"

#define kwidth ((kScreenWidth - 50) / 3)
#define kItemSpacing 10
#define kColumnCount 3

@interface WaterfallLayout ()

@property (nonatomic, strong)NSMutableDictionary *columnMaxDic;

@end

@implementation WaterfallLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnMaxDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    //遍历找出最高的列
    __block NSString *maxCol = @"0";
    [self.columnMaxDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.columnMaxDic[maxCol] floatValue]) {
            maxCol = key;
        }
    }];
    
    CGSize size = CGSizeMake(0, [self.columnMaxDic[maxCol] floatValue]);
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //遍历找出最短的列。
    __block NSString *minCol = @"0";
    [self.columnMaxDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] < [self.columnMaxDic[minCol] floatValue]) {
            minCol = key;
        }
    }];
    
    //根据图片大小，获得单元高度
    CGFloat width = (self.collectionView.frame.size.width - 40) / 3;
    CGFloat height = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForWidth:width atIndexPath:indexPath];
    }
    
    CGFloat x = 10 + (width + kItemSpacing) * [minCol intValue];
    
    CGFloat space = 10.0f;
//    if (indexPath.item < kColumnCount) {
//        space = 10.0f;
//    }else {
//        space = 10.0f;
//    }
    
    CGFloat y = [self.columnMaxDic[minCol] floatValue] + space;
    //更新对应列的高度
    self.columnMaxDic[minCol] = @(y + height);
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = CGRectMake(x, y, width, height);
    
    NSInteger sectionNum = indexPath.section;
    NSInteger itemNum = indexPath.item;
    
    return layoutAttributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //向columnMaxDic中添加数据
    for (NSInteger i = 0; i < kColumnCount; i++) {
        NSString *col = [NSString stringWithFormat:@"%ld", (long)i];
        [self.columnMaxDic setValue:@0 forKey:col];
    }
    
    NSMutableArray *attributesArr = [NSMutableArray array];
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        
        for (int j = 0; j < count; j++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
        [attributesArr addObject:layoutAttributes];
        }
    }
    
    return attributesArr;
}


@end
