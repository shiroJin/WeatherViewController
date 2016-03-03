//
//  WaterfallViewController.m
//  瀑布流Demo
//
//  Created by Macx on 16/2/27.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WaterfallViewController.h"
#import "WaterfallLayout.h"
#import "Common.h"
#import "ImageModel.h"
#import "ImageCell.h"

@interface WaterfallViewController () <UICollectionViewDataSource, UICollectionViewDelegate, WaterfallDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *imgModels;

@end

@implementation WaterfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self getData];//获得图片数据
    [self createCollectionView];//创建collectionView
    [self.collectionView reloadData];
}

//获得图片数据
- (void)getData {
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"]];
    self.imgModels = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        ImageModel *imgModel = [[ImageModel alloc] init];
        imgModel.img = dic[@"img"];
        imgModel.w = dic[@"w"];
        imgModel.h = dic[@"h"];
        
        [self.imgModels addObject:imgModel];
    }
}

//创建集合视图
- (void)createCollectionView {
    WaterfallLayout *waterfallLayout = [[WaterfallLayout alloc] init];
    waterfallLayout.delegate = self;
    waterfallLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 48) collectionViewLayout:waterfallLayout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - Collection View DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.img = ((ImageModel *)self.imgModels[indexPath.row]).img;
    
    if (indexPath.item == 1) {
        cell.backgroundColor = [UIColor greenColor];
    }else if (indexPath.item == 3) {
        cell.backgroundColor = [UIColor blueColor];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - Collection View Waterfall Layout Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    
    ImageModel *imgModel = self.imgModels[indexPath.item];
    CGFloat h = [imgModel.h floatValue] / [imgModel.w floatValue] * kwidth;
    return h;
}

@end
