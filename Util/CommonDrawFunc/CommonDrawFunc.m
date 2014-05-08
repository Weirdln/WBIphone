//
//  CommonDrawFunc.m
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "CommonDrawFunc.h"

@implementation CommonDrawFunc

static CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

static CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

static CGPoint demoRGCenter(CGRect bounds)
{
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

static CGFloat demoRGInnerRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}

#pragma mark - draw graphics
+ (CGRect)makeRectByPoint:(CGPoint)pt radius:(CGFloat)radius
{
	CGFloat halfRadius = radius / 2.0;
	return CGRectMake(pt.x-halfRadius, pt.y-halfRadius, radius, radius);
}

+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors 
{	
	[self drawLineInRect:rect colors:colors width:1 cap:kCGLineCapButt];	
}

+ (void) drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	CGFloat colors[4];
	colors[0] = red;
	colors[1] = green;
	colors[2] = blue;
	colors[3] = alpha;
	[self drawLineInRect:rect colors:colors];
}

+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	CGContextSetLineCap(context,cap);
	CGContextSetLineWidth(context, lineWidth);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context,rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
}

+ (void)drawLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)icount clr:(UIColor *)clr width:(float)width
{
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextSetLineWidth(gc, width);
	CGContextAddLines(gc, pts, icount);
	CGContextStrokePath(gc);
}

+ (void)drawLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr width:(float)width allowsAntialiasing:(BOOL)antialiasing
{
    CGContextSaveGState(gc);
    CGContextSetAllowsAntialiasing(gc, antialiasing);
    CGContextSetStrokeColorWithColor(gc, clr.CGColor);
    CGContextSetLineWidth(gc, width);
    
    CGContextMoveToPoint(gc, pts[0].x, pts[0].y);
    for (int i = 0; i < count-1; i++)
    {
        CGContextAddQuadCurveToPoint(gc, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
    }
    if (count > 1) CGContextAddLineToPoint(gc, pts[count-1].x, pts[count-1].y);
    CGContextStrokePath(gc);
    CGContextSetAllowsAntialiasing(gc, antialiasing);
    CGContextFlush(gc);
    CGContextRestoreGState(gc);
}

+ (void)drawLine:(CGContextRef)gc pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 clr:(UIColor *)clr width:(float)width
{
	CGContextMoveToPoint(gc, pt1.x, pt1.y);
	CGContextAddLineToPoint(gc, pt2.x, pt2.y);
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextSetLineWidth(gc, width);
	CGContextStrokePath(gc);
}

+ (void)drawLine:(CGContextRef)gc x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 clr:(UIColor *)clr width:(float)width
{
	CGContextMoveToPoint(gc, x1, y1);
	CGContextAddLineToPoint(gc, x2, y2);
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextSetLineWidth(gc, width);
	CGContextStrokePath(gc);
}

// CGFloat dash[2] = {2, 3};
+ (void)drawDashLine:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr width:(float)width dashs:(CGFloat *)dashs dashCount:(int)dashCount
{
	CGContextSaveGState(gc);
	CGContextSetLineDash(gc, 0, dashs, dashCount);
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextSetLineWidth(gc, width);
	CGContextAddLines(gc, pts, count);
	CGContextStrokePath(gc);
	CGContextRestoreGState(gc);
}

+ (void)fillRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr
{
	CGContextSetFillColorWithColor(gc, clr.CGColor);
	CGContextFillRect(gc, rt);
}

+ (void)drawRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr
{
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextStrokeRectWithWidth(gc, rt, 1.0);
}

+ (void)drawRect2:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr width:(CGFloat)width
{
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextStrokeRectWithWidth(gc, rt, width);
}

+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color set];
	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}

