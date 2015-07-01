//
//  HomeViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "HomeViewController.h"
#import "MainTabBarController.h"
#import "WeiboModel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    // 使用默认主题背景
    self.isBgView = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航按钮
    [self _initRootNavigationBarItem];
    
    // 初始化子视图
    [self _initViews];
    
    // 加载微博数据
    [self loginDidRefreshData];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

// 初始化子视图
- (void)_initViews
{
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    // 添加下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(downLoad)];
    // 添加上拉加载更多
    [_tableView addFooterWithTarget:self action:@selector(upLoad)];
}

#pragma mark - 表示图刷新

/**
 *  下拉刷新
 */
- (void)downLoad
{
    // 表示图的加载不可多次同时加载
    if (_tableViewState == YES) {
        // 关闭表示图的刷新效果
        [_tableView headerEndRefreshing];
        return;
    } else {
        _tableViewState = YES;
    }
    
    // 获取当前以显示最晚发布的微博（即数组中第一条微博）
    WeiboModel *weiboModel = self.dataList[0];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@20 forKey:@"count"];
    [params setObject:weiboModel.weiboId forKey:@"since_id"];
    // 请求数据
    AFHTTPRequestOperation *operation = [DataService requestAFWithUrl:JK_home_timeline params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 获取微博数组
        NSArray *weiboArray = [result objectForKey:@"statuses"];
        
        // 如果没有最新的微博
        if (weiboArray.count == 0) {
            // 关闭表示图的刷新效果
            [_tableView headerEndRefreshing];
            _tableViewState = NO;
            return;
        }
        
        // 创建可变数组存放所有的数据原型
        NSMutableArray *weiboModels = [NSMutableArray array];
        // 便利数组，转换成数据原型
        for (NSDictionary *subDic in weiboArray) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithContentsOfDic:subDic];
            [weiboModels addObject:weiboModel];
        }
        
        // 保存数据到全局变量中
        self.dataList = [weiboModels arrayByAddingObjectsFromArray:self.dataList];
        
        // 把数据给表示图
        _tableView.dataList = self.dataList;
        [_tableView reloadData];
        // 关闭表示图的刷新效果
        [_tableView headerEndRefreshing];
        _tableViewState = NO;
        
        // 实现刷新出最新微博数
        [self showNewWeiboCount:(int)weiboModels.count];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

/**
 *  实现刷新出最新微博数
 *
 *  @param count 有几条未读微博
 */
- (void)showNewWeiboCount:(int)count
{
    // 先隐藏未读消息数
    MainTabBarController *mainTBC = (MainTabBarController *)self.navigationController.tabBarController;
    mainTBC.badgView.hidden = YES;
    
    if (_topBadgView == nil) {
        // 消息提示视图
        _topBadgView = [ThemeControl getImageViewWithThemeImageName:@"timeline_notify.png" leftWidth:160 topHeight:0 frame:CGRectMake(0, 0, kScreenWidth, 40)];
        // 消息提示文本
        UILabel *titleLabel = [ThemeControl getLabelWithTextColorKey:@"Mask_Title_color"
                                                          bgColorKey:nil
                                                               frame:_topBadgView.bounds];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.tag = 2014;
        [_topBadgView addSubview:titleLabel];
        [self.view addSubview:_topBadgView];
    }
    
    if (count == 0) {
        // 隐藏视图
        _topBadgView.hidden = YES;
    } else {
        // 显示视图
        _topBadgView.hidden = NO;
        // 设置文本
        UILabel *titleLabel = (UILabel *)[_topBadgView viewWithTag:2014];
        titleLabel.text = [NSString stringWithFormat:@"有%d条最新的微博",count];
        _topBadgView.bottom = 0;
        [UIView animateWithDuration:.35 animations:^{
            _topBadgView.top = 0;
        } completion:^(BOOL finished) {
            //收起动画
            [UIView animateWithDuration:.35 animations:^{
                [UIView setAnimationDelay:1];
                _topBadgView.bottom = 0;
            }];
        }];
        
        // 注册一个系统声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        SystemSoundID soundId;
        NSURL *url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        
        // 播放系统声音
        AudioServicesPlaySystemSound(soundId);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    }
}

