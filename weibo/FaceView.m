//
//  FaceView.m
//  weibo
//
//  Created by zsm on 14-11-24.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FaceView.h"
#import "DrawFaceView.h"

@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FaceViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        // 1.初始化数据
        [self _loadData];
        
        // 2.初始化子视图
        [self _initViews];
        
    }
    return self;
}

// 2.初始化子视图
- (void)_initViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 1.创建滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _dataList.count, self.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    // 超出视图部分不裁剪
    _scrollView.clipsToBounds = NO;
    [self addSubview:_scrollView];
    // 创建滑动视图的子视图
    for (int i = 0; i < _dataList.count; i++) {
        // 创建表情视图
        DrawFaceView *drawFaceView = [[DrawFaceView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, self.height)];
        drawFaceView.delegate = self.delegate;
        drawFaceView.array2d = _dataList[i];
        [_scrollView addSubview:drawFaceView];
    }
    
    // 2.创建页码控件
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20 - 10, kScreenWidth, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _dataList.count;
    [self addSubview:_pageControl];
}

// 1.初始化数据
- (void)_loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    // 把表情数据，整理成二维数组，每一页的表情存放在一个小数组中
    NSMutableArray *arrayData = [NSMutableArray array];
    NSMutableArray *array2d = nil;
    for (int i = 0; i < array.count; i++) {
        if (i % 28 == 0) {
            // 创建一个小数组
            array2d = [[NSMutableArray alloc] init];
            // 添加到大数组中
            [arrayData addObject:array2d];
        }
        
        // 把元素添加到小数组中
        [array2d addObject:array[i]];
    }
    
    // 把整理好的数据保存到dataList中
    _dataList = arrayData;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)(scrollView.contentOffset.x / kScreenWidth);
}
@end
