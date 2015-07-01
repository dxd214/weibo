//
//  ThemeViewController.h
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_dataDic;
    NSArray *_dataList;
    
    UITableView *_tableView;
}
@end
