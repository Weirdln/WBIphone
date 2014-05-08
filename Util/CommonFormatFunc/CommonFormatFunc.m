//
//  CommonFormatFunc.m
//  BankFinancing
//
//  Created by Weirdln on 13-1-15.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "CommonFormatFunc.h"

typedef enum
{
    CULabelAlignmentTop 		= 0,            // UILabel 垂直置顶
    CULabelAlignmentCenter		= 1,            // UILabel 垂直居中
    CULabelAlignmentBottom		= 2,            // UILabel 垂直置底
}CULabelVerticalAlignment;



unsigned int LunarCalendarTable[199] = {

    0x04AE53,0x0A5748,0x5526BD,0x0D2650,0x0D9544,0x46AAB9,0x056A4D,0x09AD42,0x24AEB6,0x04AE4A,/*1901-1910*/

    0x6A4DBE,0x0A4D52,0x0D2546,0x5D52BA,0x0B544E,0x0D6A43,0x296D37,0x095B4B,0x749BC1,0x049754,/*1911-1920*/

    0x0A4B48,0x5B25BC,0x06A550,0x06D445,0x4ADAB8,0x02B64D,0x095742,0x2497B7,0x04974A,0x664B3E,/*1921-1930*/

    0x0D4A51,0x0EA546,0x56D4BA,0x05AD4E,0x02B644,0x393738,0x092E4B,0x7C96BF,0x0C9553,0x0D4A48,/*1931-1940*/

    0x6DA53B,0x0B554F,0x056A45,0x4AADB9,0x025D4D,0x092D42,0x2C95B6,0x0A954A,0x7B4ABD,0x06CA51,/*1941-1950*/

    0x0B5546,0x555ABB,0x04DA4E,0x0A5B43,0x352BB8,0x052B4C,0x8A953F,0x0E9552,0x06AA48,0x6AD53C,/*1951-1960*/

    0x0AB54F,0x04B645,0x4A5739,0x0A574D,0x052642,0x3E9335,0x0D9549,0x75AABE,0x056A51,0x096D46,/*1961-1970*/

    0x54AEBB,0x04AD4F,0x0A4D43,0x4D26B7,0x0D254B,0x8D52BF,0x0B5452,0x0B6A47,0x696D3C,0x095B50,/*1971-1980*/

    0x049B45,0x4A4BB9,0x0A4B4D,0xAB25C2,0x06A554,0x06D449,0x6ADA3D,0x0AB651,0x093746,0x5497BB,/*1981-1990*/

    0x04974F,0x064B44,0x36A537,0x0EA54A,0x86B2BF,0x05AC53,0x0AB647,0x5936BC,0x092E50,0x0C9645,/*1991-2000*/

    0x4D4AB8,0x0D4A4C,0x0DA541,0x25AAB6,0x056A49,0x7AADBD,0x025D52,0x092D47,0x5C95BA,0x0A954E,/*2001-2010*/

    0x0B4A43,0x4B5537,0x0AD54A,0x955ABF,0x04BA53,0x0A5B48,0x652BBC,0x052B50,0x0A9345,0x474AB9,/*2011-2020*/

    0x06AA4C,0x0AD541,0x24DAB6,0x04B64A,0x69573D,0x0A4E51,0x0D2646,0x5E933A,0x0D534D,0x05AA43,/*2021-2030*/

    0x36B537,0x096D4B,0xB4AEBF,0x04AD53,0x0A4D48,0x6D25BC,0x0D254F,0x0D5244,0x5DAA38,0x0B5A4C,/*2031-2040*/

    0x056D41,0x24ADB6,0x049B4A,0x7A4BBE,0x0A4B51,0x0AA546,0x5B52BA,0x06D24E,0x0ADA42,0x355B37,/*2041-2050*/

    0x09374B,0x8497C1,0x049753,0x064B48,0x66A53C,0x0EA54F,0x06B244,0x4AB638,0x0AAE4C,0x092E42,/*2051-2060*/

    0x3C9735,0x0C9649,0x7D4ABD,0x0D4A51,0x0DA545,0x55AABA,0x056A4E,0x0A6D43,0x452EB7,0x052D4B,/*2061-2070*/

    0x8A95BF,0x0A9553,0x0B4A47,0x6B553B,0x0AD54F,0x055A45,0x4A5D38,0x0A5B4C,0x052B42,0x3A93B6,/*2071-2080*/

    0x069349,0x7729BD,0x06AA51,0x0AD546,0x54DABA,0x04B64E,0x0A5743,0x452738,0x0D264A,0x8E933E,/*2081-2090*/

    0x0D5252,0x0DAA47,0x66B53B,0x056D4F,0x04AE45,0x4A4EB9,0x0A4D4C,0x0D1541,0x2D92B5          /*2091-2099*/
    
};