+ (void)fillRoundedRect:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr radius:(CGFloat)radius
{
    if (gc != nil)
    {
        CGFloat minx = CGRectGetMinX(rt), midx = CGRectGetMidX(rt), maxx = CGRectGetMaxX(rt);
		CGFloat miny = CGRectGetMinY(rt), midy = CGRectGetMidY(rt), maxy = CGRectGetMaxY(rt);
		
		CGContextSetFillColorWithColor(gc, clr.CGColor);
		CGContextSetLineWidth(gc, 1);
		CGContextMoveToPoint(gc, minx, midy);
		CGContextAddArcToPoint(gc, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(gc, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(gc, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(gc, minx, maxy, minx, midy, radius);
		CGContextClosePath(gc);
        //		CGContextDrawPath(gc, kCGPathFillStroke);
        CGContextFillPath(gc);
    }
}

// type: 1=正常，２=渐变色的白色浅些，用于画K线图和分时图背景
+ (void) drawGradientRoundedRect:(CGContextRef)context rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius gradientColors:(CGFloat *)gradientColors gradientColorsCount:(int)gradientColorsCount borderColor:(UIColor *)borderColor
{
	CGFloat rectX = rect.origin.x;
	CGFloat rectY = rect.origin.y;
    CGFloat rectW = rect.size.width;
	CGFloat rectH = rect.size.height;
	
	CGRect imageBounds = CGRectMake(0.0, 0.0, rectW - 0.5, rectH);
    
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, gradientColors, NULL, gradientColorsCount/4);
	CGColorSpaceRelease(rgb);
	
	CGPoint point2;
    
	CGFloat resolution = 0.5 * (rectW / imageBounds.size.width + rectH / imageBounds.size.height);
	
	CGFloat stroke = 1.0 * resolution;
	if (stroke < 1.0)
		stroke = ceil(stroke);
	else
		stroke = round(stroke);
	stroke /= resolution;
	CGFloat alignStroke = fmod(0.5 * stroke * resolution, 1.0);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPoint point = CGPointMake((rectW - cornerRadius), rectH - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(rectW - 0.5f, (rectH - cornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPoint controlPoint1 = CGPointMake((rectW - (cornerRadius / 2.f)), rectH - 0.5f);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint1.x += rectX;  controlPoint1.y += rectY;
	CGPoint controlPoint2 = CGPointMake(rectW - 0.5f, (rectH - (cornerRadius / 2.f)));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	controlPoint2.x += rectX;  controlPoint2.y += rectY;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(rectW - 0.5f, cornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake((rectW - cornerRadius), 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	controlPoint1 = CGPointMake(rectW - 0.5f, (cornerRadius / 2.f));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint1.x += rectX;  controlPoint1.y += rectY;
	controlPoint2 = CGPointMake((rectW - (cornerRadius / 2.f)), 0.0);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	controlPoint2.x += rectX;  controlPoint2.y += rectY;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(cornerRadius, 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.0, cornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	controlPoint1 = CGPointMake((cornerRadius / 2.f), 0.0);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint1.x += rectX;  controlPoint1.y += rectY;
	controlPoint2 = CGPointMake(0.0, (cornerRadius / 2.f));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	controlPoint2.x += rectX;  controlPoint2.y += rectY;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.0, (rectH - cornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(cornerRadius, rectH - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	controlPoint1 = CGPointMake(0.0, (rectH - (cornerRadius / 2.f)));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint1.x += rectX;  controlPoint1.y += rectY;
	controlPoint2 = CGPointMake((cornerRadius / 2.f), rectH - 0.5f);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	controlPoint2.x += rectX;  controlPoint2.y += rectY;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake((rectW - cornerRadius), rectH - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	point.x += rectX;  point.y += rectY;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
	
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake((rectW / 2.0), rectH - 0.5f);
	point2 = CGPointMake((rectW / 2.0), 0.0);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
    
	if (borderColor) {
		[borderColor setStroke];
		CGContextSetLineWidth(context, stroke);
		CGContextSetLineCap(context, kCGLineCapSquare);
		CGContextAddPath(context, path);
		CGContextStrokePath(context);
 	}
	CGPathRelease(path);
}

/*
 int gradientColorsCount = 2;
 CGFloat gradientColors[] =
 {
 193.0 / 255.0, 211.0 / 255.0, 225.0 / 255.0, 1,
 153.0 / 255.0, 183.0 / 255.0, 207.0 / 255.0, 1
 };
 isHorzGradient: 是否横向渐变
 */
+ (void)drawGradientRect:(CGContextRef)context rect:(CGRect)rect gradientColors:(CGFloat *)gradientColors gradientColorsCount:(int)gradientColorsCount isHorzGradient:(BOOL)isHorzGradient
{
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, gradientColors, NULL, gradientColorsCount);
	
	CGPoint pt1 = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint pt2 = isHorzGradient ? CGPointMake(CGRectGetMaxX(rect), rect.origin.y) : CGPointMake(rect.origin.x, CGRectGetMaxY(rect));
	CGContextDrawLinearGradient(context, gradient, pt1, pt2, 0);	//(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	
	CGColorSpaceRelease(rgb);
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
}

+ (void)drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
	
	NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors){
		[ar addObject:(id)c.CGColor];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);	
    
	CGContextClipToRect(context, rect);
	
	CGPoint start = CGPointMake(0.0, 0.0);
	CGPoint end = CGPointMake(0.0, rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
}

+ (void)drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	CGPoint start, end;
	
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
}

+ (void)drawEllipse:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr
{
	CGContextSetStrokeColorWithColor(gc, clr.CGColor);
	CGContextSetLineWidth(gc, 1);
	CGContextAddEllipseInRect(gc, rt);
	CGContextStrokePath(gc);
}

+ (void)fillEllipse:(CGContextRef)gc rt:(CGRect)rt clr:(UIColor *)clr
{
    CGContextSaveGState(gc);
    CGContextSetFillColorWithColor(gc, clr.CGColor);
    CGContextFillEllipseInRect(gc, rt);
    CGContextRestoreGState(gc);
}

+ (void)fillPolygon:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr
{
	CGContextSaveGState(gc);
	CGContextBeginPath(gc);
	CGContextAddLines(gc, pts, count);
	CGContextClosePath(gc);
	CGContextSetFillColorWithColor(gc, clr.CGColor);
	CGContextFillPath(gc);
	CGContextRestoreGState(gc);
}

+ (void)fillPolygon:(CGContextRef)gc pts:(CGPoint *)pts count:(int)count clr:(UIColor *)clr clipRect:(CGRect)clipRect
{
	CGContextSaveGState(gc);
	CGContextClipToRect(gc, clipRect);
	CGContextBeginPath(gc);
	CGContextAddLines(gc, pts, count);
	CGContextClosePath(gc);
	CGContextSetFillColorWithColor(gc, clr.CGColor);
	CGContextFillPath(gc);
	CGContextRestoreGState(gc);
}

+ (void)fillGradientPolygon:(CGContextRef)gc rt:(CGRect)rt pts:(CGPoint *)pts count:(int)count colors:(NSArray *)colors
{
    NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors){
		[ar addObject:(id)c.CGColor];
	}
    
	CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
	CGPoint start	= CGPointMake(rt.origin.x, rt.origin.y);
	CGPoint end		= CGPointMake(rt.origin.x, rt.origin.y + rt.size.height);
	
	CGContextSaveGState(gc);
	CGContextBeginPath(gc);
	CGContextMoveToPoint(gc, pts[0].x, rt.origin.y + rt.size.height);
	CGContextAddLineToPoint(gc, pts[0].x, pts[1].y);
	
	for (int i = 0; i < count-1; i++)
	{
		CGContextAddQuadCurveToPoint(gc, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
	}
	
	CGContextAddLineToPoint(gc, pts[count-1].x, pts[count-1].y);
	CGContextAddLineToPoint(gc, pts[count-1].x, rt.origin.y + rt.size.height);
	CGContextAddLineToPoint(gc, pts[0].x, rt.origin.y + rt.size.height);
    
	CGContextClosePath(gc);
	CGContextClip(gc);
	CGColorSpaceRef rgb		= CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);	
    CGColorSpaceRelease(rgb);
	CGContextDrawLinearGradient(gc, gradient, start, end, options);
	CGGradientRelease(gradient);
	CGContextRestoreGState(gc);
}

#pragma mark - draw string
// lineBreakMode:(UILineBreakMode)lineBreakMode 
+ (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
	[color set];
	[str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:alignment];
}

+ (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color isvercenter:(BOOL)isvercenter alignment:(NSTextAlignment)alignment
{
    CGRect curRt = isvercenter ? CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - (font.xHeight+font.capHeight)) * 0.5, rect.size.width, font.xHeight+font.capHeight) : rect;
    [color set];
    [str drawInRect:curRt withFont:font lineBreakMode:NSLineBreakByClipping alignment:alignment];
}

#pragma mark - Image
+ (UIImage *)getLineImage:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
	CGSize size = CGSizeMake(lineWidth, 1);
    UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawLine:context x1:0 y1:0 x2:lineWidth y2:0 clr:lineColor width:1];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return resultingImage;
}

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[bundle bundlePath], name]];
}

+ (UIImage *)imageNamed:(NSString *)name 
{
	return [self imageNamed:name bundle:[NSBundle mainBundle]];
}

+ (UIImage *)retinaImageNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    UIImage *img        = [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:nil]];
    CGImageRef cgimage  = img.CGImage;
    img                 = [UIImage imageWithCGImage:cgimage scale:2.0 orientation:UIImageOrientationUp];
    
    return img;
}

