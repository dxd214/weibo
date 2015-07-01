//
//  DrawFaceView.h
//  weibo
//
//  Created by zsm on 14-11-24.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
@interface DrawFaceView : UIView
{
    UIImageView *_zoomImageView; // 放大镜视图
}
@property (nonatomic, strong) NSArray *array2d;
@property (nonatomic, weak) id<FaceViewDelegate> delegate;
@end
