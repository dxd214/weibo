//
//  DetailViewController.m
//  weibo
//
//  Created by zsm on 14-11-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    self.isBgView = YES;
    
    self.title = @"微博详情";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    // 初始化子视图
    [self _initViews];
    
    // 请求网络数据
    [self loadCommentData];
}

// 请求网络数据
- (void)loadCommentData
{
    // 配置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@50 forKey:@"count"];
    [params setObject:self.weiboModel.weiboId forKey:@"id"];
    
    // 开始网络请求
    [DataService requestAFWithUrl:JK_comments_show params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 把数据转换成数据远程对象
        // 记录共有多少条评论
        _total_number = [[result objectForKey:@"total_number"] intValue];
        
        NSMutableArray *commentModels = [NSMutableArray array];
        for (NSDictionary *subDic in result[@"comments"]) {
            // 创建数据原型对象
            CommentModel *model = [[CommentModel alloc] initWithContentsOfDic:subDic];
            [commentModels addObject:model];
        }
        
        // 保存评论数据到全局变量中
        self.dataList = commentModels;
        [_tableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

// 初始化子视图
- (void)_initViews
{
    float weibo_height = [self getHeightWithWeiboModel:self.weiboModel];
    // 1.创建头视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _userView.height + weibo_height + 20)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    // 2.创建用户视图(给子视图赋值)
    _userView.width = kScreenWidth;
    _userView.backgroundColor = [UIColor clearColor];
    // 头像
    UIButton *titleButton = (UIButton *)[_userView viewWithTag:20];
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.weiboModel.userModel.avatar_hd] forState:UIControlStateNormal];
    
    // 昵称
    UILabel *nickNameLabel = (UILabel *)[_userView viewWithTag:21];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.text = self.weiboModel.userModel.screen_name;
    
    // 个人描述
    UILabel *descriptionLabel = (UILabel *)[_userView viewWithTag:22];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = self.weiboModel.userModel.userDescription;
    [_headerView addSubview:_userView];
    
    
    
    // 3.创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userView.bottom + 10, kScreenWidth - 20, weibo_height)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = self.weiboModel;
    [_headerView addSubview:_weiboView];
    
    // 4.创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

/**
 *  根据微博内容计算视图的高度
 *
 *  @param weiboModel 微博的原型类
 *
 *  @return 微博的高度
 */
- (float)getHeightWithWeiboModel:(WeiboModel *)weiboModel
{
    // 1.定义基本高度
    float height = 0;
    // 2.计算weibo视图高度
    // 01 在基础高度上加上微博文本高度
    height += [WXLabel getAttributedStringHeightWithString:weiboModel.text WidthValue:kScreenWidth - 40 delegate:nil font:[UIFont systemFontOfSize:18]] + 5;
    // 02 是否有转发微博
    if (weiboModel.reWeibo != nil) {
        // 加上转发微博内容的高度 和 10 的间距 和 下面北京图片的距离
        height += [WXLabel getAttributedStringHeightWithString:weiboModel.reWeibo.text WidthValue:kScreenWidth - 60 delegate:nil font:[UIFont systemFontOfSize:16]] + 10 + 10;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"commentCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    
    // 获取当前评论数据原型
    CommentModel *commentModel = self.dataList[indexPath.row];
    cell.textLabel.text = commentModel.text;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    int count = _total_number == 0 ? [self.weiboModel.comments_count intValue] : _total_number;
    label.text = [NSString stringWithFormat:@"  共%d条评论",count];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}





@end
