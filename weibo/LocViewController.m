//
//  LocViewController.m
//  weibo
//
//  Created by zsm on 14-11-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "LocViewController.h"

@interface LocViewController ()

@end

@implementation LocViewController

- (void)viewDidLoad {
    self.isBgView = YES;
    self.isBack = YES;
    self.title = @"附近商圈";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化子视图
    [self _initViews];
    
    // 加载当前位置
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    // 设置位置的精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    // 开始定位
    [_locationManager startUpdatingLocation];
}

// 初始化子视图
- (void) _initViews
{
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取经纬度，开始请求网络
- (void)loadNearByAddressWithlong:(NSString *)lon lat:(NSString *)lat
{
    // 开始请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    
    [DataService requestAFWithUrl:JK_nearby_pois params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.dataList = result[@"pois"];
        [_tableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR:%@",error);
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 停止定位服务
    [manager stopUpdatingLocation];
    
    // 获取当前请求下来的位置
    CLLocation *location = [locations lastObject];
    
    // 获取经纬度，开始请求网络
    [self loadNearByAddressWithlong:[NSString stringWithFormat:@"%f",location.coordinate.longitude] lat:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // 当前单元格对应的字典
    NSDictionary *dic = self.dataList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(locViweController:DidSelectedAddressInfo:)]) {
            // 调用协议方法
            [self.delegate locViweController:self DidSelectedAddressInfo:self.dataList[indexPath.row]];
        }
    }];
}

#pragma mark - 按钮返回事件(重写父类的方法)
- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
