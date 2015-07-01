//
//  WeiboView.m
//  weibo
//
//  Created by zsm on 14-11-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboView.h"
#import "WebViewController.h"
#import "ProfileViewController.h"

#define WB_F(detail) detail == YES ? 18 : 14
#define RWB_F(detail) detail == YES ? 16 : 12
@implementation WeiboView
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化子视图
        [self _initViews];
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kThemeNotificationChanged:) name:kThemeNotification object:nil];
    }
    return self;
}

// 初始化子视图
- (void)_initViews
{
    // 1.微博文本视图
    _weiboLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _weiboLabel.textColor = [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Profile_BG_Text_color"];
    _weiboLabel.wxLabelDelegate = self;
    [self addSubview:_weiboLabel];
    
    // 2.转发微博文本视图
    _reposterLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _reposterLabel.textColor = [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Profile_BG_Text_color"];
    _reposterLabel.wxLabelDelegate = self;
    [self addSubview:_reposterLabel];
    
    // 3.微博的图片
    _weiboImageView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    // 设置填充方法
    _weiboImageView.contentMode = UIViewContentModeScaleAspectFit;
    //设置背景颜色
    _weiboImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_weiboImageView];
    
    // 4.转发微博的背景图片
    _bgImageView = [ThemeControl getImageViewWithThemeImageName:@"timeline_rt_border_9.png" leftWidth:25 topHeight:15 frame:CGRectZero];
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_bgImageView atIndex:0];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.微博文本视图
    // 计算为本的高度
    float weiboText_height = [WXLabel getAttributedStringHeightWithString:self.weiboModel.text WidthValue:self.width delegate:self font:[UIFont systemFontOfSize:WB_F(_isDetail)]];
    _weiboLabel.font = [UIFont systemFontOfSize:WB_F(_isDetail)];
    _weiboLabel.frame = CGRectMake(0, 5, self.width, weiboText_height);
    _weiboLabel.text = self.weiboModel.text;
    
    // 2.是否有转发微博
    if (self.weiboModel.reWeibo != nil) {
        // 3.有转发微博
        // 显示转发微博的视图
        _reposterLabel.hidden = NO;
        _bgImageView.hidden = NO;
        // 4.转发微博文本视图
        float reposterText_height = [WXLabel getAttributedStringHeightWithString:self.weiboModel.reWeibo.text WidthValue:self.width - 20 delegate:self font:[UIFont systemFontOfSize:RWB_F(_isDetail)]];
        _reposterLabel.font = [UIFont systemFontOfSize:RWB_F(_isDetail)];
        _reposterLabel.frame = CGRectMake(10, _weiboLabel.bottom + 10, self.width - 20, reposterText_height);
        _reposterLabel.text = self.weiboModel.reWeibo.text;
        
        // 4.判断转发微博是否有图片
        if (self.weiboModel.reWeibo.bmiddle_pic != nil) {
            // 有微博图片
            _weiboImageView.hidden = NO;
            _weiboImageView.frame = CGRectMake(10, _reposterLabel.bottom + 5, kWeibImageViewHeight, kWeibImageViewHeight);
            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.reWeibo.bmiddle_pic]];
            [_weiboImageView addTapZoomInImageViewWithFullUrlString:self.weiboModel.reWeibo.original_pic];
//            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.reWeibo.bmiddle_pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                // 获取图片的宽高的比例
//                float scale = image.size.width / image.size.height;
//                // 视图的宽 / kWeibImageViewHeight ＝ scale
//                float width = kWeibImageViewHeight * scale;
//                width = MIN(width, kScreenWidth - 60);
//                // 设置视图的宽度
//                _weiboImageView.width = width;
//            }];
        } else {
            // 没有微博图片(隐藏图片视图)
            _weiboImageView.hidden = YES;
        }
        
        // 5.设置背景图片
        float bgImageView_height = (self.weiboModel.reWeibo.bmiddle_pic == nil) ? reposterText_height + 10 + 10 : reposterText_height + 10 + 5 + kWeibImageViewHeight + 10;
        _bgImageView.frame = CGRectMake(0, _weiboLabel.bottom, self.width, bgImageView_height);
        
    } else {
        // 3.没有转发微博
        // 隐藏转发微博的视图
        _reposterLabel.hidden = YES;
        _bgImageView.hidden = YES;
        
        // 4.判断微博是否有图片
        if (self.weiboModel.bmiddle_pic != nil) {
            // 有微博图片
            _weiboImageView.hidden = NO;
            _weiboImageView.frame = CGRectMake(0, _weiboLabel.bottom + 5, kWeibImageViewHeight, kWeibImageViewHeight);
            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.bmiddle_pic]];
            [_weiboImageView addTapZoomInImageViewWithFullUrlString:self.weiboModel.original_pic];
//            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.bmiddle_pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                // 获取图片的宽高的比例
//                float scale = image.size.width / image.size.height;
//                // 视图的宽 / kWeibImageViewHeight ＝ scale
//                float width = kWeibImageViewHeight * scale;
//                width = MIN(width, kScreenWidth - 40);
//                // 设置视图的宽度
//                _weiboImageView.width = width;
//            }];
        } else {
            // 没有微博图片(隐藏图片视图)
            _weiboImageView.hidden = YES;
        }
    }
    
  
}

#pragma mark - WXLabelDelegate
//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"context:%@",context);
    // 判断点击连接类型
    if ([context hasPrefix:@"@"]) {
        // 1.点击的是@用户
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.screenName = [context substringFromIndex:1];
        [self.ViewController.navigationController pushViewController:profileVC animated:YES];
        
    }else if ([context hasPrefix:@"http"]) {
        // 2.链接
        // 创建web控制器
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = context;
        webVC.urlString = context;
        [self.ViewController.navigationController pushViewController:webVC animated:YES];
        
    }else if ([context hasPrefix:@"#"]) {
        // 3.话题
    }
}

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
     //需要添加链接字符串的正则表达式：@用户、http://、#话题#
     NSString *regex1 = @"@\\w+";
     NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
     NSString *regex3 = @"#\\w+#";
     NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
     return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel
{
    return [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Link_color"];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel
{
    return [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Mask_TopTab_Selected_color"];
}

#pragma mark - 主题改变的时候收到的通知
- (void)kThemeNotificationChanged:(NSNotification *)notification
{
    _weiboLabel.textColor = [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Profile_BG_Text_color"];
    _reposterLabel.textColor = [[ThemeManager shareThemeManager]getThemeColorWithTextColorKey:@"Profile_BG_Text_color"];
    
    [self setNeedsDisplay];
}

@end
