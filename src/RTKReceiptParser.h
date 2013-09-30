//
//  RTKReceiptParser.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTKPurchaseInformation;

@interface RTKReceiptParser : NSObject

@property (readonly, nonatomic) RTKPurchaseInformation *purchaseInfo;

- (instancetype)initWithReceipt:(NSData *)receiptData certificate:(NSData *)certificateData;

/// Do not read the values of `bundleIdentifier` or `bundleVersion` directly
/// from the Info.plist, as it is too eay to alter. Instead, hard code the
/// bundle identifier and version, preferably in an obfuscated way.
- (BOOL)isReceiptValidForDevice:(NSString *)bundleIdentifier;

@end
