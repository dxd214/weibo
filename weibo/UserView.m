//
//  UserView.m
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "UserView.h"
#import "UserModel.h"
#import "RectButton.h"
#import "FriendsViewController.h"
@implementation UserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    //设置背景图片
    UIImage *image = [UIImage imageNamed:@"userinfo_shadow_pic.png"];
    _bgImageView.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)fsActction:(UIButton *)button
{
    FriendsViewController *fsVC = [[FriendsViewController alloc]init];
    fsVC.shipType = FriendshipTypeFans;
    fsVC.userId = self.model.userId;
    [self.ViewController.navigationController pushViewController:fsVC animated:YES];
    
}

- (void)gzActction:(UIButton *)button
{
    
    FriendsViewController *fsVC = [[FriendsViewController alloc]init];
    fsVC.shipType = FriendshipTypeGuanZhu;
    fsVC.userId = self.model.userId;

    [self.ViewController.navigationController pushViewController:fsVC animated:YES];

}
- (void)setModel:(UserModel *)model
{
    if (_model != model) {
        _model = model;
        
        
        //名字
        _nameLabel.text = self.model.screen_name;
        NSString *sex = nil;
        if ([self.model.gender isEqualToString:@"m"]) {
            sex = @"男";
        }else if ([self.model.gender isEqualToString:@"f"]) {
            sex = @"女";
        }else {
            sex = @"未知";
        }
        //地址
        NSString *address = [NSString stringWithFormat:@"%@ %@",sex,self.model.location];
        _addressLabel.text = address;
        //简介
        _contentLabel.text = [NSString stringWithFormat:@"简介：%@",self.model.userDescription];
        //关注
        _gzButton.subTitle = [NSString stringWithFormat:@"%@",self.model.friends_count];
        _gzButton.title = @"关 注";
        
        //粉丝
        _fsButton.subTitle = [NSString stringWithFormat:@"%@",self.model.followers_count];
        _fsButton.title = @"粉 丝";
        
        _zlButton.title = @"资料";
        _gdButton.title = @"更多";
        
        //头像
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:self.model.profile_image_url]];
        
        if ([_fsButton allTargets].count == 0) {
            [_fsButton addTarget:self action:@selector(fsActction:) forControlEvents:UIControlEventTouchUpInside];
            [_gzButton addTarget:self action:@selector(gzActction:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
}


@end
