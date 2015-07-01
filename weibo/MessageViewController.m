//
//  MessageViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MessageViewController.h"
#import "FriendGroup.h"
#import "Friend.h"
#import "HeadView.h"
#import "ChatViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "FriendCell.h"

typedef void(^DidFinishBlock)(NSArray * groups);
@interface MessageViewController ()<HeadViewDelegate>
{
    NSArray *_friendsData;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    
    self.title = @"好友列表";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.设置XMPP用户
    [self loadUser];
    
    // 设置导航按钮
    [self _initRootNavigationBarItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.tableView.sectionHeaderHeight = 40;
    
    
    
}

// 1.设置XMPP用户
- (void)loadUser
{
    _xmmpManager = [MyXMPPManager shareManager];

    // 登陆操作
    [_xmmpManager login:@"zsm" password:@"123456" successBlock:^{
        NSLog(@"==登陆成功");
        
        // 请求好友列表
        [self loadData];
    }];
    
    NSLog(@"---");
}

#pragma mark 加载数据
/*
    @[
        @{
            @"name":@"我的好友"，
            @"online":10(在线人数),
            @"friends":@[
                            @{
                                @"friendId":@"",
                                @"icon":@"",
                                @"intro":@"",
                                @"name":@"",
                                @"vip":@""
                            },...(好友的信息字典)
                        ]
        },...(组的信息字典)
     ]
 */
- (void)loadData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //请求数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"199" forKey:@"count"];
    [params setObject:appDelegate.userId forKey:@"uid"];
    [DataService requestAFWithUrl:WB_JK_followers params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        //解析数据，
        [self getGroupsWithResult:result didFinishBlock:^(NSArray *groups) {
            // 把数据转换成MODEL原型
            NSMutableArray *fgArray = [NSMutableArray array];
            for (NSDictionary *dict in groups) {
                FriendGroup *friendGroup = [FriendGroup friendGroupWithDict:dict];
                [fgArray addObject:friendGroup];
            }
            
            _friendsData = fgArray;
            [_tableView reloadData];
        }];
        
        
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*
    @[
      @{
          @"name":@"我的好友"，
          @"online":10(在线人数),
          @"friends":@[
                  @{
                      @"friendId":@"",
                      @"icon":@"",
                      @"intro":@"",
                      @"name":@"",
                      @"vip":@""
                      },...(好友的信息字典)
                  ]
          },...(组的信息字典)
      ]
*/
- (void)getGroupsWithResult:(id)result didFinishBlock:(DidFinishBlock)block
{
    // 请求xmpp用户的好友
    [_xmmpManager getFreind:^(NSArray *friends) {
        // 外加了一组XMPP好友
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // 1.定义好友分组的数组
        NSMutableArray *groups = [NSMutableArray array];
        // 2.获取每组的好友列表
        // 1>我的好友数组
        NSArray *myArray = @[@{
                                 @"friendId":appDelegate.userId,
                                 @"icon":@"",
                                 @"intro":@"",
                                 @"name":@"朱思明",
                                 @"vip":@1
                                 }];
        // 2>粉丝好友数组
        NSArray *fsArray = [result objectForKey:@"users"];
        // 3>陌生人数组
        NSArray *msrArray = @[@{
                                  @"friendId":@"123456",
                                  @"icon":@"",
                                  @"intro":@"",
                                  @"name":@"陌生人",
                                  @"vip":@0
                                  }];
        // 4>黑名单数组
        NSArray *hmdArray = @[@{
                                  @"friendId":@"12345623",
                                  @"icon":@"",
                                  @"intro":@"",
                                  @"name":@"黑名单",
                                  @"vip":@0
                                  }];
        
        // 3.通过好友列表创建当前组字典
        NSArray *array = @[myArray,friends,fsArray,msrArray,hmdArray];
        NSArray *titles = @[@"我的好友",@"XMPP好友",@"粉丝好友",@"陌生人",@"黑名单"];
        for (int i = 0 ;i < array.count ;i++) {
            NSArray *subArray = array[i];
            // 创建组的字典
            NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
            [groupDic setObject:titles[i] forKey:@"name"];
            [groupDic setObject:@(subArray.count) forKey:@"online"];
            [groupDic setObject:subArray forKey:@"friends"];
            
            // 把组的字典添加到好友列表中
            [groups addObject:groupDic];
        }
        
        
        // 回调
        block(groups);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friendsData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroup *friendGroup = _friendsData[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil] lastObject];
    }
    
    FriendGroup *friendGroup = _friendsData[indexPath.section];
    
    cell.friendModel = friendGroup.friends[indexPath.row];;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    
    headView.delegate = self;
    headView.friendGroup = _friendsData[section];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendGroup *friendGroup = _friendsData[indexPath.section];
    Friend *friend = friendGroup.friends[indexPath.row];
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.title = friend.name;
    chatVC.friendModel = friend;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:chatVC];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)clickHeadView
{
    [self.tableView reloadData];
}

@end
