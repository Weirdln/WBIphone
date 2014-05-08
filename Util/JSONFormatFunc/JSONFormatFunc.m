//
//  JSONFormatFunc.m
//  Video
//
//  Created by Howard on 13-4-24.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "JSONFormatFunc.h"
#import "JSONKit.h"


@implementation JSONFormatFunc

// 格式化json字段的值
+ (NSString *)formatJsonValue:(id)value
{
	if (value == [NSNull null])
		return @"";
	else if ([value isKindOfClass:[NSString class]])
		return value;
	else if ([value isKindOfClass:[NSNumber class]])
		return [(NSNumber *)value stringValue];
    else if ([value isKindOfClass:[NSArray class]])
		return [(NSArray *)value componentsJoinedByString:@","];
    
	return @"";
}

+ (NSString *)strValueForKey:(id)key ofDict:(NSDictionary *)dict
{
	return [self formatJsonValue:[dict objectForKey:key]];
}

+ (NSNumber *)numberValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    NSNumber *val   = nil;
    id objVal       = [dict objectForKey:key];
    
    if (objVal && objVal != [NSNull null])
    {
        if ([objVal isKindOfClass:[NSNumber class]])
            val = objVal;
        else if ([objVal isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
            val = [f numberFromString:objVal];
        }
    }
    
    return val;
}

+ (NSArray *)arrayValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    id obj = [dict objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]])
        return [NSArray arrayWithArray:obj];
    else
        return nil;
}

+ (NSDictionary *)dictionaryValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    id obj = [dict objectForKey:key];
    
    if ([obj isKindOfClass:[NSDictionary class]])
        return obj;
    else
        return nil;
}

// 把应答数据解析成字典
+ (NSDictionary *)parseToDict:(NSString *)jsonStr
{
	id jsonValue = [jsonStr objectFromJSONString];
	
	if ([jsonValue isKindOfClass:[NSDictionary class]])
		return (NSDictionary *)jsonValue;
	return nil;
}

+ (NSDictionary *)parseDataToDict:(NSData *)jsonData
{
    id jsonValue = [jsonData objectFromJSONData];
	
	if ([jsonValue isKindOfClass:[NSDictionary class]])
		return (NSDictionary *)jsonValue;
	return nil;
}

// 把应答数据解析成列表
+ (NSArray *)parseToArray:(NSString *)jsonStr
{
	id jsonValue = [jsonStr objectFromJSONString];
	
	if ([jsonValue isKindOfClass:[NSArray class]])
		return (NSArray *)jsonValue;
	return nil;
}

+ (NSArray *)parseDataToArray:(NSData *)jsonData
{
    id jsonValue = [jsonData objectFromJSONData];
	
	if ([jsonValue isKindOfClass:[NSArray class]])
		return (NSArray *)jsonValue;
	return nil;
}

+ (id)getJsonValueFromUrl:(NSString *)urlStr error:(NSError **)error
{
	NSURL * url = [NSURL URLWithString:urlStr];
	NSString * jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
	
	if (error != nil && *error != nil) {
		NSLog(@"get url json error: %@", *error);
		return nil;
	}
	
	if (jsonStr == nil)
		return nil;
	
	return [jsonStr objectFromJSONString];
}

+ (id)getJsonValueFromFilePath:(NSString *)filePath error:(NSError **)error
{
	NSString * jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:error];
	
	if (error != nil && *error != nil) {
		NSLog(@"get file json error: %@", *error);
		return nil;
	}
	
	if (jsonStr == nil)
		return nil;
    
	return [jsonStr objectFromJSONString];
}

+ (NSDictionary *)convertDictionary:(id)jsonObj
{
    NSDictionary *retDic = [jsonObj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)jsonObj : nil;
    return retDic;
}

+ (NSArray *)convertArray:(id)jsonObj
{
    NSArray *retArr = [jsonObj isKindOfClass:[NSArray class]] ? (NSArray *)jsonObj : nil;
    return retArr;
}

+ (id)formatJsonStrData:(id)obj
{
//    NSString *strParameter = obj ? [NSString stringWithFormat:@"\"%@\"", obj] : @"\"\"";
    id strParameter = obj ? [NSString stringWithFormat:@"%@", obj] : [NSNull null];
    return strParameter;
}

+ (NSString *)formatJsonStrWithDictionary:(NSDictionary *)dict
{
//    NSLog(@"%@", [dict JSONString]);
    NSString *retVal = [dict JSONString];
//    int index = 0;
//    
//    if (dict)
//    {
//        for (NSString *keys in dict.allKeys)
//        {
//            retVal = [retVal stringByAppendingString:[NSString stringWithFormat:@"\"%@\":%@", keys, [dict objectForKey:keys]]];
//            if (index++ < [dict.allKeys count] - 1)
//                retVal = [retVal stringByAppendingString:@","];
//        }
//        
//        if ([dict.allKeys count] > 0)
//        {
//            retVal = [NSString stringWithFormat:@"{%@}", retVal];
//        }
//    }
    
    return retVal;
}

+ (NSString *)formatJsonStrWithArray:(NSArray *)array
{
    NSString *retVal = [array JSONString];
    return retVal;
}

@end
