//
//  ATData.h
//  AT
//
//  Created by William Locke on 9/17/15.
//  Copyright (c) 2015 AT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATDate : NSObject

+(NSDate *)dateFromString:(NSString *)string;
+(BOOL)isDatePast:(NSDate *)date;

@end
