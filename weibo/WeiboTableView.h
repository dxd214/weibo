//
//  WeiboTableView.h
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSArray *dataList;
@end
