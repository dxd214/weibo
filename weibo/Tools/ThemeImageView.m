//
//  ThemeImageView.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

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
                    leftWidth:(float)leftWidth
                    topHeight:(float)topHeight
                    imageName:(NSString *)imageName
{
    self = [self initWithFrame:frame];
    if (self) {
        self.leftWidth = leftWidth;
        self.topHeight = topHeight;
        self.imageName = imageName;
        

        
    }
    return self;
}

// 主题改变的时候收到的通知
- (void)kThemeNotificationChanged:(NSNotification *)notification
{
    UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_imageName];
    self.image = [image stretchableImageWithLeftCapWidth:_leftWidth topCapHeight:_topHeight];
}

#pragma mark - 重写set方法
- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        _imageName = [imageName copy];
        
        
        UIImage *image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:_imageName];
        self.image = [image stretchableImageWithLeftCapWidth:_leftWidth topCapHeight:_topHeight];
    }
}
@end
