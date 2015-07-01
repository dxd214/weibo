//
//  ThemeLabel.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kThemeNotificationChanged:) name:kThemeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kThemeNotificationChanged:) name:kThemeNotification object:nil];
    
}

// 自定义初始化方法
// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                 textColorKey:(NSString *)textColorKey
                   bgColorKey:(NSString *)bgColorKey
{
    self = [self initWithFrame:frame];
    if (self) {
        self.textColorKey = textColorKey;
        self.bgColorKey = bgColorKey;
   
    }
    return self;
}

// 主题改变的时候收到的通知
- (void)kThemeNotificationChanged:(NSNotification *)notification
{
    if (_textColorKey != nil) {
        // 设置到文本颜色上
        self.textColor = [[ThemeManager shareThemeManager] getThemeColorWithTextColorKey:_textColorKey];
    }
    
    if (_bgColorKey != nil) {
        // 设置到背景颜色上
        self.backgroundColor = [[ThemeManager shareThemeManager] getThemeColorWithTextColorKey:_bgColorKey];
    }
}

#pragma mark - 重写set方法
- (void)setTextColorKey:(NSString *)textColorKey
{
    if (_textColorKey != textColorKey) {
        _textColorKey = [textColorKey copy];
        
        // 设置到文本颜色上
        self.textColor = [[ThemeManager shareThemeManager] getThemeColorWithTextColorKey:_textColorKey];
    }
}

- (void)setBgColorKey:(NSString *)bgColorKey
{
    if (_bgColorKey != bgColorKey) {
        _bgColorKey = [bgColorKey copy];
        
        // 设置到背景颜色上
        self.backgroundColor = [[ThemeManager shareThemeManager] getThemeColorWithTextColorKey:_bgColorKey];
    }
}

@end
