//
//  DrawFaceView.m
//  weibo
//
//  Created by zsm on 14-11-24.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "DrawFaceView.h"
#define JL ([UIScreen mainScreen].bounds.size.width - 7 * 30) / 8.0
@implementation DrawFaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 超出视图部分不裁剪
        self.clipsToBounds = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (int i = 0; i < self.array2d.count; i++) {
        // 获取图片的配置字典
        NSDictionary *faceDic = self.array2d[i];
        NSString *imageName = faceDic[@"png"];
        UIImage *image = [UIImage imageNamed:imageName];
        float x = JL + i % 7 * (30 + JL);
        float y = 15 + i / 7 * (15 + 30);
        [image drawInRect:CGRectMake(x, y, 30, 30)];
    }
}

// 判断手指是否在图片上，如果在图片上就显示放大镜视图，并设置到指定位置，否则隐藏放大镜视图
- (void)magnifierViewShowInViewWithTouch:(UITouch *)touch
{
    // 1.获取手指在视图上的位置
    CGPoint touchPoint = [touch locationInView:self];
    
    // 2.判断当前坐标是否在图片上
    if ((int)touchPoint.x % (int)(JL + 30) >= JL && (int)touchPoint.y % (15 + 30) >= 15 ) {
        // 3.获取表情的索引位置
        int index_x = touchPoint.x / (JL + 30);
        int index_y = touchPoint.y / (15 + 30);
        int index = index_y * 7 + index_x;
        // 4.表情的索引要小于表情的个数（容错）
        if (index < _array2d.count) {
            // 5.获取点击的图片，显示在放大镜上
            NSString *imageName = _array2d[index][@"png"];
            UIImageView *faceImageView = (UIImageView *)[_zoomImageView viewWithTag:2014];
            faceImageView.image = [UIImage imageNamed:imageName];
            
            //  把放大镜添加到视图上
            if (_zoomImageView.superview == nil) {
                [self addSubview:_zoomImageView];
            }
            
            // 计算放大镜的位置
            float x = index_x * (JL + 30) + JL + 30 / 2.0;
            float y = index_y * (15 + 30) + 15 + 30 / 2.0;
            _zoomImageView.center = CGPointMake(x, y - 92 / 2.0);
            
            // 禁止滑动视图滑动
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            if ([scrollView isKindOfClass:[UIScrollView class]]) {
                scrollView.scrollEnabled = NO;
            }
            
        } else {
            // 判断放大镜视图是否在父视图上，如果在就移除
            if (_zoomImageView.superview != nil) {
                [_zoomImageView removeFromSuperview];
            }
        }
    } else {
        // 判断放大镜视图是否在父视图上，如果在就移除
        if (_zoomImageView.superview != nil) {
            [_zoomImageView removeFromSuperview];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 创建放大镜视图
    if (_zoomImageView == nil) {
        _zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
        _zoomImageView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
        _zoomImageView.backgroundColor = [UIColor clearColor];
        // 放大镜中所要方法的图片视图
        UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 30, 30)];
        faceImageView.tag = 2014;
        faceImageView.backgroundColor = [UIColor clearColor];
        [_zoomImageView addSubview:faceImageView];
    }
    
    // 判断手指是否在图片上，如果在图片上就显示放大镜视图，并设置到指定位置，否则隐藏放大镜视图
    [self magnifierViewShowInViewWithTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 判断手指是否在图片上，如果在图片上就显示放大镜视图，并设置到指定位置，否则隐藏放大镜视图
    [self magnifierViewShowInViewWithTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 判断放大镜视图是否在父视图上，如果在就移除
    if (_zoomImageView.superview != nil) {
        [_zoomImageView removeFromSuperview];
    }
    
    // 开启滑动视图滑动
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView.scrollEnabled = YES;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    // 2.判断当前坐标是否在图片上
    if ((int)touchPoint.x % (int)(JL + 30) >= JL && (int)touchPoint.y % (15 + 30) >= 15 ) {
        // 3.获取表情的索引位置
        int index_x = touchPoint.x / (JL + 30);
        int index_y = touchPoint.y / (15 + 30);
        int index = index_y * 7 + index_x;
        // 4.表情的索引要小于表情的个数（容错）
        if (index < _array2d.count) {
            // 获取点击的图片的内容
            NSString *faceText = _array2d[index][@"chs"];
            NSLog(@"faceText:%@",faceText);
            [self.delegate touchEndFaceViewWithImageFaceName:faceText];
            
        }
    }
    
}


@end
