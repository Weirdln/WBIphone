//
//  CommonStyleFunc.h
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  _CMUILabelVerticalAlignment
{
    CMULabelAlignmentTop 		= 0,            // UILabel 垂直置顶
    CMULabelAlignmentCenter		= 1,            // UILabel 垂直居中
    CMULabelAlignmentBottom		= 2,            // UILabel 垂直置底
}CMULabelVerticalAlignment;

@interface CommonStyleFunc : NSObject
+ (UIFont *)getSysFont:(int)size;
+ (UIFont *)getSysFont:(int)size fontName:(NSString *)fontName;
+ (UIFont *)getBoldSysFont:(int)size;
+ (int)getFontHeight:(UIFont *)font;
+ (void)setVerticalAlignment:(UILabel *)object alignType:(int)ntype font:(UIFont *)font rectSize:(CGSize)rectSize;
+ (CGSize)getDspStringSize:(NSString *)str font:(UIFont *)font curFrame:(CGRect)curFrame;
+ (BOOL)isGifImage:(NSData*)imageData;

@end
