//
//  FaceView.h
//  weibo
//
//  Created by zsm on 14-11-24.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceView;
@protocol FaceViewDelegate <NSObject>
/**
 *  点击表情反馈表情名字前的协议方法
 *
 *  @param faceName 表情的名字
 */
- (void)touchEndFaceViewWithImageFaceName:(NSString *)faceName;

@end

@interface FaceView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSArray *_dataList;
}

@property (nonatomic,weak) id<FaceViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<FaceViewDelegate>)delegate;
@end
