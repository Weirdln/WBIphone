//
//  MD5Encoding.h
//  DZHLotteryTicket
//
//  Created by Weirdln on 13-12-16.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Encoding : NSObject

+ (void)md5Encoding:(NSString *)source output:(unsigned char *)output;

@end
