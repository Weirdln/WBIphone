//
//  ç
//  WBIphone
//
//  Created by Weirdln on 14-2-13.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32
typedef unsigned long _uint64;
typedef long _int64;
#else
typedef unsigned long long _uint64;
typedef long long _int64;
#endif
