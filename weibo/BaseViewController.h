//
//  BaseViewController.h
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isBgView;
@property (nonatomic, assign) BOOL isBack;
// 导航跟视图控制器的导航按钮实例
- (void)_initRootNavigationBarItem;
@end
