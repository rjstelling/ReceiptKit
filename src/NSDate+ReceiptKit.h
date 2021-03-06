//
//  NSDate+ReceiptKit
//  ReceiptKit
//
//  Created by Richard Stelling on 01/10/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ReceiptKit)

+ (NSDate *)dateFromReceiptDateString:(NSString *)dateStr;

- (NSString *)shortDate;

@end
