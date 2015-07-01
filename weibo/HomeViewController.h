//
//  HomeViewController.h
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "WeiboTableView.h"
#import "MBProgressHUD.h"

@interface HomeViewController : BaseViewController<loginDidRefreshDelegate>
{
    MBProgressHUD *_hud;
    BOOL _tableViewState;
    UIImageView *_topBadgView;
}
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,strong) WeiboTableView *tableView;
@end
