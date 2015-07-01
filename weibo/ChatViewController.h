//
//  ViewController.h
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Friend.h"
#import "MyXMPPManager.h"

@interface ChatViewController : BaseViewController

@property (nonatomic,strong) Friend *friendModel;
@end
