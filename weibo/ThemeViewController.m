//
//  ThemeViewController.m
//  weibo
//
//  Created by zsm on 14-11-12.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController
- (void)dealloc
{
    NSLog(@"呵呵");
}
- (void)viewDidLoad {
    
    self.title = @"主题选择";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 1.初始化数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ThemeList" ofType:@"plist"];
    _dataDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    _dataList = [_dataDic allKeys];
    
    // 2.初始化子视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // 获取当前主题类
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    if ([_dataList[indexPath.row] isEqualToString:themeManager.themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取主题管家类
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    if (![themeManager.themeName isEqualToString:_dataList[indexPath.row]]) {
        // 1.保存当前的主题
        // 改变当前的主题
        themeManager.themeName = _dataList[indexPath.row];
        
        // 2.刷新表视图
        [_tableView reloadData];
        
    }
    
    
}
@end
