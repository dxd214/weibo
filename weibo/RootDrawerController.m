//
//  RootDrawerController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "RootDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface RootDrawerController ()

@end

@implementation RootDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建故事版对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 1.创建左侧视图控制器
    self.leftDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftVC"];
    
    // 2.创建中间视图控制器
    self.centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTBC"];
    
    // 3.创建右侧视图控制器
    self.rightDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"RightVC"];
    
    // 设置左右视图显示的宽度
    self.maximumLeftDrawerWidth = 160;
    self.maximumRightDrawerWidth = 60;
    
    // 设置收拾作用的区域
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // 5.配置动画
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
    }];
    
    // 设置本地缓存的动画效果
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:kDrawAnimateType];
    
    // 设置动画方式
    [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = [dic[kDrawLeftType] integerValue];
    [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = [dic[kDrawRightType] integerValue];
    
    
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
