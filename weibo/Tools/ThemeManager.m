//
//  ThemeManager.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.获取当前主题的名字
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _themeName = [userDefaults objectForKey:kThemeName];
        
        // 2.加载配置信息
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ThemeList" ofType:@"plist"];
        _themeConfiger = [NSDictionary dictionaryWithContentsOfFile:filePath];
        

    }
    return self;
}


// 单例方法
+ (instancetype)shareThemeManager
{
    static ThemeManager *themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themeManager = [[ThemeManager alloc] init];
    });
    
    return themeManager;
}

// 通过图片的名字获取当前主题下的图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName
{
    // 设置导航栏的背景图片mask_titlebar.png
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@",_themeConfiger[_themeName],imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

// 通过字体的key获取对应主题下的颜色
- (UIColor *)getThemeColorWithTextColorKey:(NSString *)textColorKey
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/config.plist",_themeConfiger[_themeName]];
    // 颜色配置信息
    NSDictionary *colorConfiger = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSDictionary *colorDic = colorConfiger[textColorKey];
    float alpha = colorDic.count == 4 ? [colorDic[@"alpha"] floatValue] : 1;
    UIColor *color = [UIColor colorWithRed:[colorDic[@"R"] floatValue] / 255.0
                                     green:[colorDic[@"G"] floatValue] / 255.0
                                      blue:[colorDic[@"B"] floatValue] / 255.0
                                     alpha:alpha];
    return color;
}

#pragma mark - 重写set:
- (void)setThemeName:(NSString *)themeName
{
    if (_themeName != themeName) {
        _themeName = themeName;
        
        // 同步到本地的UserDefaults中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_themeName forKey:kThemeName];
        [userDefaults synchronize];
        
        // 发送一个通知，系统主题切换了
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeNotification object:nil];
        
        // 设置当前主题下的状态栏样式
        [self setStatusBarTitleColor];
        
        
        
    }
}

// 返回导航栏的状态
- (void)setStatusBarTitleColor
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/config.plist",_themeConfiger[_themeName]];
    // 颜色配置信息
    NSDictionary *configer = [NSDictionary dictionaryWithContentsOfFile:filePath];
    BOOL isWhite = [configer[@"Statusbar_Style"] boolValue];
    // 根据主题改变状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:isWhite == YES ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault];
}
@end
