//
//  WBUnderlineButton.m
//  WBIphone
//
//  Created by Weirdln on 14-2-13.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import "WBUnderlineButton.h"

@implementation WBUnderlineButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 有阴影的情况
    CGFloat shadowHeight = self.titleLabel.shadowOffset.height;
    descender += shadowHeight;
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    
}
@end
