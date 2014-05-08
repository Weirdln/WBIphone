//
//  SystemInfoFunc.h
//  iPhoneNewVersion
//
//  Created by Howard on 13-6-14.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMemTotal   @"memTotal"
#define kMemUsed    @"MemUsed"
#define kMemFreed   @"MemFreed"
#define kMemUsage   @"MemUsage"

#define kSendByWIFI @"sendByWIFI"
#define kRecvByWIFI @"recvByWIFI"
#define kSendByWWAN @"sendByWWAN"
#define kRecvByWWAN @"recvByWWAN"


@interface SystemInfoFunc : NSObject
/**************************************************************************
 FunctionName:  deviceName
 FunctionDesc:  获取设备名称
 Parameters:    NONE
 ReturnVal:     返回设备名称(如iPhone1,1 iPhone1,2 iPod1,1 i386 等)
 **************************************************************************/
+ (NSString *)deviceName;

/**************************************************************************
 FunctionName:  systemName
 FunctionDesc:  获取系统名称
 Parameters:    NONE
 ReturnVal:     返回系统名称(e.g. @"iOS")
 **************************************************************************/
+ (NSString *)systemName;

/**************************************************************************
 FunctionName:  systemVersion
 FunctionDesc:  获取系统版本号
 Parameters:    NONE
 ReturnVal:     返回系统版本号(e.g. @"4.0)
 **************************************************************************/
+ (NSString *)systemVersion;

/**************************************************************************
 FunctionName:  systemVersionWithBuildingNo
 FunctionDesc:  获取带有build标记的系统版本号
 Parameters:    NONE
 ReturnVal:     返回build标记的系统版本号(e.g. @"version 6.13 (build2367)")
 **************************************************************************/
+ (NSString *)systemVersionWithBuildingNo;

/**************************************************************************
 FunctionName:  deviceDescription
 FunctionDesc:  获取设备标记名称
 Parameters:    NONE
 ReturnVal:     返回设备标记名称(e.g. "My iPhone")
 **************************************************************************/
+ (NSString *)deviceDescription;

/**************************************************************************
 FunctionName:  batteryState
 FunctionDesc:  获取电池状态相关信息
 Parameters:    NONE
 ReturnVal:     返回电池状态相关信息
 **************************************************************************/
+ (UIDeviceBatteryState)batteryState;

/**************************************************************************
 FunctionName:  batteryLevel
 FunctionDesc:  获取电池电量
 Parameters:    NONE
 ReturnVal:     返回电池电量
 **************************************************************************/
+ (float)batteryLevel;

/**************************************************************************
 FunctionName:  model
 FunctionDesc:  获取设备类型
 Parameters:    NONE
 ReturnVal:     返回设备类型
 **************************************************************************/
+ (NSString *)model;

/**************************************************************************
 FunctionName:  localizedModel
 FunctionDesc:  获取设备类型
 Parameters:    NONE
 ReturnVal:     返回设备类型
 **************************************************************************/
+ (NSString *)localizedModel;

/**************************************************************************
 FunctionName:  macAddress
 FunctionDesc:  获取设备MAC地址信息
 Parameters:    NONE
 ReturnVal:     返回设备MAC地址信息
 **************************************************************************/
+ (NSString *)macAddress;

/**************************************************************************
 FunctionName:  physicalMemory
 FunctionDesc:  获取设备物理内存大小
 Parameters:    NONE
 ReturnVal:     返回设备物理内存大小
 **************************************************************************/
+ (double)physicalMemory;

/**************************************************************************
 FunctionName:  globallyUniqueStringForProcess
 FunctionDesc:  获取当前app进程动态标识
 Parameters:    NONE
 ReturnVal:     返回当前app进程动态标识
 **************************************************************************/
+ (NSString *)globallyUniqueStringForProcess;

/**************************************************************************
 FunctionName:  processName
 FunctionDesc:  获取当前app进程名称
 Parameters:    NONE
 ReturnVal:     返回当前app进程名称
 **************************************************************************/
+ (NSString *)processName;

/**************************************************************************
 FunctionName:  bundleName
 FunctionDesc:  获取bundle标识
 Parameters:    NONE
 ReturnVal:     返回bundle标识
 **************************************************************************/
+ (NSString *)bundleName;

/**************************************************************************
 FunctionName:  appName
 FunctionDesc:  获取app显示名称
 Parameters:    NONE
 ReturnVal:     返回app显示名称
 **************************************************************************/
+ (NSString *)appName;

/**************************************************************************
 FunctionName:  developmentVersionNumber
 FunctionDesc:  获取开发版本号(带BuildNo)
 Parameters:    NONE
 ReturnVal:     返回设备类型
 **************************************************************************/
+ (NSString *)developmentVersionNumber;

/**************************************************************************
 FunctionName:  marketingVersionNumber
 FunctionDesc:  获取发布版本号码
 Parameters:    NONE
 ReturnVal:     返回发布版本号码
 **************************************************************************/
+ (NSString *)marketingVersionNumber;

/**************************************************************************
 FunctionName:  cpuStatus
 FunctionDesc:  获取CPU使用率
 Parameters:    NONE
 ReturnVal:     返回CPU使用率
 **************************************************************************/
+ (float)cpuStatus;

/**************************************************************************
 FunctionName:  memoryStatus
 FunctionDesc:  获取内存使用状态信息
 Parameters:    NONE
 ReturnVal:     返回内存使用状态信息:NSDictionary=>{NSNumber(NSUInteger):kMemTotal, NSNumber(NSUInteger):kMemUsed, NSNumber(NSUInteger):kMemFreed, NSNumber(float):kMemUsage}
 **************************************************************************/
+ (NSDictionary *)memoryStatus;

/**************************************************************************
 FunctionName:  networkUsageStatus
 FunctionDesc:  获取网络流量使用状态信息
 Parameters:    NONE
 ReturnVal:     返回网络流量使用状态信息:NSDictionary=>{NSString:kSendByWIFI, NSString:kRecvByWIFI, NSString:kSendByWWAN, NSString:kRecvByWWAN}
 **************************************************************************/
+ (NSDictionary *)networkUsageStatus;

@end
