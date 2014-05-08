//
//  CMTextField.m
//  WBIphone
//
//  Created by Weirdln on 14-2-13.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import "CMTextField.h"

@implementation CMTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

// 控制text的位置
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self newFrame:bounds];
}

// 控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self newFrame:bounds];
}

// 控制editingRect
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self newFrame:bounds];
}

- (CGRect)newFrame:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.leftOffset, bounds.origin.y, bounds.size.width - self.leftOffset - self.rightOffset, bounds.size.height);
}
@end

