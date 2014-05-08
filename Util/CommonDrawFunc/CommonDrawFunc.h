//
//  CommonDrawFunc.h
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDrawFunc : NSObject
+ (CGRect)makeRectByPoint:(CGPoint)pt radius:(CGFloat)radius;


// DRAW LINE
+ (void)drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (void)drawLineInRect:(CGRect)rect colors:(CGFloat[])colors;
+ (void)drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap;
+ (void)drawLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr width:(float)width;
+ (void)drawLine:(CGContextRef)gc pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 clr:(UIColor *)clr width:(float)width;
+ (void)drawLine:(CGContextRef)gc x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 clr:(UIColor *)clr width:(float)width;
+ (void)drawLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr width:(float)width allowsAntialiasing:(BOOL)antialiasing;
+ (void)drawDashLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr width:(float)width dashs:(CGFloat *)dashs dashCount:(int)dashCount;

// 矩形
+ (void)fillRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr;
+ (void)drawRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr;
+ (void)drawRect2:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr width:(CGFloat)width;

// 圆角矩形
+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;
+ (void)fillRoundedRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr radius:(CGFloat)radius;

+ (void)drawGradientRoundedRect:(CGContextRef)context rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius gradientColors:(CGFloat *)gradientColors gradientColorsCount:(int)gradientColorsCount borderColor:(UIColor *)borderColor;
+ (void)drawGradientRect:(CGContextRef)context rect:(CGRect)rect gradientColors:(CGFloat *)gradientColors gradientColorsCount:(int)gradientColorsCount isHorzGradient:(BOOL)isHorzGradient;
+ (void)drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors;
+ (void)drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors;

// 椭圆
+ (void)drawEllipse:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr;
+ (void)fillEllipse:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr;

// 填充一个多边形
+ (void)fillPolygon:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr;
+ (void)fillPolygon:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr clipRect:(CGRect)clipRect;
+ (void)fillGradientPolygon:(CGContextRef)gc rt:(CGRect)rt pts:(CGPoint *)pts count:(int)count colors:(NSArray *)colors;

// 字符串
+ (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
+ (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color isvercenter:(BOOL)isvercenter alignment:(NSTextAlignment)alignment;

+ (UIImage *)getLineImage:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;
+ (UIImage *)imageNamed:(NSString *)name;
+ (UIImage *)retinaImageNamed:(NSString *)name bundle:(NSBundle *)bundle;
+ (UIImage *)retinaImageNamed:(NSString *)name;
+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor bundle:(NSBundle *)bundle;
+ (UIImage *)scaleImage:(UIImage *)image scale:(CGFloat)factor;
+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor;

+ (void)drawImage:(CGContextRef)gc rt:(CGRect)rt imgRef:(CGImageRef)imgRef alpha:(CGFloat)alpha;
+ (void)drawImage:(CGContextRef)gc rt:(CGRect)rt imgRef:(CGImageRef)imgRef alpha:(CGFloat)alpha ratio:(CGFloat)ratio;

@end
