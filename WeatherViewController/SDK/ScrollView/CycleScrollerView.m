//
//  CycleScrollerView.m
//  AutoScrollerView
//
//  Created by Macx on 16/2/8.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CycleScrollerView.h"
#import "UIImageView+WebCache.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

@implementation CycleScrollerView
{
    UIScrollView *scroller;
    UIPageControl *pageControl;
    UIImageView *leftImg;
    UIImageView *centerImg;
    UIImageView *rightImg;
    NSTimer *timer;
    NSArray *imagesArr;//图片数组
    NSInteger maxCount;//最大图片数
    NSInteger currentIndex;//当前位置
    BOOL isNetImage;//是否网络加载的图片
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame imgs:(NSArray *)imgArr isNetImage:(BOOL)isNet {
    self = [super initWithFrame:frame];
    if (self) {
        _timeInterval = 3;
        currentIndex = 0;
        maxCount = imgArr.count;
        imagesArr = imgArr;
        isNetImage = isNet;
        [self createScrollerView];
        [self createPageControl];
        [self createImgViews];
        [self setUpTimer];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)createScrollerView {
    scroller = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroller];
    scroller.scrollEnabled = YES;
    scroller.pagingEnabled = YES;
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.showsVerticalScrollIndicator = NO;
    scroller.bounces = NO;
    scroller.contentSize = CGSizeMake(kWidth * 3, 200);
    scroller.delegate = self;
}

- (void)createPageControl {
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    [self addSubview:pageControl];
    pageControl.numberOfPages = maxCount;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
}

- (void)createImgViews {
    leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    leftImg.backgroundColor = [UIColor redColor];
    centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight)];
    
    [scroller addSubview:leftImg];
    [scroller addSubview:centerImg];
    [scroller addSubview:rightImg];
    
    [self setImages];
}

#pragma mark - 加载图片

- (void)setImages {
    if (currentIndex == 0) {
        [self setImagesWithLeft:maxCount - 1 center:currentIndex right:currentIndex  + 1];
    }
    else if (currentIndex < maxCount - 1) {
        [self setImagesWithLeft:currentIndex - 1 center:currentIndex right:currentIndex + 1];
    }
    else if (currentIndex >= maxCount - 1) {
        [self setImagesWithLeft:currentIndex - 1 center:currentIndex right:0];
    }
    
    [scroller setContentOffset:CGPointMake(kWidth, 0)];
    pageControl.currentPage = currentIndex;
}


- (void)setImagesWithLeft:(NSInteger)left center:(NSInteger)center right:(NSInteger)right {
    //本地加载
    if (!isNetImage) {
        leftImg.image = [UIImage imageNamed:imagesArr[left]];
        centerImg.image = [UIImage imageNamed:imagesArr[center]];
        rightImg.image = [UIImage imageNamed:imagesArr[right]];
    }//网络加载
    else if (isNetImage) {
        [leftImg sd_setImageWithURL:imagesArr[left]];
        [centerImg sd_setImageWithURL:imagesArr[center]];
        [rightImg sd_setImageWithURL:imagesArr[right]];
    }
}

#pragma mark - 设置滑动事件间隔
- (void)setTimeInterval:(CGFloat)timeInterval {
    if (_timeInterval != timeInterval) {
        _timeInterval = timeInterval;
    }
}

- (void)setUpTimer {
    timer = nil;
    timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (timer == nil) {
        return;
    }
    [timer invalidate];
}

- (void)scroll {
    [scroller setContentOffset:CGPointMake(scroller.contentOffset.x + kWidth, 0) animated:YES];
}

#pragma mark - 滑动视图代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scroller.contentOffset.x;
    
    if (offsetX == kWidth * 2) {
        currentIndex++;
        if (currentIndex == maxCount) {
            currentIndex = 0;
        }
        [self setImages];
    }
    else if (offsetX == 0) {
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = maxCount - 1;
        }
        [self setImages];
    }
}


@end
