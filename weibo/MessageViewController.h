//
//  MessageViewController.h
//  weibo
//
//  Created by zsm on 14-11-11.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "MyXMPPManager.h"
@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    MyXMPPManager *_xmmpManager;
}
@end
