//
//  ZoomImageView.h
//  weibo
//
//  Created by zsm on 14-11-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"

@interface ZoomImageView : UIImageView
{
    UIScrollView *_scrollView;   // 活动视图是添加到window的视图
    UIImageView *_fullImageView;// 放大的图片视图
    DDProgressView *_progressView; // 加载进度
    UITapGestureRecognizer *_tap; // 放大手势
    NSString *_fullImageUrl;
}

- (void)addTapZoomInImageViewWithFullUrlString:(NSString *)urlString;
@end