@implementation CommonFormatFunc

+ (NSString *)FormatDStr:(float)v len:(int)len dig:(int)dig
{
    int ln, rn;
	char floatstr[64];
	char temp[2];
	char formatStr[10];
	char formatStr2[10] = {'%'};
	NSString * vv;
	
	if (v == 0)
	{
		return @"--";
	}
	
	[CommonFormatFunc itoa:dig c:temp];
	sprintf(formatStr, ".%sf", temp);
	strcat(formatStr2, formatStr);
	sprintf(floatstr, formatStr2, v);
	
	vv = [NSString stringWithUTF8String:floatstr];
	NSMutableString *leftstr = [[NSMutableString alloc] init];
	NSString *rightstr;
	
	NSRange rang =  [vv rangeOfString:@"."];
	ln = rang.location;
	rn = [vv length] - ln - 1;
	
	if (rang.location != NSNotFound)
	{
		NSRange subrang;
		
		subrang.location = 0;
		subrang.length = MAX(ln, 0);
		[leftstr appendString:[vv substringWithRange:subrang]];
		subrang.location = ln + 1;
		subrang.length = MAX(rn, 0);
		rightstr = [vv substringWithRange:subrang];
		int over = [vv length] - len;
		
		if (over > 0)
		{
			NSRange r;
			r.location = 0;
			r.length = MIN([rightstr length] - over, [rightstr length]);
			rightstr = [rightstr substringWithRange:r];
		}
		
		if ([rightstr length] > 0 && [leftstr length] < len)
		{
			[leftstr appendString:@"."];
			[leftstr appendString:rightstr];
		}
	}
	else
	{
		[leftstr appendString:vv];
	}
	
	[leftstr autorelease];
	return leftstr;
}

+ (char *)itoa:(int)n c:(char *)c
{
    char *pHead = c;
    
    int i,sign;
	
	if((sign=n)<0)
		n=-n;
    
	i=0;
	
	do
	{
		c[i++]=n%10+'0';
	}while ((n/=10)>0);
	
	if(sign<0)
		c[i++]='-';
	c[i]='\0';
    
    return pHead;
}

+ (NSString *)formatDate:(int)date flag:(NSString *)flag
{
	if (date <= 0) return @"-";
	//如20110525 ==> 11/5/25
	int day		= date % 100;
	int month	= (date / 100) % 100;
	int year	= (date / 10000);
	return [NSString stringWithFormat:@"%d%@%@%d%@%@%d", year, flag, month<10?@"0":@"", month, flag, day<10?@"0":@"", day];
}

+ (NSString *)formatDate:(NSString *)dateTime srcFormat:(NSString *)srcFormat destFormat:(NSString *)destFormat
{
    if (dateTime == nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:srcFormat];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    
    NSDate *curDataTime = [formatter dateFromString:dateTime];
    
    [formatter setDateFormat:destFormat];
    NSString *formatDate = [formatter stringFromDate:curDataTime];
    
    [formatter release];
    
    return formatDate;
}

+ (NSTimeInterval)getCurTick
{
	return [NSDate timeIntervalSinceReferenceDate];
}

//+ (NSTimeInterval)getReferenceTick
//{
//	return [NSDate dateWithTimeIntervalSinceReferenceDate:0];
//}

// NSDate* ==> numDate(20110930)
+ (int)getNumDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd"];
	NSString * sDate = [formatter stringFromDate:date];
	[formatter release];
	return [sDate intValue];
}

// numDate(20110930) ==> NSDate*
+ (NSDate *)getDateFromNumDate:(int)numDate
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyyMMdd"];
	NSDate * aDate = [formatter dateFromString:[NSString stringWithFormat:@"%d", numDate]];
	return aDate;
}

