//
//  FriendShipView.h
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface FriendShipView : UIView
{
    IBOutlet UIImageView *_userImageView;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_fsCountLabel;
    
    
}
@property (nonatomic,retain)UserModel *model;
@end
