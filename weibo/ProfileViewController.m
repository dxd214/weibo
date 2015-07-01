//
//  ProfileViewController.m
//  MyWeibo
//
//  Created by zsm on 14-2-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ProfileViewController.h"
#import "DataService.h"
#import "UserView.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "NSString+URLEncoding.h"

/*
 statuses/user_timeline.json
 */
@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    self.title = @"个人中心";
    self.isBgView = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor whiteColor];
    [self _initViews];
    
    if (self.userModel == nil) {
        [self loadUserData];
        //表视图的高度 ，屏幕高度 - 64 - 40；
    } else {
        _userView.model = self.userModel;
        //表视图的高度 ，屏幕高度 - 64 ；
    }
    
}
- (void)_initViews
{
    _userView = [[[NSBundle mainBundle]loadNibNamed:@"UserView" owner:self options:nil]lastObject];
    _userView.width = kScreenWidth;
    [self.view addSubview:_userView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
- (void)loadUserData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.screenName == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [params setObject:appDelegate.userId forKey:@"uid"];
    }else {
        [params setObject:[self.screenName URLEncodedString]  forKey:@"screen_name"];
    }
    [DataService requestAFWithUrl:JK_users_show params:params reqestHeader:nil httpMethod:@"GET" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        UserModel *model = [[UserModel alloc]initWithContentsOfDic:result];
        _userView.model = model;
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];

}


@end
