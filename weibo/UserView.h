//
//  UserView.h
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@class RectButton;
@interface UserView : UIView
{
    IBOutlet UIImageView *_bgImageView;
    IBOutlet UILabel *_addressLabel;
    IBOutlet RectButton *_gzButton;
    IBOutlet RectButton *_fsButton;
    
    IBOutlet RectButton *_gdButton;
    IBOutlet RectButton *_zlButton;
    IBOutlet UILabel *_contentLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_userImageView;
}
@property(nonatomic,retain)UserModel *model;
@end