+ (UIImage *)retinaImageNamed:(NSString *)name
{
    return [self retinaImageNamed:name bundle:[NSBundle mainBundle]];
}

+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor bundle:(NSBundle *)bundle
{
    UIImage *img        = [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:nil]];
    CGImageRef cgimage  = img.CGImage;
    img                 = [UIImage imageWithCGImage:cgimage scale:factor orientation:UIImageOrientationUp];
    
    return img;
}

+ (UIImage *)scaleImage:(UIImage *)image scale:(CGFloat)factor
{
    UIImage *img = [UIImage imageWithCGImage:image.CGImage scale:factor orientation:UIImageOrientationUp];
    return img;
}

+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor
{
    return [self scaleImageNamed:name scale:factor bundle:[NSBundle mainBundle]];
}

+ (void)drawImage:(CGContextRef)gc rt:(CGRect)rt imgRef:(CGImageRef)imgRef alpha:(CGFloat)alpha
{
    CGContextSaveGState(gc);
    CGContextTranslateCTM(gc, 0, rt.size.height);
    CGContextScaleCTM(gc, 1.0, -1.0);
    CGContextDrawImage(gc, rt, imgRef);
    CGContextSetGrayFillColor(gc, 0.0, alpha);
    CGContextRestoreGState(gc);
}

+ (void)drawImage:(CGContextRef)gc rt:(CGRect)rt imgRef:(CGImageRef)imgRef alpha:(CGFloat)alpha ratio:(CGFloat)ratio
{
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:ratio orientation:UIImageOrientationUp];
    CGContextSaveGState(gc);
    CGContextTranslateCTM(gc, 0, rt.size.height);
    CGContextScaleCTM(gc, 1.0, -1.0);
    CGContextDrawImage(gc, rt, img.CGImage);
    CGContextSetGrayFillColor(gc, 0.0, alpha);
    CGContextRestoreGState(gc);
}
@end
