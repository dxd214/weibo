//
//  RightViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SenderViewController.h"
#import "RootDrawerController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 设置按钮的图片和事件
    // 图片的数组
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    for (int i = 0; i < imageNames.count; i++) {
        // 获取对应的按钮
        ThemeButton *button = (ThemeButton *)[self.view viewWithTag:201 + i];
        // 设置标题图片的名字
        button.titleImageName = imageNames[i];
        // 添加事件
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 201) {
        // 写微博按钮
        // 1.显示中间视图控制器
        // 获取当前的菜单控制器
        RootDrawerController *rootDC = (RootDrawerController *)self.view.window.rootViewController;

        // 显示中间视图控制器
        [rootDC toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            // 2.弹出发送微博控制器
            SenderViewController *senderVC = [[SenderViewController alloc] init];
            // 创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:senderVC];
            [self presentViewController:baseNav animated:YES completion:nil];
        }];
    }
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
