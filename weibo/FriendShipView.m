//
//  FriendShipView.m
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FriendShipView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "ProfileViewController.h"
@implementation FriendShipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    profileVC.userModel = self.model;
    [self.ViewController.navigationController pushViewController:profileVC animated:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置头像
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_model.profile_image_url]];
    _userImageView.frame = CGRectMake(self.width * .25, 10, self.width * .5, self.width * .5);
    //设置名字
    _nameLabel.text = _model.screen_name;
    _nameLabel.frame = CGRectMake(0, _userImageView.bottom + 2, self.width, 15);
    //设置粉丝数
    _fsCountLabel.text = [NSString stringWithFormat:@"粉丝：%@",_model.followers_count];
    _fsCountLabel.frame = CGRectMake(0, _nameLabel.bottom + 2, self.width, 15);
}

@end
