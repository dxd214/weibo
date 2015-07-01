//
//  LeftViewController.m
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 1.初始化数据
    _dataList = @[@[@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差"],@[@"小图",@"大图"]];
    
    // 2.初始化子视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, kScreenHeight ) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
//    _tableView.clipsToBounds = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
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
    return [[_dataList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"leftCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // 获取UserDefaults对象
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 设置选中模式
    if (indexPath.section == 0) {
        // 设置‘界面动画切换’
        // 1.获取当前选中的样式
        NSDictionary *dic = [userDefaults objectForKey:kDrawAnimateType];
        MMDrawerAnimationType leftType = [dic[kDrawLeftType] integerValue];
        if (indexPath.row == leftType) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else if (indexPath.section == 1) {
        // 设置‘图片浏览模式’
        NSInteger imageTypeIndex = [[userDefaults objectForKey:kImageScale] integerValue];
        if (indexPath.row == imageTypeIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.textLabel.text = _dataList[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = [NSString stringWithFormat:@"  %@",section == 0 ? @"界面切换效果" : @"图片浏览模式"];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 设置‘界面动画切换’
        // 1.设置切换类型
        [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = indexPath.row;
        [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = indexPath.row;
        
        // 保存切换动画
        [[MMExampleDrawerVisualStateManager sharedManager] saveConfig];
        
        
    } else if (indexPath.section == 1) {
        // 设置‘图片浏览模式’
        // 获取UserDefaults对象
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(indexPath.row) forKey:kImageScale];
        [userDefaults synchronize];
        
        // 发送通知（刷新微博列表的表视图）
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiboImageViewDidChangedNotification object:nil];
    }
    
    // 刷新表视图
    [tableView reloadData];
}
@end
