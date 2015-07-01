//
//  LocViewController.h
//  weibo
//
//  Created by zsm on 14-11-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@protocol LocViewControllerDelegate <NSObject>

// 当前控制器已经关闭调用的方法
- (void)locViweController:(UIViewController *)locViewController DidSelectedAddressInfo:(NSDictionary *)info;

@end

@interface LocViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@property (nonatomic, weak) id<LocViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *dataList;
@end
