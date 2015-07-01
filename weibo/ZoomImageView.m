//
//  ZoomImageView.m
//  weibo
//
//  Created by zsm on 14-11-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ZoomImageView.h"

@implementation ZoomImageView

- (void)addTapZoomInImageViewWithFullUrlString:(NSString *)urlString
{
    // 开启点击时间
    self.userInteractionEnabled = YES;
    if (urlString != nil) {
        // 保存图片连接
        _fullImageUrl = urlString;
        
        // 添加手势
        if (_tap == nil) {
            _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInImageView:)];
            [self addGestureRecognizer:_tap];
        }
    }
}

// 初始化子视图
- (void)_initViews
{
    // 1.创建滑动视图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        
        // 在滑动视图里面添加一个缩小手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutImageView:)];
        [_scrollView addGestureRecognizer:tap];
    }
    [self.window addSubview:_scrollView];
    
    // 2.创建放大图片视图
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithImage:self.image];
        _fullImageView.contentMode = self.contentMode;
        [_scrollView addSubview:_fullImageView];
    }
    
    // 3.加载进度视图
    if (_progressView == nil) {
        _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, (kScreenHeight - 30) / 2.0, kScreenWidth - 20, 30)];
        // 设置样式
        [_progressView setOuterColor:[UIColor redColor]];
        [_progressView setInnerColor:[UIColor grayColor]];
        [_progressView setEmptyColor:[UIColor orangeColor]];
        
    }
    _progressView.progress = 0;
    [self.window addSubview:_progressView];
    
}

- (void)zoomInImageView:(UITapGestureRecognizer *)tap
{
    if (self.image == nil) {
        return;
    }
    // 1.初始化子视图
    [self _initViews];
    
    // 2.初始化子视图属性
    _scrollView.backgroundColor = [UIColor clearColor];
    _fullImageView.frame = [self convertRect:self.bounds toView:self.window];
    _progressView.hidden = YES;
    
    // 3.实现方法动画
    [UIView animateWithDuration:.35 animations:^{
        _scrollView.backgroundColor = [UIColor blackColor];
        // 最终放大的大小 image.width / image.height = kScreenWidht / image.height
        // 图片放大后的高度
        float height = kScreenWidth / (self.image.size.width / self.image.size.height);
        _fullImageView.frame = CGRectMake(0, 0, kScreenWidth, MAX(height, kScreenHeight));
        _scrollView.contentSize = CGSizeMake(kScreenWidth, _fullImageView.height);
    } completion:^(BOOL finished) {
        // 现实进度
        _progressView.hidden = NO;
        // 加载图片
        [_fullImageView sd_setImageWithURL:[NSURL URLWithString:_fullImageUrl] placeholderImage:self.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            _progressView.progress = (double)receivedSize / expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 加载完成
            _progressView.hidden = YES;
            [_progressView removeFromSuperview];
            _progressView = nil;
            
        }];
    }];
}

// 点击进行缩小
- (void)zoomOutImageView:(UITapGestureRecognizer *)tap
{
    // 1.移除加载进度视图
    if (_progressView != nil) {
        _progressView.hidden = YES;
        [_progressView removeFromSuperview];
        _progressView = nil;

    }
    
    // 2.执行动画
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView animateWithDuration:.35 animations:^{
        _scrollView.backgroundColor = [UIColor clearColor];
        _fullImageView.frame = [self convertRect:self.bounds toView:self.window];
    } completion:^(BOOL finished) {
        [_fullImageView removeFromSuperview];
        _fullImageView = nil;
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }];
}
@end
