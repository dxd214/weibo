//
//  AppDelegate.h
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDidRefreshDelegate <NSObject>
/**
 *  登陆后继续加载网络的协议方法
 */
- (void)loginDidRefreshData;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *userId;
@property (weak, nonatomic) id<loginDidRefreshDelegate> loginDelegate;


@end

