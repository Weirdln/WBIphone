//
//  CommonFormatFunc.h
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>


//typedef enum
//{
//    CULabelAlignmentTop 		= 0,            // UILabel 垂直置顶
//    CULabelAlignmentCenter		= 1,            // UILabel 垂直居中
//    CULabelAlignmentBottom		= 2,            // UILabel 垂直置底
//}CULabelVerticalAlignment;


// RGB颜色方法
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CommonFormatFunc : NSObject
+ (NSString *)FormatDStr:(float)v len:(int)len dig:(int)dig;
+ (char *)itoa:(int)n c:(char *)c;
+ (NSString *)formatDate:(int)date flag:(NSString *)flag;
+ (NSString *)formatDate:(NSString *)dateTime srcFormat:(NSString *)srcFormat destFormat:(NSString *)destFormat;

+ (NSTimeInterval)getCurTick;

// NSDate* ==> numDate(20110930)
+ (int)getNumDate:(NSDate *)date;

// numDate(20110930) ==> NSDate*
+ (NSDate *)getDateFromNumDate:(int)numDate;

// NSDateComponents类型的weekday ==> 中国式星期几
+ (int)getCNWeekDay:(int)dateComponentsWeekDay;

+ (NSDate *)IncDate:(NSDate *)date withDay:(int)day;

// numDate: 20110930
// 返回周一的数字日期
+ (int)getBeginningOfWeekNumDate:(int)numDate;

// numDate(20110930) ==> 20110901
+ (int)getBeginningOfMonthNumDate:(int)numDate;

// numDate: 20110930
// pweekday: 返回星期几，已转化为中国习惯。
// pweek: 一年中第几周
+ (BOOL)getWeekday:(int)numDate pweekday:(int *)pweekday pweek:(int *)pweek;

// 根据生日计算星座
+ (NSString *)getAstroWithMonth:(int)m day:(int)d;

// numDate: 20110930
// pweekday: 返回星期几，已转化为中国习惯。
// pweek: 一年中第几周
+ (BOOL)getMonthday:(int)numDate pday:(int *)pday pmonth:(int *)pmonth;

//获取2个日期间的时间间隔，返回多少秒
+ (NSTimeInterval)getDateFrom:(NSString *)fromDate toDate:(NSString *)toDate;

//根据秒数返回日期的字符串
+ (NSString *)getDataStrWith:(NSTimeInterval)timeNum;
// 返回 hh:ss
+ (NSString *)getDataStrWithMS:(NSTimeInterval)timeNum;

+ (int)getWeekDay:(int)year month:(int)month day:(int)day;
+ (unsigned int)lunarCalendarNum:(int)year month:(int)month day:(int)day;
+ (NSString *)lunarCalendarString:(int)year month:(int)month day:(int)day;
+ (NSString *)lunarCalendarString:(unsigned int)lunarCalendarDay;
+ (NSArray *)lunarCalendarMonthAndDay:(unsigned int)lunarCalendarDay;

// 如果dateStr为2012-02-23，则格式应为yyyy-MM-dd
// 如果dateStr为20120223，则格式应为yyyyMMdd
+ (BOOL)isTodayOfStrDate:(NSString *)dateStr formatStr:(NSString *)formatStr;

// 二进制转换十进制处理
+ (_int64)toDecimalSystemWithBinarySystem:(NSString *)binary;

// 根据数据映射Y轴坐标
+ (float)mappingAsixYValue:(float)max min:(float)min v:(float)v top:(float)top bottom:(float)bottom;
// 根据数据映射X轴坐标
+ (float)mappingAsixXValue:(float)max min:(float)min v:(float)v left:(float)left right:(float)right;
//根据Y的坐标，映射Y对应的值
+ (float)mappingValueByAsixY:(float)max min:(float)min y:(float)y top:(float)top bottom:(float)bottom;
+ (void)setVerticalAlignment:(UILabel *)object alignType:(int)ntype fontSize:(int)fontSize rectSize:(CGSize)rectSize;

//根据输入输出如1，000，000或者1，000，000.00格式的金额字符串
//money 金额
//point 是否需要小数点和后两位
+ (NSString *)getMoneyFormatStringWith:(float)money isNeedPoint:(BOOL)point;

+ (NSArray *)seperateStringByLen:(NSString *)content len:(int)len;

//千位分割符
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString;

+ (NSString *)getNewStrWithSepStr:(NSString *)sepStr recvStr:(NSString *)recvStr;

// 判断整形
+ (BOOL)isPureInt:(NSString *)string;
// 判断浮点型
+ (BOOL)isPureFloat:(NSString *)string;

@end