// NSDateComponents类型的weekday ==> 中国式星期几
+ (int)getCNWeekDay:(int)dateComponentsWeekDay
{
	if (dateComponentsWeekDay == 1)
		return 7;
	else
		return dateComponentsWeekDay - 1;
	//	1－－星期天
	//	2－－星期一
	//	3－－星期二
	//	4－－星期三
	//	5－－星期四
	//	6－－星期五
	//	7－－星期六
}

+ (NSDate *)IncDate:(NSDate *)date withDay:(int)day
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:day];
	NSDate * newDate = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
	[componentsToAdd release];
	return newDate;
}

// numDate: 20110930
// 返回周一的数字日期
+ (int)getBeginningOfWeekNumDate:(int)numDate
{
	NSDate *aDate = [CommonFormatFunc getDateFromNumDate:numDate];
	if (aDate == nil) return 0;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekDayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:aDate];
	int CNWeekDay = [CommonFormatFunc getCNWeekDay:[weekDayComponents weekday]];
	
	if (CNWeekDay == 1)		//星期一
		return numDate;
	else {
		NSDate * mondayDate = [CommonFormatFunc IncDate:aDate withDay:1-CNWeekDay];
		return [CommonFormatFunc getNumDate:mondayDate];
	}
}

// numDate(20110930) ==> 20110901
+ (int)getBeginningOfMonthNumDate:(int)numDate
{
	return numDate / 100 * 100 + 1;
}

// numDate: 20110930
// pweekday: 返回星期几，已转化为中国习惯。
// pweek: 一年中第几周
+ (BOOL)getWeekday:(int)numDate pweekday:(int *)pweekday pweek:(int *)pweek
{
	NSDate *aDate = [CommonFormatFunc getDateFromNumDate:numDate];
	if (aDate == nil) return NO;
	
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *weekDayComponents = [gregorian components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit) fromDate:aDate];
	NSInteger week = [weekDayComponents week];
	NSInteger weekday = [weekDayComponents weekday];
	*pweekday = [CommonFormatFunc getCNWeekDay:weekday];
	*pweek = week;
	return YES;
}

// numDate: 20110930
// pweekday: 返回星期几，已转化为中国习惯。
// pweek: 一年中第几周
+ (BOOL)getMonthday:(int)numDate pday:(int *)pday pmonth:(int *)pmonth
{
	*pday = numDate % 100;
	*pmonth = (numDate / 100) % 100;
	return YES;
}

+ (NSTimeInterval)getDateFrom:(NSString *)fromDate toDate:(NSString *)toDate;
{
    NSTimeInterval time = 0;
    
    if ([fromDate length] > 0 && [toDate length] > 0)
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * dateDeadLine = [formatter dateFromString:toDate];
        NSDate * dateNow = [formatter dateFromString:fromDate];
        time = [dateDeadLine timeIntervalSinceDate:dateNow];
        [formatter release];
    }
    
    return time;
}

+ (NSString *)getDataStrWith:(NSTimeInterval)timeNum
{
    if(timeNum >= 0)
    {
        //timeNum -- ;
        NSInteger days = ((NSInteger)timeNum) / (3600 * 24);
        NSInteger hours = (((NSInteger)timeNum) - (3600 * 24) * days) / 3600;
        NSInteger mins = (((NSInteger)timeNum) - (3600 * 24) * days - 3600 * hours) / 60;
        NSInteger seconds = ((NSInteger)timeNum) - (3600 * 24) * days - 3600 * hours - 60 * mins;
        hours += days *24;
        return [NSString stringWithFormat:@"%02d时%02d分%02d秒", hours, mins, seconds];
    }
    else
    {
        return @"--小时--分--秒";
    }
}

+ (NSString *)getDataStrWithMS:(NSTimeInterval)timeNum
{
    if(timeNum > 0)
    {
      //  timeNum -- ;
        NSInteger days = ((NSInteger)timeNum) / (3600 * 24);
        NSInteger hours = (((NSInteger)timeNum) - (3600 * 24) * days) / 3600;
        NSInteger mins = (((NSInteger)timeNum) - (3600 * 24) * days - 3600 * hours) / 60;
        NSInteger seconds = ((NSInteger)timeNum) - (3600 * 24) * days - 3600 * hours - 60 * mins;

        NSString *str = [[NSString alloc] initWithFormat:@"%02d:%02d", mins, seconds];
        return [str autorelease];
    }
    else
    {
        return @"00:00";
    }
}

