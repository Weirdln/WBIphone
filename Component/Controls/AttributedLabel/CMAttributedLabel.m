//
//  CMAttributedLabel.m
//  WBIphone
//
//  Created by Weirdln on 14-2-13.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import "CMAttributedLabel.h"



@interface CMAttributedLabel()
{
    
}
@property (nonatomic,retain)NSMutableAttributedString          *attString;


@end

@implementation CMAttributedLabel
@synthesize attString = _attString;





- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    
    CTFontRef ctfont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)ctfont
                       range:NSMakeRange(location, length)];
    
    CFRelease(ctfont);
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}






- (void)drawRect:(CGRect)rect{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.string = _attString;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:textLayer];
}



- (void)dealloc{
    self.attString = nil;
    [super dealloc];
}
@end

