//
//  SenderViewController.h
//  weibo
//
//  Created by zsm on 14-11-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "LocViewController.h"
#import "FaceView.h"

@interface SenderViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LocViewControllerDelegate,FaceViewDelegate>
{
    
    __weak IBOutlet UIButton *_weiboCloseButton;
    __weak IBOutlet UIImageView *_weiboImageView;
    __weak IBOutlet UIButton *_locCloseButton;
    __weak IBOutlet UIImageView *_locImageView;
    __weak IBOutlet UILabel *_locLabel;
    UITextView *_textView;
    IBOutlet UIView *_toolsView;
    FaceView *_faceView;    //表情面板
    
    NSDictionary *_locInfo;
    
    BOOL _isTouchFaceView;
}
- (IBAction)locCloseAction:(UIButton *)sender;
- (IBAction)imageCloseAtion:(UIButton *)sender;

@end