+ (NSString *)getTodayStr:(NSString *)formatStr
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatStr;
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
	return todayStr;
}

+ (int)getWeekDay:(int)year month:(int)month day:(int)day
{
    int j,count = 0;
    int MonthAdd[12]    = {0,31,59,90,120,151,181,212,243,273,304,334};
     count = MonthAdd[month-1];

    count = count + day;

    if (((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) && month >= 3)
        count += 1;

    count = count + (year - 1901) * 365;

    for (j = 1901; j < year; j++)
    {
        if ((j % 4 == 0 && j % 100 != 0) || (j % 400 == 0))
            count++;
    }
    
    return ((count+1) % 7);
}

+ (unsigned int)lunarCalendarNum:(int)year month:(int)month day:(int)day
{
    unsigned int LunarCalendarDay = 0;
    int MonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    int Spring_NY,Sun_NY,StaticDayCount;
    int index,flag;

    //Spring_NY 记录春节离当年元旦的天数。
    //Sun_NY 记录阳历日离当年元旦的天数。

    if ( ((LunarCalendarTable[year-1901] & 0x0060) >> 5) == 1)
        Spring_NY = (LunarCalendarTable[year-1901] & 0x001F) - 1;
    else
        Spring_NY = (LunarCalendarTable[year-1901] & 0x001F) - 1 + 31;

    Sun_NY = MonthAdd[month-1] + day - 1;

    if ((!(year % 4)) && (month > 2)) Sun_NY++;

    //StaticDayCount记录大小月的天数 29 或30
    //index 记录从哪个月开始来计算。
    //flag 是用来对闰月的特殊处理。
    //判断阳历日在春节前还是春节后
    
    if (Sun_NY >= Spring_NY)//阳历日在春节后（含春节那天）
    {
        Sun_NY -= Spring_NY;
        month = 1;
        index = 1;
        flag = 0;

        if ( ( LunarCalendarTable[year - 1901] & (0x80000 >> (index-1)) ) ==0)
            StaticDayCount = 29;
        else
            StaticDayCount = 30;

        while (Sun_NY >= StaticDayCount)
        {
            Sun_NY -= StaticDayCount;
            index++;

            if (month == ((LunarCalendarTable[year - 1901] & 0xF00000) >> 20) )
            {
                flag = ~flag;

                if (flag == 0) month++;
            }
            else
                month++;

            if ((LunarCalendarTable[year - 1901] & (0x80000 >> (index-1))) ==0)
                StaticDayCount=29;
            else
                StaticDayCount=30;
        }

        day = Sun_NY + 1;
    }
    else //阳历日在春节前
    {
        Spring_NY -= Sun_NY;
        year--;
        month = 12;

        if (((LunarCalendarTable[year - 1901] & 0xF00000) >> 20) == 0)
            index = 12;
        else
            index = 13;

        flag = 0;

        if ((LunarCalendarTable[year - 1901] & (0x80000 >> (index-1)) ) ==0)
            StaticDayCount = 29;
        else
            StaticDayCount = 30;

        while (Spring_NY > StaticDayCount)
        {
            Spring_NY -= StaticDayCount;
            index--;
            
            if (flag == 0)
                month--;
            
            if (month == ((LunarCalendarTable[year - 1901] & 0xF00000) >> 20))
                flag = ~flag;
            
            if ( ( LunarCalendarTable[year - 1901] & (0x80000 >> (index-1)) ) ==0)
                StaticDayCount = 29;
            else
                StaticDayCount = 30;
        }
        
        day = StaticDayCount - Spring_NY + 1;
    }
    
    LunarCalendarDay |= day;
    
    LunarCalendarDay |= (month << 6);
    
//    if (month == ((LunarCalendarTable[year - 1901] & 0xF00000) >> 20))
//        return 1;
//    else
//        return 0;

    return LunarCalendarDay;
}

+ (NSArray *)lunarCalendarMonthAndDay:(unsigned int)lunarCalendarDay
{
    int nIndex1 = (lunarCalendarDay & 0x3C0) >> 6;
    int nIndex2 = lunarCalendarDay & 0x3F;
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:nIndex1], [NSNumber numberWithInt:nIndex2], nil];
}

