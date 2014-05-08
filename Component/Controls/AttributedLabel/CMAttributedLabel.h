//
//  CMAttributedLabel.h
//  WBIphone
//
//  Created by Weirdln on 14-2-13.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface CMAttributedLabel: UILabel

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

@end
