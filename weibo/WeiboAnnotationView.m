//
//  WeiboAnnotationView.m
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "ProfileViewController.h"
#import "WebViewController.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "DetailViewController.h"

@implementation WeiboAnnotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化子视图
        [self _initViews];
    }
    return self;
}

// 初始化子视图
- (void)_initViews
{
    // 01微博图片
    _weiboImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_weiboImageView];
    
    // 02头像视图
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImageView.layer.borderColor = [UIColor greenColor].CGColor;
    _userImageView.layer.borderWidth = 1;
    [self addSubview:_userImageView];
    // 03微博内容视图
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.wxLabelDelegate = self;
    _textLabel.numberOfLines = 3;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_textLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 获取微博的内容
    WeiboModel *weiboModel = nil;
    if ([self.annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)self.annotation;
        weiboModel = weiboAnnotation.weiboModel;
    } else {
        return;
    }
    
    // 判断当前微博是否有微博图片
    if ([weiboModel.thumbnail_pic isEqualToString:@""] || weiboModel.thumbnail_pic == nil) {
        // 1.无图片微博
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        // 2.隐藏微博图片视图
        _weiboImageView.hidden = YES;
        // 3.设置头像位置
        _userImageView.frame = CGRectMake(20, 20, 45, 45);
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.userModel.profile_image_url]];
        // 4.微博文本
        _textLabel.frame = CGRectMake(_userImageView.right + 5, _userImageView.top, 110, _userImageView.height);
        _textLabel.hidden = NO;
        _textLabel.text = weiboModel.text;
    } else {
        // 1.图片微博
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        // 2.隐藏微博图片视图
        _weiboImageView.hidden = NO;
        _weiboImageView.frame = CGRectMake(15, 15, 90, 85);
        [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.thumbnail_pic]];
        // 3.设置头像位置
        _userImageView.frame = CGRectMake(70, 65, 30, 30);
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.userModel.profile_image_url]];
        // 4.微博文本
        _textLabel.hidden = YES;
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
    return [UIColor redColor];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor grayColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取微博的内容
    WeiboModel *weiboModel = nil;
    if ([self.annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)self.annotation;
        weiboModel = weiboAnnotation.weiboModel;
    } else {
        return;
    }
    
    // 创建微博详情控制器
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.weiboModel = weiboModel;
    [self.ViewController.navigationController pushViewController:detailVC animated:YES];
}








@end
