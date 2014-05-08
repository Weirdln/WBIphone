//
//  GifView.h
//  WBIphone
//
//  Created by Weirdln on 13-3-6.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Util.h"

@interface GifView : UIImageView
@property (nonatomic, retain) NSTimer *timer;   // 播放gif动画所使用的timer
@property (nonatomic, retain, setter = setGifData:) NSData *gifData;

- (void)stopGif;
- (void)setMyImageData:(NSData *)data;
- (void)setMyImage:(UIImage *)image;
@end
