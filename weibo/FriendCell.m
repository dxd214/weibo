//
//  FriendCell.m
//  weibo
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
    // 1.设置头像圆角
    _userImageView.layer.cornerRadius = 20;
    _userImageView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置头像
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:self.friendModel.icon] placeholderImage:[UIImage imageNamed:@"friend_icon.png"]];
    
    // 2.设置名字
    _nameLabel.text = self.friendModel.name;
    
    // 3.设置个性签名
    _contentLabel.text = self.friendModel.intro;
}

@end
