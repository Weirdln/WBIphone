//
//  CommonUIFunc.h
//  WBIphone
//
//  Created by Weirdln on 14-2-18.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// RGB颜色方法
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.]

#pragma mark - UIView
@interface UIView (Util)

// 设置背景颜色的视图
+ (UIView *)viewForColor:(UIColor *)color WithFrame:(CGRect)frame;

@end

#pragma mark - UIImageView
@interface UIImageView  (Util)

// 根据图片生成view
+ (UIImageView *)imageViewForImage:(UIImage*)image WithFrame:(CGRect)frame;
@end


#pragma mark - UIImage
@interface UIImage  (Util)

// 从bundle获取图片
+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;

// 获取Retina的图片
+ (UIImage *)retinaImageNamed:(NSString *)name bundle:(NSBundle *)bundle;

// 获取拉伸的图片
+ (UIImage *)resizeImageWithName:(NSString *)name bundle:(NSBundle *)bundle;

//  从默认bundle/images加载resize的图片
+ (UIImage *)imageWithName:(NSString *)name;

// 从默认bundle/images加载设置resize的图片
+ (UIImage *)imageWithName:(NSString *)name isResize:(BOOL)resize;

@end

#pragma mark - CATextLayer
@interface CATextLayer  (Util)

@end


#pragma mark - CALayer
@interface CALayer  (Util)

@end


#pragma mark - UILabel
@interface UILabel  (Util)

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor *)backColor;

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor;

+ (UILabel *)labelLeftAlignWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

@end


#pragma mark - UIButton
@interface UIButton  (Util)

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage backColor:(UIColor *)backColor tag:(int)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage tag:(int)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor tag:(int)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action bgImage:(UIImage *)bgImage tag:(int)tag;


@end

#pragma mark - UITextField
@interface UITextField  (Util)

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor bgImage:(UIImage *)bgImage leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;


@end