+ (NSString *)lunarCalendarString:(int)year month:(int)month day:(int)day
{
    unsigned int lunarCalendarDay = [self lunarCalendarNum:year month:month day:day];
    NSArray *chDay = [NSArray arrayWithObjects:@"*", @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九",
                      @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九",
                      @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];

    NSArray *chMonth = [NSArray arrayWithObjects:@"*", @"正", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"腊", nil];

    int nIndex1 = (lunarCalendarDay & 0x3C0) >> 6;
    int nIndex2 = lunarCalendarDay & 0x3F;

    if (nIndex1 < [chMonth count] && nIndex1 >= 0 && nIndex2 < [chDay count] && nIndex2 >= 0)
        return [NSString stringWithFormat:@"%@月%@", [chMonth objectAtIndex:nIndex1], [chDay objectAtIndex:nIndex2]];
    
    return nil;
}

+ (NSString *)lunarCalendarString:(unsigned int)lunarCalendarDay
{
    NSArray *chDay = [NSArray arrayWithObjects:@"*", @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九",
                      @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九",
                      @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];
    
    NSArray *chMonth = [NSArray arrayWithObjects:@"*", @"正", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"腊", nil];
    
    int nIndex1 = (lunarCalendarDay & 0x3C0) >> 6;
    int nIndex2 = lunarCalendarDay & 0x3F;
    
    if (nIndex1 < [chMonth count] && nIndex1 >= 0 && nIndex2 < [chDay count] && nIndex2 >= 0)
        return [NSString stringWithFormat:@"%@月%@", [chMonth objectAtIndex:nIndex1], [chDay objectAtIndex:nIndex2]];
    
    return nil;
}

+ (NSString *)getAstroWithMonth:(int)m day:(int)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result      = nil;
    
    if (m < 1 || m > 12 || d < 1 || d > 31 || (m == 2 && d > 29) || ((m == 4 || m == 6 || m == 9 || m == 11) && d > 30))
        return result;
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}

// 如果dateStr为2012-02-23，则格式应为yyyy-MM-dd
// 如果dateStr为20120223，则格式应为yyyyMMdd
+ (BOOL)isTodayOfStrDate:(NSString *)dateStr formatStr:(NSString *)formatStr
{
	if (dateStr == nil) return NO;
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = formatStr;
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
	if (todayStr == nil) return NO;
	
	return [dateStr compare:todayStr] == NSOrderedSame;
}

+ (_int64)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    _int64 ll = 0 ;
    int  temp = 0 ;

    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }

    NSString * result = [NSString stringWithFormat:@"%lld",ll];
    return [result integerValue] ;
}

+ (float)mappingAsixYValue:(float)max min:(float)min v:(float)v top:(float)top bottom:(float)bottom
{
	float y;
	
	if (max == min)
		y = bottom;
	else if (v <= max && v >= min)
		y = bottom - (v - min)/(max - min)*(bottom - top);
	else
		y = (v < min) ? bottom : top;
	
	return y;
}

//根据Y的坐标，映射Y对应的值
+ (float)mappingValueByAsixY:(float)max min:(float)min y:(float)y top:(float)top bottom:(float)bottom
{
	float v;
	if (top == bottom)
		v = min;
	else if (top <= y && y <= bottom)
		v = max - (y - top)/(bottom - top)*(max - min);
	else 
		v = (y < top) ? max : min;
	return v;
}

+ (float)mappingAsixXValue:(float)max min:(float)min v:(float)v left:(float)left right:(float)right
{
	float x = 0;
	
	if (min <= v && v <= max)
		x = left + (v - min)/(max - min)*(right - left);
	else if (v < min)
		x = left;
	else if (v > max)
		x = right;
	
	return x;
}


+ (void)setVerticalAlignment:(UILabel *)object alignType:(int)ntype fontSize:(int)fontSize rectSize:(CGSize)rectSize
{
	CGSize maximumSize	= rectSize;
	CGSize stringSize	= [object.text sizeWithFont:[UIFont systemFontOfSize:fontSize]
                                constrainedToSize:maximumSize
                                    lineBreakMode:object.lineBreakMode];
	
	CGRect strFrame = CGRectMake(0, 0, rectSize.width, rectSize.height);
    [object setBounds:strFrame];
	
	CGSize fontSZ		= [object.text sizeWithFont: [UIFont systemFontOfSize:14]];
	double finalHeight	= fontSZ.height * object.numberOfLines;
	int newLinesToPad	= (finalHeight  - stringSize.height) / fontSZ.height;
	
	switch (ntype)
	{
		case CULabelAlignmentTop:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [object.text stringByAppendingString:@"\n"];
				[pool drain];
			}
			break;
		case CULabelAlignmentBottom:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [NSString stringWithFormat:@"\n%@",object.text];
				[pool drain];
			}
			break;
		case CULabelAlignmentCenter:
			for(int i=1; i< newLinesToPad; i++)
			{
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				object.text = [NSString stringWithFormat:@"\n%@\n",object.text];
				[pool drain];
			}
			break;
		default:
			break;
	}
}

