//
//  NearByViewController.m
//  weibo
//
//  Created by zsm on 14-11-21.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearByViewController ()

@end

@implementation NearByViewController

- (void)viewDidLoad {
    self.title = @"附近的微博";
    self.isBgView = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    // 获取当前位置
    [self myLocationManager];
}

// 获取当前位置
- (void)myLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0) {
        // 8.0里面必须设置的放大
        // 请求如许使用定位服务
        [_locationManager requestAlwaysAuthorization];
    }
    
    // 设置请求信息的精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取经纬度，开始请求网络
- (void)loadNearByWeiboWithlong:(NSString *)lon lat:(NSString *)lat
{
    // 在地图上显示自己的位置
    MKUserLocation *userLocation = [[MKUserLocation alloc] init];
    userLocation.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    [_mapView addAnnotation:userLocation];
    
    // 开始请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    
    [DataService requestAFWithUrl:JK_nearby_timeline params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        // 把请求下来的数据解析成数据原型对象
        NSArray *statuses = result[@"statuses"];
        // 创建一个存放所有model的数组
//        NSMutableArray *weiboModels = [[NSMutableArray alloc] init];
        for (NSDictionary *subDic in statuses) {
            // 创建weiboModel
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithContentsOfDic:subDic];
//            [weiboModels addObject:weiboModel];
            
            // 创建标注视图的数据原型累
            WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] init];
            weiboAnnotation.weiboModel = weiboModel;
            [_mapView addAnnotation:weiboAnnotation];
        }
        
//        self.dataList = weiboModels;
        
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
    // 设置地图中心点位置
    CLLocationCoordinate2D coordinate2D = location.coordinate;
    MKCoordinateSpan span = {.1,.1};
    MKCoordinateRegion region = {coordinate2D,span};
    [_mapView setRegion:region];
    
    // 获取经纬度，开始请求网络
    [self loadNearByWeiboWithlong:[NSString stringWithFormat:@"%f",location.coordinate.longitude] lat:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 判断当前标注是否是自己的位置
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // 自定义标注视图
    static NSString *identifier = @"weiboAnnotationViewId";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    // 重新的给定数据
    annotationView.annotation = annotation;
    [annotationView setNeedsLayout];
    return annotationView;
}

// 当标注视图添加到地图上显示的时候调用的协议方法
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    /*  
        1.视图放大 .7 -> 1.2 alpha 0->1
        2.视图缩小 1.2 ->1.0
     */
    int time = 0;
    
    for (UIView *annotationView in views) {
        // 1.视图放大 .7 -> 1.2 alpha 0->1
        annotationView.transform = CGAffineTransformMakeScale(.7, .7);
        annotationView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            // 设置延迟调用
            [UIView setAnimationDelay:time *.05];
            annotationView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            annotationView.alpha = 1;
        } completion:^(BOOL finished) {
            // 2.视图缩小 1.2 ->1.0
            [UIView animateWithDuration:.3 animations:^{
                annotationView.transform = CGAffineTransformIdentity;
            }];
        }];
        
        time++;
    }
}








@end
