//
//  GifView.m
//  WBIphone
//
//  Created by Weirdln on 13-3-6.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonStyleFunc.h"

@interface GifView ()
{
    CGImageSourceRef gif; // 保存gif动画
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
}

@property (nonatomic, retain) NSDictionary *gifProperties; // 保存gif动画属性
@end

@implementation GifView
@synthesize gifProperties;
@synthesize gifData = _gifData;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMyImageData:(NSData *)data
{
	if (data != nil && [data length] > 0)
	{
		[self setImage:nil];
		
        if ([CommonStyleFunc isGifImage:data])
		{
			[self setGifData:data];
		}
        else
		{
			[self stopGif];
			[self setImage:[UIImage imageWithData:data]];
		}
	}
    else
	{
		[self stopGif];
		[self setImage:nil];
	}
	
}

- (void)setMyImage:(UIImage *)image
{
    [self setImage:image];
}

- (void)setGifData:(NSData *)data
{
    [data retain];
    [_gifData release];
    _gifData = data;
    
    [self stopGif];
    
    if (data)
    {
        NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
        self.gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary];

        if(gif!=NULL)
            CFRelease(gif);
        
        gif = CGImageSourceCreateWithData((CFDataRef)self.gifData, (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

- (void)play
{
    index++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.layer.contents = (id)ref;
    CGImageRelease(ref);
//    CFRelease(ref);
}

- (void)dealloc
{
    if (gif)
    {
        CFRelease(gif);
        gif = NULL;
    }
    [self stopGif];
    self.gifProperties = nil;
    [super dealloc];
}

- (void)stopGif
{
    if ([self.timer isValid])[self.timer invalidate];
    self.timer = nil;
}

@end
