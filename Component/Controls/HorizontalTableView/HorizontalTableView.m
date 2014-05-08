//
//  HorizontalTableView.m
//  iPhoneNewVersion
//
//  Created by Howard on 13-7-11.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "HorizontalTableView.h"
#import <QuartzCore/QuartzCore.h>


@implementation HorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
        [self setTransform:CGAffineTransformMakeRotation(M_PI/-2)];
        [self setShowsVerticalScrollIndicator:NO];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
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

@end
