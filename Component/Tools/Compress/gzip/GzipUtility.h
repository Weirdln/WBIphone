//
//  GzipUtility.h
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-11-13.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zlib.h>


@interface GzipUtility : NSObject

+ (NSData*) gzipData:(NSData*)pUncompressedData;  //压缩
+ (NSData*) ungzipData:(NSData *)compressedData;  //解压缩

@end
