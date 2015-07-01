//
//  RectButton.m
//  MyWeibo
//
//  Created by zsm on 14-3-8.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "RectButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _initViews];
}

- (void)_initViews
{
    //设置按钮圆角
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    //子文本
    _subTitileLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _subTitileLabel.backgroundColor = [UIColor clearColor];
    _subTitileLabel.textColor = [UIColor orangeColor];
    _subTitileLabel.font = [UIFont systemFontOfSize:12];
    _subTitileLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subTitileLabel];
    
    //文本
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blueColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)setSubTitle:(NSString *)subTitle
{
    if (_subTitle != subTitle) {
        _subTitle = [subTitle copy];
        
        _subTitileLabel.text = _subTitle;
        
        //子文本的frame
        _subTitileLabel.frame = CGRectMake(0, 15, self.width, 12);
        //设置文本的frame
        _titleLabel.frame = CGRectMake(0, 32, self.width, 14);
    }
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = [title copy];
        
        _titleLabel.text = _title;
        //设置文本的frame
        if (_subTitle == nil) {
            _titleLabel.frame = CGRectMake(0, (self.height - 14 )/2.0, self.width, 14);
        }

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
