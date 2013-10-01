//
//  NSDate+Receipt.m
//  ReceiptKit
//
//  Created by Richard Stelling on 01/10/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSDate+Receipt.h"

@implementation NSDate (Receipt)

+ (NSDate *)dateFromReceiptDateString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
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
