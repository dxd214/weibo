//
//  SenderViewController.m
//  weibo
//
//  Created by zsm on 14-11-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "SenderViewController.h"
#import "LocViewController.h"
#import "BaseNavigationController.h"

@interface SenderViewController ()

@end

@implementation SenderViewController

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}


- (void)viewDidLoad {
    self.title = @"写微博";
    self.isBgView = YES;
    self.isBack = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化子视图
    [self _initViews];
    
}
// 初始化子视图
- (void)_initViews
{
    // 1.创建发送按钮
    [self _initRightBarButtonItem];
    
    // 2.创建为本视图
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textView];
    
    // 3.设置工具栏
    _toolsView.frame = CGRectMake(0, kScreenHeight - 64 - 80, kScreenWidth, 80);
    _toolsView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    [self.view addSubview:_toolsView];
    
    // 4.创建工具栏上的按钮
    NSArray *imageNames = @[@"compose_toolbar_1.png",
                            @"compose_toolbar_3.png",
                            @"compose_toolbar_6.png",
                            @"compose_toolbar_5.png",
                            @"compose_toolbar_4.png"];
    for (int i = 0; i < imageNames.count; i++) {
        CGRect frame = CGRectMake(kScreenWidth / imageNames.count * i, 44, kScreenWidth / imageNames.count, 33);
        UIButton *button = [ThemeControl getButtonWithThemeTitleImageName:imageNames[i] frame:frame];
        button.tag = i;
        [button addTarget:self action:@selector(toolsButtonAtion:) forControlEvents:UIControlEventTouchUpInside];
        [_toolsView addSubview:button];
    }
}

// 1.创建发送按钮
- (void)_initRightBarButtonItem
{
    UIButton *button = [ThemeControl getButtonWithThemeTitleImageName:nil bgImageName:@"titlebar_button_9.png" frame:CGRectMake(0, 0, 60, 44)];
    [button setTitle:@"发 送" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    // 创建导航按钮
    UIBarButtonItem *senderItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = senderItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 发送微博
- (void)senderAction:(UIButton *)button
{
    if (_textView.text.length == 0 && _textView.text.length >= 140) {
        NSLog(@"文本输入有误！");
        return;
    }
    
    // 创建参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_textView.text forKey:@"status"];
    
    // 判断是否上传位置
    if (_locInfo != nil) {
        // 添加位置参数
        [params setObject:_locInfo[@"lat"] forKey:@"lat"];
        [params setObject:_locInfo[@"lon"] forKey:@"long"];
    }
    
    // 是否发送图片
    NSString *urlString = nil;
    if (_weiboImageView.hidden == NO) {
        urlString = JK_statuses_upload;
        // 添加图片
        NSData *imageData = UIImageJPEGRepresentation(_weiboImageView.image, .1);
        [params setObject:imageData forKey:@"pic"];
    } else {
        urlString = JK_statuses_update;
    }
    
    // 请求网络发微博
    [DataService requestAFWithUrl:urlString params:params reqestHeader:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"发送成功");
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送失败:%@",error);
    }];
}

#pragma mark - FaceViewDelegate
- (void)touchEndFaceViewWithImageFaceName:(NSString *)faceName
{
    _textView.text = [_textView.text stringByAppendingString:faceName];
}

#pragma mark - 工具栏按钮点击事件
- (void)toolsButtonAtion:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            // 1.上传图片
            {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选取微博图片" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", nil];
                [sheet showInView:self.view];
            }
            break;
        case 1:
            // 2.关联用户
            break;
        case 2:
            // 3.表情
            {
                // 判断表情面板是否被创建
                if (_faceView == nil) {
                    _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 216) delegate:self];
                    _faceView.backgroundColor = [UIColor redColor];
                }
                
                // 判断表情面板是否在显示
                _isTouchFaceView = YES;
                [_textView resignFirstResponder];
                _textView.inputView = _textView.inputView == nil ? _faceView : nil;
                [_textView becomeFirstResponder];

            }
            break;
        case 3:
            // 4.位置
            {
                // 关闭键盘
                [_textView resignFirstResponder];
                
                // 创建控制器
                LocViewController *locVC = [[LocViewController alloc] init];
                locVC.delegate = self;
                BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:locVC];
                [self presentViewController:baseNav animated:YES completion:nil];
            }
            break;
        case 4:
            // 5.话题
            break;
            
        default:
            break;
    }
}

#pragma mark - LocViewControllerDelegate
- (void)locViweController:(UIViewController *)locViewController DidSelectedAddressInfo:(NSDictionary *)info
{
    _locInfo = info;
    // 设置定位图片
    [_locImageView sd_setImageWithURL:[NSURL URLWithString:info[@"icon"]]];
    _locImageView.hidden = NO;
    
    // 设置定位文本
    _locLabel.text = info[@"title"];
    _locLabel.hidden = NO;
    
    // 现实按钮
    _locCloseButton.hidden = NO;
    
     
}

#pragma mark - 按钮返回事件(重写父类的方法)
- (void)backAction:(UIButton *)button
{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 键盘大小改变通知
/*
{
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
}
*/
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    // 获取键盘变换后的高度
    double keyboard_height = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _toolsView.bottom = kScreenHeight - 64 - keyboard_height;
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    if (_isTouchFaceView == NO) {
        _toolsView.bottom = kScreenHeight - 64;
    }
    
    _isTouchFaceView = NO;
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = 0;
    if (buttonIndex == 0) {
        // 打开相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1 ) {
        // 打开相机
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        return;
    }
    
    // 关闭键盘
    [_textView resignFirstResponder];
    
    // 创建相册控制器（包括相机）
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.sourceType = sourceType;
    imagePickerCtrl.delegate = self;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选择的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _weiboImageView.image = image;
    _weiboImageView.hidden = NO;
    _weiboCloseButton.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)locCloseAction:(UIButton *)sender {
    // 删除定位图片
    _locImageView.image = nil;
    _locImageView.hidden = YES;
    
    // 删除定位文本
    _locLabel.text = @"";
    _locLabel.hidden = YES;
    
    sender.hidden = YES;
    
    // 清空位置信息字典
    _locInfo = nil;
}

- (IBAction)imageCloseAtion:(UIButton *)sender {
    // 删除图片
    _weiboImageView.image = nil;
    _weiboImageView.hidden = YES;
    sender.hidden = YES;
}
@end