//格式化金额
+ (NSString *)getMoneyFormatStringWith:(float)money isNeedPoint:(BOOL)point
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:ABS(money)]];
    string = [string substringFromIndex:1];
    
//    NSString * integer,* fraction;
//    if([string rangeOfString:@"."].length != 0) //有小数部分
//    {
//        integer = [[string componentsSeparatedByString:@"."] objectAtIndex:0];
//        fraction = [[string componentsSeparatedByString:@"."] objectAtIndex:1];
//        if([fraction length]<2)
//        {
//            fraction = [NSString stringWithFormat:@"%@0",fraction];
//        }
//        fraction = [fraction substringToIndex:2];
//    }
//    else
//    {
//        integer = string;
//        fraction = @"00";
//    }
//
//    if(point)     // 如果需要小数点
//    {
//        string = [NSString stringWithFormat:@"%@.%@",integer,fraction];
//    }
//    else
//        string = [NSString stringWithString:integer];
//    
    [formatter release];
    return string;
}

+ (NSArray *)seperateStringByLen:(NSString *)content len:(int)len
{
    NSArray *retVal = nil;
    if (len > 0)
    {
        int cntLen  = [content length];
        int offset  = cntLen % len == 0 ? 0 : 1;
        int count   = cntLen / len + offset;
        
        NSMutableArray *keyArr = [NSMutableArray array];
        
        if (cntLen / len > 0)
        {
            for (int i = 0; i < count; i++)
            {
                [keyArr addObject:[[content substringFromIndex:i * len] substringToIndex:MIN(len, cntLen-i*len)]];
            }
            
            retVal = keyArr;
        }
        else
            retVal  = [NSArray arrayWithObjects:content, nil];
    }
    
    return retVal;
}

//千位分割符
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString

{
    if (digitString.length <= 3) {
        
        return digitString;
        
    } else {
        
        NSMutableString *processString = [NSMutableString stringWithString:digitString];
        int location = processString.length - 3;
        
        NSMutableArray *processArray = [[[NSMutableArray alloc]init]autorelease];
        
        while (location >= 0) {
            
            NSString *temp = [processString substringWithRange:NSMakeRange(location, 3)];
            
            
            [processArray addObject:temp];
            
            if (location < 3 && location > 0)
                
            {
                
                NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
                
                [processArray addObject:t];
                
            }
            
            location -= 3;
            
        }
        
        NSMutableArray *resultsArray = [[[NSMutableArray alloc]init]autorelease];
        
        int k = 0;
        
        for (NSString *str in processArray)
            
        {
            
            k++;
            
            NSMutableString *tmp = [NSMutableString stringWithString:str];
            
            if (str.length > 2 && k < processArray.count )
                
            {
                
                [tmp insertString:@"," atIndex:0];
                
                [resultsArray addObject:tmp];
                
            } else {
                
                [resultsArray addObject:tmp];
                
            }
            
        }
        NSMutableString *resultString = [NSMutableString string];
        
        for (int i = resultsArray.count - 1 ; i >= 0; i--)
            
        {
            
            NSString *tmp = [resultsArray objectAtIndex:i];
            
            [resultString appendString:tmp];
            
        }
        
        return resultString;
        
    }
    
}

+ (NSString *)getNewStrWithSepStr:(NSString *)sepStr recvStr:(NSString *)recvStr
{
    if([sepStr length] == 0)
    {
        return recvStr;
    }
    int count = [recvStr length];
    NSMutableString * str = [NSMutableString stringWithFormat:@""];
    for(int i = 0; i < count; i++)
    {
        [str appendString:[recvStr substringWithRange:NSMakeRange(i, 1)]];
        if(i != count - 1)
            [str appendString:sepStr];
    }
    
    return str;
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
