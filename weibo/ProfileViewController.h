//
//  ProfileViewController.h
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@class UserView;
@class UserModel;
@interface ProfileViewController : BaseViewController
{
    __block UserView *_userView;
}
@property(nonatomic,retain)UserModel *userModel;
@property(nonatomic,retain)NSString *screenName;



@end