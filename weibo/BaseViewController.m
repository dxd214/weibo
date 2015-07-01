//
//  BaseViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "RootDrawerController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.自定义导航栏标题视图
    [self _initTitleLabel];
    
    // 2.默认背景视图
    if (_isBgView == YES) {
        UIImageView *imageView = [ThemeControl getImageViewWithThemeImageName:@"bg_home.jpg" leftWidth:0 topHeight:0 frame:self.view.bounds];
        [self.view addSubview:imageView];
    }
    
    // 3.创建返回按钮
    if (self.navigationController.viewControllers.count > 1 || self.isBack == YES)
    {
        UIButton *button = [ThemeControl getButtonWithThemeTitleImageName:nil bgImageName:@"titlebar_button_back_9.png" frame:CGRectMake(0, 0, 60, 44)];
        [button setTitle:@"返 回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        // 创建导航按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
}

// 1.自定义导航栏标题视图
- (void)_initTitleLabel
{
    UILabel *titleLabel = [ThemeControl getLabelWithTextColorKey:@"Mask_Title_color"
                                                      bgColorKey:nil
                                                           frame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    if (self.navigationItem.title != nil) {
        titleLabel.text = self.navigationItem.title;
    } else if (self.title != nil) {
        titleLabel.text = self.title;
    }
    
    self.navigationItem.titleView = titleLabel;
    
}

// 2.导航跟视图控制器的导航按钮实例
- (void)_initRootNavigationBarItem
{
    // 1.左侧导航按钮
    UIButton *leftButton = [ThemeControl getButtonWithThemeTitleImageName:@"group_btn_all_on_title.png" bgImageName:@"button_title.png" frame:CGRectMake(0, 0, 90, 35)];
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    // 设置视图的位置
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 10)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 1.右侧导航按钮
    UIButton *rightButton = [ThemeControl getButtonWithThemeTitleImageName:@"button_icon_plus.png" bgImageName:@"button_m.png" frame:CGRectMake(0, 0, 35, 35)];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

#pragma mark - UIBarButtonItem Action
- (void)leftButtonAction:(UIButton *)button
{
    // 获取当前的菜单控制器
     RootDrawerController *rootDC = (RootDrawerController *)self.view.window.rootViewController;
    
    // 调用菜单控制器打开左侧视图的方法(如果当前是打开状态，它执行关闭事件)
    [rootDC toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightButtonAction:(UIButton *)button
{
    // 获取当前的菜单控制器
    RootDrawerController *rootDC = (RootDrawerController *)self.view.window.rootViewController;
    
    // 调用菜单控制器打开右侧视图的方法(如果当前是打开状态，它执行关闭事件)
    [rootDC toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - 按钮返回事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
