//
//  CommonFileFunc.h
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFileFunc : NSObject

/**************************************************************************
 FunctionName:  getDocumentFilePath
 FunctionDesc:  获取Document全路径
 Parameters:
 Param1Name:    fileName:NSString
 Param1Desc:    文件名
 ReturnVal:     returnType:NSString(返回全路径文件名)
 **************************************************************************/
+ (NSString *)getDocumentFilePath:(NSString *)fileName;

/**************************************************************************
 FunctionName:  getLibraryCachesFilePath
 FunctionDesc:  获取LibraryCaches全路径
 Parameters:
 Param1Name:    fileName:NSString
 Param1Desc:    文件名
 ReturnVal:     returnType:NSString(返回全路径文件名)
 **************************************************************************/
+ (NSString *)getLibraryCachesFilePath:(NSString *)fileName;

/**************************************************************************
 FunctionName:  checkDir
 FunctionDesc:  检测指定路径文件夹是否存在
 Parameters:
 Param1Name:    filepath:NSString
 Param1Desc:    文件夹路径
 ReturnVal:     returnType:BOOL(YES-存在， NO-不存在)
 **************************************************************************/
+ (BOOL)checkDir:(NSString *)filepath;

/**************************************************************************
 FunctionName:  removeFilePath
 FunctionDesc:  删除指定的文件路径
 Parameters:
 Param1Name:    filepath:NSString
 Param1Desc:    文件夹路径
 ReturnVal:     returnType:BOOL(删除文件状态YES-成功， NO-失败)
 **************************************************************************/
+ (BOOL)removeFilePath:(NSString *)filepath;

/**************************************************************************
 FunctionName:  fileSizeForDir
 FunctionDesc:  获取目录中文件大小
 Parameters:
 Param1Name:    path:NSString
 Param1Desc:    文件夹路径
 ReturnVal:     returnType:unsigned long long(返回文件夹中文件大小, 单位byte)
 **************************************************************************/
+ (unsigned long long)fileSizeForDir:(NSString*)path;

/**************************************************************************
 FunctionName:  fileSizeForPath
 FunctionDesc:  获取文件的大小
 Parameters:
 Param1Name:    path:NSString
 Param1Desc:    文件路径
 ReturnVal:     returnType:unsigned long long(返回文件大小, 单位byte)
 **************************************************************************/
+ (unsigned long long)fileSizeForPath:(NSString *)path;

/**************************************************************************
 FunctionName:  fileSizeForPath
 FunctionDesc:  将指定文件数据保存到指定目录
 Parameters:
 Param1Name:    directorPath:NSString
 Param1Desc:    保存文件的目录路径
 Param2Name:    dfileName:NSString
 Param2Desc:    保存文件的文件名
 Param3Name:    data:NSData
 Param3Desc:    保存文件的目录路径
 ReturnVal:     returnType:BOOL (文件保存是否成功)
 **************************************************************************/
+ (BOOL)saveDataToDirector:(NSString *)directorPath fileName:(NSString *)fileName data:(NSData *)data;

/**************************************************************************
 FunctionName:  removeDirectory
 FunctionDesc:  删除指定文件目录
 Parameters:
 Param1Name:    directorPath:NSString
 Param1Desc:    保存文件的目录路径
 ReturnVal:     returnType:BOOL (删除文件目录是否成功)
 **************************************************************************/
+ (BOOL)removeDirectory:(NSString *)directorPath;

@end
