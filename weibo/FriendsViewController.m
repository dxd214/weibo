//
//  FriendsViewController.m
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FriendsViewController.h"
#import "UserModel.h"
#import "FriendShipTableView.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.isBgView = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) _initViews
{
    _tableView = [[FriendShipTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

- (void)loadData
{
    //请求数据
    NSString *url = self.shipType == FriendshipTypeGuanZhu ? WB_JK_friends : WB_JK_followers;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"50" forKey:@"count"];
    [params setObject:self.userId forKey:@"uid"];
    [DataService requestAFWithUrl:url params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        //解析数据，并转化为2维数组
        NSArray *users = [result objectForKey:@"users"];
        
        //大数组存放所有的数据
        NSMutableArray *models = [NSMutableArray array];
        //小数组没个小数组里面存放3个MODEL
        NSMutableArray *array2d = nil;
        
        for (int i = 0;i < users.count ;i++) {
            if (i % 3 == 0) {
                array2d = [NSMutableArray arrayWithCapacity:3];
                [models addObject:array2d];
            }
            NSDictionary *dic = users[i];
            UserModel *model = [[UserModel alloc]initWithContentsOfDic:dic];
            [array2d addObject:model];

            
        }
        //把数据给表视图去显示
        _tableView.dataList = models;
        [_tableView reloadData];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
