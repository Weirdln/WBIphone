//
//  CommonStyleFunc.m
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "CommonStyleFunc.h"

@implementation CommonStyleFunc
+ (UIFont *)getSysFont:(int)size
{
	return [UIFont systemFontOfSize:size];
}
+ (UIFont *)getSysFont:(int)size fontName:(NSString *)fontName
{
    //return [UIFont fontWithName:@"Helvetica-Bold" size:size];
    //return [UIFont fontWithName:@"Helvetica" size:size];  //Gurmukhi  Helvetica
    return [UIFont fontWithName:fontName size:size];
}

+ (UIFont *)getBoldSysFont:(int)size
{
	return [UIFont boldSystemFontOfSize:size];
}

+ (int)getFontHeight:(UIFont *)font
{
	return font.xHeight + font.capHeight;
}

+ (void)setVerticalAlignment:(UILabel *)object alignType:(int)ntype font:(UIFont *)font rectSize:(CGSize)rectSize
{
	CGSize maximumSize	= rectSize;
	CGSize stringSize	= [object.text sizeWithFont:font 
                                constrainedToSize:maximumSize 
                                    lineBreakMode:object.lineBreakMode];
	
	CGRect strFrame = CGRectMake(0, 0, rectSize.width, rectSize.height);
	
	[object setFrame:strFrame];
	
	CGSize fontSZ		= [object.text sizeWithFont:font];
	double finalHeight	= fontSZ.height * object.numberOfLines;
	int newLinesToPad	= (finalHeight  - stringSize.height) / fontSZ.height;
	
	switch (ntype) 
	{
		case CMULabelAlignmentTop:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [object.text stringByAppendingString:@"\n"];
				[pool drain];
			}
			break;
		case CMULabelAlignmentBottom:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [NSString stringWithFormat:@"\n%@",object.text];
				[pool drain];
			}
			break;
		case CMULabelAlignmentCenter:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [NSString stringWithFormat:@"\n%@\n",object.text];
				[pool drain];
			}
			break;
		default:
			break;
	}
}

+ (CGSize)getDspStringSize:(NSString *)str font:(UIFont *)font curFrame:(CGRect)curFrame
{
    CGSize sz = [str sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
    
    CGSize linesSz = [str sizeWithFont:font constrainedToSize:CGSizeMake(curFrame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGPoint lastPoint;
    
    if(sz.width <= linesSz.width) //断定是否折行
    {
        //        lastPoint = CGPointMake(curFrame.origin.x + sz.width, curFrame.origin.y);
    }
    else
    {
        lastPoint = CGPointMake(curFrame.origin.x + (int)sz.width % (int)linesSz.width, linesSz.height - sz.height);
        
        if (linesSz.height+lastPoint.y > curFrame.size.height && (curFrame.size.height -linesSz.height) > 0)
            linesSz.height += curFrame.size.height-linesSz.height;
    }
    
    return linesSz;
}

+ (BOOL)isGifImage:(NSData*)imageData
{
	const char* buf = (const char*)[imageData bytes];
	if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
		return YES;
	}
	return NO;
}

@end
