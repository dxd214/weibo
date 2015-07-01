//
//  DetailViewController.h
//  weibo
//
//  Created by zsm on 14-11-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboView.h"

@interface DetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_headerView;
    WeiboView *_weiboView;
    IBOutlet UIView *_userView;
    
}
@property (nonatomic,assign) int total_number;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,strong) WeiboModel *weiboModel;
@end
