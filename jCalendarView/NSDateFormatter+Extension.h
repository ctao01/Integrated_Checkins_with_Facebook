//
//  NSDate(Extension).h
//  jCalendarFrame
//
//  Created by Joy Tao on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extension)

+ (NSString *) shortStyleStringFromDate:(NSDate*)date;
+ (NSDate *) shortStyleDateFromString:(NSString*)string;


+ (NSDate *) dateFromISO8601String:(NSString*)string;
+ (NSString *) stringFromISO8601Date:(NSDate*)date;

+ (NSString *) calendarStringFormDate:(NSDate*)date;
+ (NSDate *) calendarDateFromString:(NSString *)string;

+ (NSString *) sectionHeaderStringFormDate:(NSDate*)date;
+ (NSDate *) sectionDateFromString:(NSString *)string;

+ (NSString *) timestampStringFromeDate:(NSDate*)date;


+(NSString*) buttonTitleStringFromDate:(NSDate*)date;

@end
