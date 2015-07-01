//
//  ThemeButton.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

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
- (instancetype)initWithFrame:(CGRect)frame
               titleImageName:(NSString *)titleImageName
             titleImageHlName:(NSString *)titleImageHlName
                  bgImageName:(NSString *)bgImageName
                bgImageHlName:(NSString *)bgImageHlName
{
    self = [self initWithFrame:frame];
    if (self) {
        self.titleImageName = titleImageName;
        self.titleImageHlName = titleImageHlName;
        self.bgImageName = bgImageName;
        self.bgImageHlName = bgImageHlName;
    }
    return self;
}

// 主题改变的时候收到的通知
- (void)kThemeNotificationChanged:(NSNotification *)notification
{
    if (self.titleImageName != nil) {
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_titleImageName];
        [self setImage:image forState:UIControlStateNormal];
    }
    
    if (self.titleImageHlName != nil) {
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_titleImageHlName];
        [self setImage:image forState:UIControlStateHighlighted];
    }
    
    if (self.bgImageName != nil) {
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_bgImageName];
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (self.bgImageHlName != nil) {
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_bgImageHlName];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];

    }
}

#pragma mark - 重写set方法
- (void)setTitleImageName:(NSString *)titleImageName
{
    if (_titleImageName != titleImageName) {
        _titleImageName = [titleImageName copy];
        
        
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_titleImageName];
        [self setImage:image forState:UIControlStateNormal];
    }
}

- (void)setTitleImageHlName:(NSString *)titleImageHlName
{
    if (_titleImageHlName != titleImageHlName) {
        _titleImageHlName = [titleImageHlName copy];
        
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_titleImageHlName];
        [self setImage:image forState:UIControlStateHighlighted];
    }
}

- (void)setBgImageName:(NSString *)bgImageName
{
    if (_bgImageName != bgImageName) {
        _bgImageName = [bgImageName copy];
        
        
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_bgImageName];
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)setBgImageHlName:(NSString *)bgImageHlName
{
    if (_bgImageHlName != bgImageHlName) {
        _bgImageHlName = [bgImageHlName copy];
        
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_bgImageHlName];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

@end
