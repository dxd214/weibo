//
//  MainTabBarController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MainTabBarController.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.自定义标签栏
    [self _initTabBarView];
    
    [self performSelector:@selector(loadUnReadWeiboCount) withObject:nil afterDelay:5];
}

// 1.自定义标签栏
- (void)_initTabBarView
{
    float top = kVersion >= 7.0 ? (kScreenHeight - 49) : kScreenHeight - 49 - 20;
    // 1.创建标签栏
    _tabBarView = [ThemeControl getImageViewWithThemeImageName:@"mask_navbar.png"
                                                     leftWidth:0
                                                     topHeight:0
                                                         frame:CGRectMake(0, top, kScreenWidth, 49)];
    
    // 3.开启点击事件
    _tabBarView.userInteractionEnabled = YES;
    
    [self.view addSubview:_tabBarView];
    
    // 4.创建选中按钮的背景图片
    UIImageView *selectedImageView = [ThemeControl getImageViewWithThemeImageName:@"home_bottom_tab_arrow.png"
                                                                        leftWidth:0
                                                                        topHeight:0 frame:CGRectMake(0, 0, 64, 45)];
    selectedImageView.tag = 1234;
    [_tabBarView addSubview:selectedImageView];
    // 4.创建标签按钮
    NSArray *imageNames = @[@"home_tab_icon_1.png",@"home_tab_icon_2.png",@"home_tab_icon_3.png",@"home_tab_icon_4.png",@"home_tab_icon_5.png"];
    for (int i = 0; i < imageNames.count; i++)
    {
        CGRect frame = CGRectMake(kScreenWidth / 5.0 * i, 0, kScreenWidth / 5.0, 49);
        UIButton *button = [ThemeControl getButtonWithThemeTitleImageName:imageNames[i] frame:frame];
        // 设置点击事件
        button.tag = i;
        [button addTarget:self action:@selector(tabBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:button];
        
        if (i == 0)
        {
            selectedImageView.center = CGPointMake(button.center.x, button.center.y + 2);
        }
    }
    
}

#pragma mark - tabBarItem Action
- (void)tabBarItemAction:(UIButton *)button
{
    
    
    self.selectedIndex = button.tag;
    // 获取选中图片
    UIImageView *selectedImageView = (UIImageView *)[_tabBarView viewWithTag:1234];
    
    [UIView animateWithDuration:.35 animations:^{
        selectedImageView.center = CGPointMake(button.center.x, button.center.y + 2);
    } completion:^(BOOL finished){
        // 自动刷新效果
        if (button.tag == 0 && _badgView.hidden == NO) {
            HomeViewController *homeVC = (HomeViewController *)((UINavigationController *)self.viewControllers[0]).topViewController;
            [homeVC.tableView headerBeginRefreshing];
            
        }
    }];
    
}



- (void)loadUnReadWeiboCount
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 可以在加一条判断，当前首页已经加载完成
    if (appDelegate.userId != nil && appDelegate.wbtoken != nil) {
        // 创建请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:appDelegate.userId forKey:@"uid"];
        [DataService requestAFWithUrl:JK_unread_count params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            // 获取新微博未读数
            int count = [result[@"status"] intValue];
            [self loadBadgViewUnReadWeiboWithCount:count];
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
    }
    
    [self performSelector:@selector(loadUnReadWeiboCount) withObject:nil afterDelay:5];
}

/**
 *  显示未读微博数
 *
 *  @param count 未读微博数
 */
- (void)loadBadgViewUnReadWeiboWithCount:(int)count
{
    if (_badgView == nil) {
        _badgView = [ThemeControl getImageViewWithThemeImageName:@"number_notify_9.png" leftWidth:0 topHeight:0 frame:CGRectMake((kScreenWidth / 5.0 - 32), 0, 32, 32)];
        // 创建文本视图
        // 消息提示文本
        UILabel *titleLabel = [ThemeControl getLabelWithTextColorKey:@"Mask_Title_color"
                                                          bgColorKey:nil
                                                               frame:_badgView.bounds];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        titleLabel.tag = 2014;
        [_badgView addSubview:titleLabel];
        
        // 未读消息提示文本添加到标签栏上
        [_tabBarView addSubview:_badgView];
    }
    
    if (count == 0) {
        // 隐藏视图
        _badgView.hidden = YES;
    } else {
        _badgView.hidden = NO;
        UILabel *titleLabel = (UILabel *)[_badgView viewWithTag:2014];
        titleLabel.text = [NSString stringWithFormat:@"%d",count];
    }
}


- (void)myCode
{
    NSDictionary *info = [NSDictionary dictionary];
    NSMutableArray *_imageArray = [NSMutableArray array];
    UIScrollView *_imageScrollerView = [[UIScrollView alloc]init];
    _imageScrollerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        imgBtn.frame = _addImgBtn.frame;
        [imgBtn setTitle:@"上传中。。。" forState:UIControlStateNormal];
        imgBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [imgBtn setBackgroundImage:[UIColor whiteColor] forState:UIControlStateNormal];
        [imgBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageScrollerView addSubview:imgBtn];
        [_imageArray addObject:imgBtn];
        
    }
}
- (void)buttonAction:(UIButton *)button
{
    NSLog(@"点击了");
}
@end
