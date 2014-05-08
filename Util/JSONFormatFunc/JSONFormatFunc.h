//
//  JSONFormatFunc.h
//  Video
//
//  Created by Howard on 13-4-24.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONFormatFunc : NSObject
// 格式化json字段的值
+ (NSString *)formatJsonValue:(id)value;
+ (NSString *)strValueForKey:(id)key ofDict:(NSDictionary *)dict;
+ (NSNumber *)numberValueForKey:(id)key ofDict:(NSDictionary *)dict;
+ (NSArray *)arrayValueForKey:(id)key ofDict:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryValueForKey:(id)key ofDict:(NSDictionary *)dict;

// 把应答数据解析成字典
+ (NSDictionary *)parseToDict:(NSString *)jsonStr;
+ (NSDictionary *)parseDataToDict:(NSData *)jsonData;
// 把应答数据解析成列表
+ (NSArray *)parseToArray:(NSString *)jsonStr;
+ (NSArray *)parseDataToArray:(NSData *)jsonData;

// 解析json为对象
+ (id)getJsonValueFromUrl:(NSString *)urlStr error:(NSError **)error;
+ (id)getJsonValueFromFilePath:(NSString *)filePath error:(NSError **)error;

+ (NSDictionary *)convertDictionary:(id)jsonObj;
+ (NSArray *)convertArray:(id)jsonObj;
+ (id)formatJsonStrData:(id)obj;
+ (NSString *)formatJsonStrWithDictionary:(NSDictionary *)dict;
+ (NSString *)formatJsonStrWithArray:(NSArray *)array;

@end
