//
//  NSDate+ReceiptKit.m
//  ReceiptKit
//
//  Created by Richard Stelling on 01/10/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSDate+ReceiptKit.h"

@implementation NSDate (ReceiptKit)

+ (NSDate *)dateFromReceiptDateString:(NSString *)dateStr
{
    NSParameterAssert(dateStr);
    
    if(dateStr.length == 0)
        return nil;
    
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [formatter setTimeZone:timeZone];
    });

    return [formatter dateFromString:dateStr];
}

- (NSString *)shortDate
{
    return
    [NSDateFormatter localizedStringFromDate:self
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
}

@end
