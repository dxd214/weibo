//
//  WeiboTableView.m
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboTableViewCell.h"
#import "DetailViewController.h"

@implementation WeiboTableView
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiboImageViewDidChangedNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kWeiboImageViewDidChangedNotification object:nil];
    }
    return self;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"weiboCellId";
    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboTableViewCell" owner:nil options:nil] lastObject];
    }
    
    WeiboModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格的基本内容高度120 ，整体高度等于120 + 微博内容高度
    // 基本的高度：70（头像的下面）+ 40（底部按钮的高度） + 10（内容和底部按钮的间距）
    // 1.定义基本高度
    float height = 120;
    // 2.计算weibo视图高度
    // 获取内容
    WeiboModel *weiboModel = _dataList[indexPath.row];
    // 01 在基础高度上加上微博文本高度
    height += [WXLabel getAttributedStringHeightWithString:weiboModel.text WidthValue:kScreenWidth - 40 delegate:nil font:[UIFont systemFontOfSize:14]] + 5;
    // 02 是否有转发微博
    if (weiboModel.reWeibo != nil) {
        // 加上转发微博内容的高度 和 10 的间距 和 下面北京图片的距离
        height += [WXLabel getAttributedStringHeightWithString:weiboModel.reWeibo.text WidthValue:kScreenWidth - 60 delegate:nil font:[UIFont systemFontOfSize:12]] + 10 + 10;
        // 是否有转发微博图片
        
        if (weiboModel.reWeibo.bmiddle_pic != nil) {
            height += kWeibImageViewHeight + 5;
        }
    } else {
        // 是否有微博图片
        if (weiboModel.bmiddle_pic != nil) {
            height += kWeibImageViewHeight + 5;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建微博详情控制器
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.weiboModel = self.dataList[indexPath.row];
    [self.ViewController.navigationController pushViewController:detailVC animated:YES];
}

@end
