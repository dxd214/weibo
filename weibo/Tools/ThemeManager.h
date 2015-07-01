//
//  ThemeManager.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

@property (nonatomic,copy) NSString *themeName; //当前主题的名字
@property (nonatomic,retain) NSDictionary *themeConfiger; // 主题名字和路径的位置信息


// 单例方法
+ (instancetype)shareThemeManager;

// 通过图片的名字获取当前主题下的图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName;

// 通过字体的key获取对应主题下的颜色
- (UIColor *)getThemeColorWithTextColorKey:(NSString *)textColorKey;

// 返回导航栏的状态
- (void)setStatusBarTitleColor;
@end