/**
 *  上拉加载更多
 */
- (void)upLoad
{
    // 表示图的加载不可多次同时加载
    if (_tableViewState == YES) {
        // 关闭表示图的刷新效果
        [_tableView footerEndRefreshing];
        return;
    } else {
        _tableViewState = YES;
    }
    
    // 获取当前以显示最早发布的微博（即数组中最后一条微博）
    WeiboModel *weiboModel = [self.dataList lastObject];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@20 forKey:@"count"];
    [params setObject:weiboModel.weiboId forKey:@"max_id"];
    // 请求数据
    AFHTTPRequestOperation *operation = [DataService requestAFWithUrl:JK_home_timeline params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 获取微博数组
        NSArray *weiboArray = [result objectForKey:@"statuses"];
        
        // 如果没有最新的微博
        if (weiboArray.count <= 1) {
            // 关闭表示图的刷新效果
            [_tableView footerEndRefreshing];
            _tableViewState = NO;
            return ;
        }
        
        // 创建可变数组存放所有的数据原型
        NSMutableArray *weiboModels = [NSMutableArray array];
        // 便利数组，转换成数据原型
        for (NSDictionary *subDic in weiboArray) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithContentsOfDic:subDic];
            [weiboModels addObject:weiboModel];
        }
        
        // 删除重复微博数据（也就是第一条数据）
        [weiboModels removeObjectAtIndex:0];
        
        // 保存数据到全局变量中
        self.dataList = [self.dataList arrayByAddingObjectsFromArray:weiboModels];
        
        // 把数据给表示图
        _tableView.dataList = self.dataList;
        [_tableView reloadData];
        // 关闭表示图的刷新效果
        [_tableView footerEndRefreshing];
        _tableViewState = NO;
        
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

#pragma mark - loginDidRefreshDelegate
- (void)loginDidRefreshData
{
    // 设置表示图的加载状态
    _tableViewState = YES;
    
    // 1.加载数据之前隐藏表视图
    _tableView.hidden = YES;
    
    // 2.显示加载提示
    [_hud hide:YES];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载...";
    _hud.dimBackground = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@20 forKey:@"count"];
    
    // 请求数据
    AFHTTPRequestOperation *operation = [DataService requestAFWithUrl:JK_home_timeline params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 获取微博数组
        NSArray *weiboArray = [result objectForKey:@"statuses"];
        // 创建可变数组存放所有的数据原型
        NSMutableArray *weiboModels = [NSMutableArray array];
        // 便利数组，转换成数据原型
        for (NSDictionary *subDic in weiboArray) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithContentsOfDic:subDic];
            [weiboModels addObject:weiboModel];
        }
        
        // 保存数据到全局变量中
        self.dataList = weiboModels;
        
        // 把数据给表示图
        _tableView.dataList = self.dataList;
        
        // 加载完成
        [_tableView reloadData];
        _tableView.hidden = NO;
        _hud.labelText = @"加载完成";
        [_hud hide:YES afterDelay:.35];
        _hud = nil;
        _tableViewState = NO;
        
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
    // 当前为登陆
    if (operation == nil) {
        // 把当前控制器作为登陆成功的代理对象
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.loginDelegate = self;
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        [WeiboSDK sendRequest:request];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 判断当前控制器的根在不在window上
    if (self.view.window == nil) {
        self.view = nil;
        // 如果跟视图是全局变量我们就要释放
//        self.button = nil;
        // 1.所有的全局变量在初始化方法里面创建的是不能释放的，
        // 1.所有的全局变量在ViewDidLoad：方法中创建的数据全部得释放掉；
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
