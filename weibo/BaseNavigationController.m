//
//  BaseNavigationController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MainTabBarController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    // 1.注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kThemeNotificationChanged:) name:kThemeNotification object:nil];
    
    // 取消导航栏半透明的效果
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    
    // 设置导航栏图片
    [self loadNavigationBar];
}

// 主题改变的时候收到的通知
- (void)kThemeNotificationChanged:(NSNotification *)notification
{
    // 设置导航栏图片
    [self loadNavigationBar];
}

// 设置导航栏图片
- (void)loadNavigationBar
{
    // 设置导航栏的背景图片mask_titlebar.png
    // 获取主题管家类
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    UIImage *image = [themeManager getThemeImageWithImageName:@"mask_titlebar.png"];
    
    // 改变图片的大小
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 0, kScreenWidth, 64));
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];


}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1)
    {
        MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
        mainTBC.tabBarView.hidden = NO;
    }
    else if (self.viewControllers.count == 2)
    {
        MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
        mainTBC.tabBarView.hidden = YES;
    }
}


@end
