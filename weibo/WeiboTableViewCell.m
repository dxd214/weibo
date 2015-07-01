//
//  WeiboTableViewCell.m
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "UserModel.h"
#import "ProfileViewController.h"

@implementation WeiboTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // 1.设置背景视图
    UIImage *bgImage = [UIImage imageNamed:@"userinfo_shadow_pic.png"];
    _bgImageView.image = [bgImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    // 2.设置按钮圆角
    _titleButton.layer.cornerRadius = 5.0;
    _titleButton.layer.masksToBounds = YES;

    // 3.创建weibo内容视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    _weiboView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_weiboView];
    
    // 4.设置选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 5.清空背景颜色
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 获取用户信息
    UserModel *userModel = self.model.userModel;
    
    
    // 1.设置头像
    [_titleButton sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] forState:UIControlStateNormal];
    
    // 2.设置用户昵称
    _nameLabel.text = userModel.screen_name;
    
    // 3.设置微博时间
    _timeLabel.text = self.model.created_at;
    
    // 4.微博来源
    _sourceLabel.text = self.model.source;
    
    // 5.转发
    NSString *reposterString = [NSString stringWithFormat:@"转发:%@",self.model.reposts_count];
    [_reposterButton setTitle:reposterString forState:UIControlStateNormal];
    
    // 6.评论
    NSString *commentString = [NSString stringWithFormat:@"评论:%@",self.model.comments_count];
    [_commentButton setTitle:commentString forState:UIControlStateNormal];
    
    // 5.赞
    NSString *zanString = [NSString stringWithFormat:@"赞:%@",self.model.attitudes_count];
    [_zanButton setTitle:zanString forState:UIControlStateNormal];
    
    // 6.设置微博内容视图
    _weiboView.frame = CGRectMake(20, 70, kScreenWidth - 40, self.height - 120);
    _weiboView.weiboModel = self.model;
    // 手动调用layoutSubViews
    [_weiboView setNeedsLayout];
}

- (IBAction)titleButtonAction:(id)sender {
    // 1.点击的是@用户
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.userModel = self.model.userModel;
    [self.ViewController.navigationController pushViewController:profileVC animated:YES];
}
@end
