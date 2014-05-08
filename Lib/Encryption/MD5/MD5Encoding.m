//
//  MD5Encoding.m
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-12-16.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "MD5Encoding.h"
#import <CommonCrypto/CommonDigest.h>


@implementation MD5Encoding

+ (void)md5Encoding:(NSString *)source output:(unsigned char *)output
{
    const char *cStr = [source UTF8String];
    CC_MD5(cStr, strlen(cStr), output);
}

@end
