//
//  AppDelegate.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 1.使用微博SDK
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取登陆信息缓存
    NSDictionary *dic = [userDefaults objectForKey:kWeiboToken];
    if (dic != nil) {
        self.wbtoken = dic[@"wbtoken"];
        self.userId = dic[@"userId"];
    }
    
    
    
    // 2.判断当前是否有缓存主题
    NSString *themeName = [userDefaults objectForKey:kThemeName];
    if (themeName == nil) {
        [userDefaults setObject:@"Blue Moon" forKey:kThemeName];
        [userDefaults synchronize];
    }
    
    // 3.设置当前主题下的状态栏样式
    [[ThemeManager shareThemeManager] setStatusBarTitleColor];

    
    // 4.给window添加一个主题背景视图
    UIImageView *imageView = [ThemeControl getImageViewWithThemeImageName:@"mask_bg.jpg" leftWidth:0 topHeight:0 frame:self.window.bounds];
    [self.window addSubview:imageView];
    
    
    
    
    
    return YES;
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        if (self.wbtoken == nil) {
            return;
        }
        self.userId = [(WBAuthorizeResponse *)response userID];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 获取登陆信息缓存
        NSDictionary *dic = @{@"wbtoken":_wbtoken,@"userId":_userId};
        [userDefaults setObject:dic forKey:kWeiboToken];
        [userDefaults synchronize];
        
        if ([self.loginDelegate respondsToSelector:@selector(loginDidRefreshData)]) {
            [self.loginDelegate loginDidRefreshData];
        }

    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


@end
