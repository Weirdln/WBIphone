//
//  WBCommonDefine.h
//  WBIphone
//
//  Created by Weirdln on 14-2-12.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

// height
#define ScreenH  ([[UIScreen mainScreen]bounds].size.height)
#define ScreenW  ([[UIScreen mainScreen]bounds].size.width)


#define kSysStatusBarHeight		MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)		// 系统状态栏高度
#define kSysNavBarHeight        44      //导航栏高度
#define kSysHorzNavBarHeight	32		// 横屏系统导航栏高度
#define PowerUserBit			14


#define wbAppDelegate [UIApplication sharedApplication].delegate


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
     #define IOS_VERSION_7_OR_ABOVE ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#else
     #define IOS_VERSION_7_OR_ABOVE NO
#endif

//是否为iphone 5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否模拟器
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
// 是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)