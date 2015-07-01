//
//  ThemeControl.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeControl : NSObject

// 创建主题图片视图
+ (UIImageView *)getImageViewWithThemeImageName:(NSString *)imageName
                                      leftWidth:(float)leftWidth
                                      topHeight:(float)topHeight
                                          frame:(CGRect)frame;

// 创建普通图片按钮
+ (UIButton *)getButtonWithThemeTitleImageName:(NSString *)titleImageName
                                         frame:(CGRect)frame;

+ (UIButton *)getButtonWithThemeTitleImageName:(NSString *)titleImageName
                                   bgImageName:(NSString *)bgImageName
                                         frame:(CGRect)frame;

// 创建主题文本
+ (UILabel *)getLabelWithTextColorKey:(NSString *)textColorKey
                           bgColorKey:(NSString *)bgColorKey
                                frame:(CGRect)frame;
@end
