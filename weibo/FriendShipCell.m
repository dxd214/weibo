//
//  FriendShipCell.m
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FriendShipCell.h"
#import "FriendShipView.h"
@implementation FriendShipCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建用户视图
        for (int i = 0; i < 3; i++) {
            FriendShipView *friendsView = [[[NSBundle mainBundle]loadNibNamed:@"FriendShipView" owner:self options:nil]lastObject];
            friendsView.tag = 100 + i;
    
            [self.contentView addSubview:friendsView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //显示内容
    for (int i = 0; i < self.array2d.count; i++) {
        float width = (kScreenWidth - 40) / 3.0;
        FriendShipView *friendsView = (FriendShipView *)[self.contentView viewWithTag:100 + i];
        friendsView.frame = CGRectMake(10 + i * (width + 10), 10, width, width);
        //显示用户视图
        friendsView.hidden = NO;
        friendsView.model = self.array2d[i];
        [friendsView setNeedsLayout];
    }
    //隐藏视图
    for (int i = self.array2d.count; i < 3; i++) {
        FriendShipView *friendsView = (FriendShipView *)[self.contentView viewWithTag:100 + i];
        //显示用户视图
        friendsView.hidden = YES;
    }
}
@end
