//
//  NSDate(Extension).m
//  jCalendarFrame
//
//  Created by Joy Tao on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+Extension.h"

@implementation NSDateFormatter(Extension)

#pragma mark - Standard

+ (NSString *) shortStyleStringFromDate:(NSDate*)date
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateStyle:NSDateFormatterShortStyle];
    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString * str = [outputFormatter stringFromDate:date];
    
    return str;
}

+ (NSDate *) shortStyleDateFromString:(NSString*)string
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateStyle:NSDateFormatterShortStyle];
    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [outputFormatter dateFromString:string];

    return date;
}

#pragma mark - ISO-8601 date-time datetime 

+ (NSDate *) dateFromISO8601String:(NSString*)string
{
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; 
    
    NSDate * date = [inputFormatter dateFromString:string];
    
    return date;
}

+ (NSString *) stringFromISO8601Date:(NSDate*)date
{
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString * str = [inputFormatter stringFromDate:date];
    
    return str;
}

#pragma mark Calendar

+ (NSString *) calendarStringFormDate:(NSDate*)date
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd 00:00:00 ZZ"];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString * timeStr = [outputFormatter stringFromDate:date];
    
    return timeStr;
}

+ (NSDate *) calendarDateFromString:(NSString *)string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate * newDate = [dateFormatter dateFromString:string];
    
    return newDate;
}

#pragma mark Section Header

+(NSString*) buttonTitleStringFromDate:(NSDate*)date
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MMMM"];
    [outputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString * timeStr = [outputFormatter stringFromDate:date];
    
    return timeStr;
}


+ (NSString *) sectionHeaderStringFormDate:(NSDate*)date
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-yyyy"];
    [outputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString * timeStr = [outputFormatter stringFromDate:date];
    
    return timeStr;
}

+ (NSDate *) sectionDateFromString:(NSString *)string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate * newDate = [dateFormatter dateFromString:string];
    
    return newDate;
}


+(NSString *) timestampStringFromeDate:(NSDate*)date
{
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setAMSymbol:@"AM"];
    [outputFormatter setPMSymbol:@"PM"];
    [outputFormatter setDateFormat:@"hh a"];
    NSString * timeStr = [outputFormatter stringFromDate:date];
    
    return timeStr;
}

@end
