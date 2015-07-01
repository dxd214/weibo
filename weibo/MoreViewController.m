//
//  MoreViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航按钮
    [self _initRootNavigationBarItem];
    
    // 1.初始化数据
    _dataList = @[@[@"主题",@"账户管理"],@[@"意见反馈"],@[@"注销当前账户"]];
    _imageNames = @[@[@"more_icon_theme.png",@"more_icon_account.png"],@[@"more_icon_feedback.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid_one"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 1.获取主题现实的文本
        UILabel *themeLabel = (UILabel *)[cell.contentView viewWithTag:12];
        themeLabel.right = kScreenWidth - 30;
        if (indexPath.section == 0 && indexPath.row == 0) {
            // 显示主题的文本
            themeLabel.hidden = NO;
            themeLabel.text = [ThemeManager shareThemeManager].themeName;
        } else {
            // 隐藏主题文本
            themeLabel.hidden = YES;
        }
        
        // 2.获取图片
        ThemeImageView *titleImageView = (ThemeImageView *)[cell.contentView viewWithTag:10];
        titleImageView.imageName = _imageNames[indexPath.section][indexPath.row];
        
        // 3.显示标题
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:11];
        titleLabel.text = _dataList[indexPath.section][indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid_two"];
        // 1.现实标题
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:13];
        titleLabel.left = 0;
        titleLabel.width = kScreenWidth;
        titleLabel.text = _dataList[indexPath.section][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 点击的是主题选着按钮
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    } else if (indexPath.section == 2) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 获取登陆信息缓存
        [userDefaults removeObjectForKey:kWeiboToken];
        [userDefaults synchronize];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.userId = nil;
        appDelegate.wbtoken = nil;
        
        // 点击的是登陆
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        appDelegate.loginDelegate = nil;
//        request.scope = @"all";
//        request.userInfo = nil;
        [WeiboSDK sendRequest:request];
    }
}

@end
