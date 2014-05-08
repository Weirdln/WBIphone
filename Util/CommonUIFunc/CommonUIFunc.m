//
//  CommonUIFunc.m
//  WBIphone
//
//  Created by Weirdln on 14-2-18.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import "CommonUIFunc.h"


#pragma mark - UIView
@implementation UIView (Util)

// 设置背景颜色的视图
+ (UIView *)viewForColor:(UIColor *)color WithFrame:(CGRect)frame
{
    UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];
    view.backgroundColor = color;
    return view;
}

@end

#pragma mark - UIImageView
@implementation UIImageView  (Util)

// 根据图片生成view
+ (UIImageView *)imageViewForImage:(UIImage*)image WithFrame:(CGRect)frame;
{
    UIImageView *imageView=[[[UIImageView alloc] initWithFrame:frame] autorelease];
    imageView.userInteractionEnabled = YES;
    imageView.image=image;
    return imageView;
}

@end

#pragma mark - UIImage
@implementation UIImage  (Util)

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[bundle bundlePath], name]];
}

+ (UIImage *)retinaImageNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    UIImage *img        = [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:nil]];
    CGImageRef cgimage  = img.CGImage;
    img                 = [UIImage imageWithCGImage:cgimage scale:2.0 orientation:UIImageOrientationUp];
    
    return img;
}

+ (UIImage *)resizeImageWithName:(NSString *)name bundle:(NSBundle *)bundle
{
    UIImage *image=[[self class] retinaImageNamed:name bundle:bundle];//获取图片
    if(image)
    {
        CGSize size=image.size;
        CGFloat x=ceilf(size.width*.5);
        CGFloat y=ceilf(size.height*.5);
        if([image respondsToSelector:@selector(resizableImageWithCapInsets:)])
            image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y, x)];
        else
            image=[image stretchableImageWithLeftCapWidth:x topCapHeight:y];
    }
    return image;
}

+ (UIImage *)imageWithName:(NSString *)name
{
    return [[self class] imageWithName:name isResize:YES];
}

+ (UIImage *)imageWithName:(NSString *)name isResize:(BOOL)resize
{
    if(resize)
        return [[self class] resizeImageWithName:name bundle:[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/CommonResource.bundle/images", [[NSBundle mainBundle] resourcePath]]]];
    else
        return [[self class] retinaImageNamed:name bundle:[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/CommonResource.bundle/images", [[NSBundle mainBundle] resourcePath]]]];
}


@end

#pragma mark - CATextLayer
@implementation CATextLayer  (Util)

@end


#pragma mark - CALayer
@implementation CALayer  (Util)

@end


#pragma mark - UILabel
@implementation UILabel  (Util)

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor*)backColor textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text=text;
    label.textAlignment=textAlignment;
    if(backColor)
        label.backgroundColor=backColor;
    if(font)
        label.font=font;
    if(textColor)
        label.textColor=textColor;
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor*)backColor
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:backColor textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:textAlignment];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:nil backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}


+ (UILabel *)labelLeftAlignWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
}

@end


#pragma mark - UIButton
@implementation UIButton  (Util)

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage backColor:(UIColor *)backColor tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (font)
        button.titleLabel.font = font;

    if (titleColor)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (bgImage)
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];

    if(backColor)
        [button setBackgroundColor:backColor];
    
    [button setTag:tag];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage tag:(int)tag
{
    return [[self class]buttonWithFrame:frame target:target action:action title:title font:font titleColor:titleColor bgImage:bgImage backColor:[UIColor clearColor] tag:tag];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor tag:(int)tag
{
    return [[self class]buttonWithFrame:frame target:target action:action title:title font:font titleColor:titleColor bgImage:nil backColor:backColor tag:tag];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action bgImage:(UIImage *)bgImage tag:(int)tag
{
    return [[self class]buttonWithFrame:frame target:target action:action title:nil font:nil titleColor:nil bgImage:bgImage  backColor:[UIColor clearColor] tag:tag];
}


@end

#pragma mark - UITextField
#import "CMTextField.h"
@implementation UITextField  (Util)
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor bgImage:(UIImage *)bgImage leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset
{
    
    CMTextField *textField = [[[CMTextField alloc] initWithFrame:frame] autorelease];
    textField.placeholder = placeholder;
    if (font)
        textField.font = font;
    
    if (textColor)
        textField.textColor = textColor;
    
    if (bgImage)
        [textField setBackground:bgImage];
    
    textField.leftOffset = leftOffset;
    textField.rightOffset = rightOffset;
    
    return textField;
}

@end