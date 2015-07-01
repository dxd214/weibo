//
//  WeiboTableViewCell.h
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"

@interface WeiboTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_bgImageView;
    __weak IBOutlet UIButton *_titleButton;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_sourceLabel;
    __weak IBOutlet UIButton *_reposterButton;
    
    __weak IBOutlet UIButton *_zanButton;
    __weak IBOutlet UIButton *_commentButton;
    WeiboView *_weiboView;  //微博内容视图
}
- (IBAction)titleButtonAction:(id)sender;

@property (strong, nonatomic) WeiboModel *model;
@end
