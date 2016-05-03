//
//  ATData.m
//  AT
//
//  Created by William Locke on 9/17/15.
//  Copyright (c) 2015 AT. All rights reserved.
//

#import "ATDate.h"

@implementation ATDate

+(NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *date;
    [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *tmpString = [string substringToIndex:[string length]-4];
    date = [df dateFromString:tmpString];
    if (date) {
        return date;
    }
	NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
	[date_formater setLocale:[NSLocale systemLocale]];
	[date_formater setDateFormat:@"Z"];
	string = [string stringByReplacingOccurrencesOfString:@"Z"
											   withString:[@"" stringByAppendingFormat:@" %@", @"+0000"]];
	string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
	date = [df dateFromString:string];
	return [self localizedDateFromSystemDate:date];
}

+(NSDate *)localizedDateFromSystemDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale systemLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStringWithoutTimezone = [df stringFromDate:date];
    [df setLocale:[NSLocale currentLocale]];
    return [df dateFromString:dateStringWithoutTimezone];
}

+(BOOL)isDatePast:(NSDate *)date{
	return ([date timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970]) < 0;
}

@end
