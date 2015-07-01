//
//  ThemeControl.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeControl.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"

@implementation ThemeControl
// 创建主题图片视图
+ (UIImageView *)getImageViewWithThemeImageName:(NSString *)imageName
                                      leftWidth:(float)leftWidth
                                      topHeight:(float)topHeight
                                          frame:(CGRect)frame
{
    return [[ThemeImageView alloc] initWithFrame:frame
                                       leftWidth:leftWidth
                                       topHeight:topHeight
                                       imageName:imageName];
}

// 创建普通图片按钮
+ (UIButton *)getButtonWithThemeTitleImageName:(NSString *)titleImageName
                                         frame:(CGRect)frame
{
    return [[ThemeButton alloc] initWithFrame:frame
                               titleImageName:titleImageName
                             titleImageHlName:nil
                                  bgImageName:nil
                                bgImageHlName:nil];
}

+ (UIButton *)getButtonWithThemeTitleImageName:(NSString *)titleImageName
                                   bgImageName:(NSString *)bgImageName
                                         frame:(CGRect)frame
{
    return [[ThemeButton alloc] initWithFrame:frame
                               titleImageName:titleImageName
                             titleImageHlName:nil
                                  bgImageName:bgImageName
                                bgImageHlName:nil];
}

// 创建主题文本
+ (UILabel *)getLabelWithTextColorKey:(NSString *)textColorKey
                           bgColorKey:(NSString *)bgColorKey
                                frame:(CGRect)frame
{
    return [[ThemeLabel alloc] initWithFrame:frame
                                textColorKey:textColorKey
                                  bgColorKey:bgColorKey];
}
@end
